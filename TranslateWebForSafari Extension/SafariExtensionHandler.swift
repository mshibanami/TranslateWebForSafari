// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import SafariServices
import ShortcutRecorder

class SafariExtensionHandler: SFSafariExtensionHandler {
    private class State {
        static let shared = State()
        
        var selectedText: String? {
            didSet {
                let text = selectedText?.trimmingCharacters(in: .whitespacesAndNewlines)
                selectedText = (text?.isEmpty ?? true) ? nil : text
            }
        }
        
        func makeShortenedSelectedText() -> String? {
            guard let selectedText = selectedText else {
                return nil
            }
            let maxTextLength = 20
            var text = selectedText.replacingOccurrences(of: "\n", with: " ")
            if text.count > maxTextLength {
                text = text.prefix(maxTextLength) + "…"
            }
            return text
        }
        
        private init() {}
    }
    
    @available(OSX 10.14, *)
    static let languageDetector = LanguageDetector()
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        Log.info("\(#function) - \(messageName)")
        page.getPropertiesWithCompletionHandler { [weak self] properties in
            guard let self = self else {
                return
            }
            guard properties?.isActive ?? false else {
                Log.info("Finished message handling without doing anything. (The page isn't active.)")
                return
            }
            switch messageName {
            case "selectionChanged":
                self.selectionChanged(page: page, userInfo: userInfo)
            case "pageTranslationPageTextDispatched":
                self.pageTranslationPageTextDispatched(userInfo: userInfo)
            case "shortcutReceived":
                self.shortcutReceived(page: page, userInfo: userInfo ?? [:])
            default:
                Log.warn("Message name \(messageName) is not supported")
            }
        }
    }
    
    private func selectionChanged(page: SFSafariPage, userInfo: [String: Any]?) {
        let selectedTextKey = "selectedText"
        let selectedTextOptional = (userInfo ?? [:])[selectedTextKey]
        guard let selectedText = selectedTextOptional as? String else {
            assertionFailure("Unexpected data type or it's not set: \(selectedTextKey)=\(String(describing: selectedTextOptional))")
            return
        }
        State.shared.selectedText = selectedText
        page.getContainingWindow {
            guard let window = $0 else {
                return
            }
            self.updateToolbarItemLabel(in: window)
        }
    }
    
    private func pageTranslationPageTextDispatched(userInfo: [String: Any]?) {
        let textKey = "text"
        let textOptional = (userInfo ?? [:])[textKey]
        guard let text = textOptional as? String else {
            assertionFailure("Unexpected data type or it's not set: \(textKey)=\(String(describing: textOptional))")
            return
        }
        
        let language: Language?
        if #available(OSX 10.14, *) {
            language = SafariExtensionHandler.languageDetector.detect(
                text: text,
                for: UserDefaults.group.pageTranslationService)
        } else {
            language = nil
        }
        Log.info("Detected Language: \(language?.id ?? "nil")")
        SFSafariApplication.getActiveWindow {
            $0?.openTranslatedPageForActivePage(language: language)
        }
    }
    
    private func shortcutReceived(page: SFSafariPage, userInfo: [String: Any]) {
        guard let key = userInfo["key"] as? String,
            let isCommandPressed = userInfo["isCommandPressed"] as? Bool,
            let isShiftPressed = userInfo["isShiftPressed"] as? Bool,
            let isControlPressed = userInfo["isControlPressed"] as? Bool,
            let isOptionPressed = userInfo["isOptionPressed"] as? Bool else {
                assertionFailure("Unexpected data type or it's not set.")
                return
        }
        var keyEquivalent = ""
        keyEquivalent.append(isCommandPressed ? "⌘" : "")
        keyEquivalent.append(isShiftPressed ? "⇧" : "")
        keyEquivalent.append(isControlPressed ? "^" : "")
        keyEquivalent.append(isOptionPressed ? "⌥" : "")
        keyEquivalent.append(key)
        
        guard let shortcut = Shortcut(keyEquivalent: keyEquivalent) else {
            Log.warn("Failed to create shortcut from \(keyEquivalent)")
            return
        }
        Log.debug("shortcut: \(shortcut)")
        let group = UserDefaults.group
        page.getContainingWindow { [weak self] window in
            guard let self = self, let window = window else {
                return
            }
            switch shortcut {
            case group.pageTranslationShortcut:
                window.triggerPageTranslation()
            case group.textTranslationShortcut:
                self.openTextTranslationPageIfSelected(window: window)
            case group.textOrPageTranslationShortcut:
                self.openTranslatedTextOrPage(window: window)
            default:
                Log.debug("No action found for the shortcut \(shortcut)")
                return
            }
        }
    }
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        Log.info("\(#function)")
        switch UserDefaults.group.toolbarItemBehavior {
        case .alwaysTranslatePage:
            window.triggerPageTranslation()
        case .alwaysTranslateSelectedText:
            openTextTranslationPageIfSelected(window: window)
        case .translateTextIfSelected:
            openTranslatedTextOrPage(window: window)
        }
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        window.getActivePage {
            $0?.dispatchMessageToScript(withName: "updateSelection")
            validationHandler(true, "")
        }
    }
    
    override func contextMenuItemSelected(withCommand command: String, in page: SFSafariPage, userInfo: [String : Any]? = nil) {
        guard let command = ContextMenuCommand(rawValue: command) else {
            return
        }
        page.getContainingWindow {
            guard let window = $0 else {
                return
            }
            switch command {
            case .translatePage:
                window.triggerPageTranslation()
            case .translateSelectedText:
                self.openTextTranslationPageIfSelected(window: window)
            }
        }
    }
    
    override func validateContextMenuItem(withCommand command: String, in page: SFSafariPage, userInfo: [String : Any]? = nil, validationHandler: @escaping (Bool, String?) -> Void) {
        guard let command = ContextMenuCommand(rawValue: command) else {
            return
        }
        switch command {
        case .translateSelectedText:
            if let _ = State.shared.selectedText {
                validationHandler(false, L10n.menuTranslateText(with: State.shared.makeShortenedSelectedText() ?? ""))
            } else {
                validationHandler(true, nil)
            }
        case .translatePage:
            validationHandler(false, L10n.contextMenuTranslatePage)
        }
    }
    
    private func updateToolbarItemLabel(in window: SFSafariWindow) {
        window.getToolbarItem {
            if let _ = State.shared.selectedText {
                $0?.setLabel(L10n.menuTranslateText(with: State.shared.makeShortenedSelectedText() ?? ""))
            } else {
                $0?.setLabel(L10n.toolbarItemTranslatePage)
            }
        }
    }
    
    @discardableResult
    private func openTextTranslationPageIfSelected(window: SFSafariWindow) -> Bool {
        guard let selectedText = State.shared.selectedText else {
            Log.info("Failed to translate selection because no selection")
            return false
        }
        
        let sourceLanguage: Language?
        if #available(OSX 10.14, *) {
            sourceLanguage = Self.languageDetector.detect(
                text: selectedText,
                for: UserDefaults.group.textTranslationService)
        } else {
            sourceLanguage = nil
        }
        window.openPage(for: .text(selectedText, sourceLanguage))
        return true
    }
    
    private func openTranslatedTextOrPage(window: SFSafariWindow) {
        if !openTextTranslationPageIfSelected(window: window) {
            window.triggerPageTranslation()
        }
    }
}

