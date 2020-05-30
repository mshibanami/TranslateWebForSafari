// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import SafariServices

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
    
    static let languageDetector = LanguageDetector()
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        page.getPropertiesWithCompletionHandler { properties in
            guard messageName == "selectionChanged" else {
                assertionFailure("Message name \(messageName) is not supported")
                return
            }
            let selectedTextKey = "selectedText"
            let selectedTextOptional = (userInfo ?? [:])[selectedTextKey]
            guard let selectedText = selectedTextOptional as? String else {
                assertionFailure("Unexpected data type or it's not set: \(String(describing: selectedTextOptional))")
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
    }
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        switch UserDefaults.group.toolbarItemBehavior {
        case .alwaysTranslatePage:
            window.openTranslatedPageForActivePage()
        case .alwaysTranslateSelectedText:
            openTextTranslationPageIfSelected(window: window)
        case .translateTextIfSelected:
            if !openTextTranslationPageIfSelected(window: window) {
                window.openTranslatedPageForActivePage()
            }
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
                window.openTranslatedPageForActivePage()
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
    func openTextTranslationPageIfSelected(window: SFSafariWindow) -> Bool {
        guard let selectedText = State.shared.selectedText else {
            return false
        }
        let sourceLanguage = Self.languageDetector.detect(
            text: selectedText,
            for: UserDefaults.group.textTranslationService)
        window.openPage(for: .text(selectedText, sourceLanguage))
        return true
    }
}

private extension SFSafariPage {
    func getContainingWindow(completionHandler: @escaping (SFSafariWindow?) -> Void) {
        getContainingTab {
            $0.getContainingWindow(completionHandler: completionHandler)
        }
    }
}

private extension SFSafariWindow {
    func openTranslatedPageForActivePage() {
        getActiveTab { tab in
            tab?.getActivePage { page in
                page?.getPropertiesWithCompletionHandler { properties in
                    guard let url = properties?.url else {
                        return
                    }
                    self.openPage(for: .page(url, nil)) // TODO: calc from page
                }
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
        
        switch media {
        case .text:
            openTab(with: url, makeActiveIfPossible: true)
        case .page:
            getActiveTab {
                $0?.navigate(to: url)
            }
        }
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

private enum ContextMenuCommand: String {
    case translatePage = "translatePage"
    case translateSelectedText = "translateSelectedText"
}