private extension SFSafariPage {
    func getContainingWindow(completionHandler: @escaping (SFSafariWindow?) -> Void) {
        if Consts.usesMojaveCompatibleAPIOnly {
            SFSafariApplication.getActiveWindow {
                guard let window = $0 else {
                    completionHandler(nil)
                    return
                }
                window.getActiveTab(completionHandler: {
                    guard self == $0 else {
                        completionHandler(nil)
                        return
                    }
                    completionHandler(window)
                })
            }
        } else {
            getContainingTab {
                $0.getContainingWindow(completionHandler: completionHandler)
            }
        }
    }
}

private extension SFSafariWindow {
    func triggerPageTranslation() {
        getActivePage {
            $0?.dispatchMessageToScript(withName: "pageTranslationGetPageText")
        }
    }
    
    func openTranslatedPageForActivePage(language: Language?) {
        getActivePage { page in
            page?.getPropertiesWithCompletionHandler { properties in
                guard let url = properties?.url else {
                    return
                }
                self.openPage(for: .page(url, language))
            }
        }
    }
    
    func openPage(for media: TranslationMedia) {
        let settings = UserDefaults.group

        guard let url = media.makeURL(
            for: settings.translationService(for: media),
            targetLanguage: settings.language(for: media)) else {
                return
        }
        
        let behavior: TransitionBehavior
        switch media {
        case .text:
            behavior = settings.textTranslationTransitionBehavior
        case .page:
            behavior = settings.pageTranslationTransitionBehavior
        }
        
        switch behavior {
        case .currentTab:
            getActiveTab {
                $0?.mojaveCompatibleNavigate(to: url)
            }
        case .newTab:
            openTab(with: url, makeActiveIfPossible: true)
        }
        AppRatingSettings.incrementTranslationCount()
    }
    
    func getActivePage(completionHandler: @escaping (SFSafariPage?) -> Void) {
        getActiveTab {
            guard let tab = $0 else {
                completionHandler(nil)
                return
            }
            tab.getActivePage {
                completionHandler($0)
            }
        }
    }
}

extension SFSafariTab {
    func mojaveCompatibleNavigate(to url: URL) {
        if Consts.usesMojaveCompatibleAPIOnly {
            getActivePage {
                $0?.dispatchMessageToScript(
                    withName: "navigate",
                    userInfo: ["url": url.absoluteString])
            }
        } else {
            navigate(to: url)
        }
    }
}

private enum ContextMenuCommand: String {
    case translatePage = "translatePage"
    case translateSelectedText = "translateSelectedText"
}
