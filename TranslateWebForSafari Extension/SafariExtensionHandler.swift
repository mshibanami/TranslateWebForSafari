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
            let maxTextLength = 100
            var text = selectedText.replacingOccurrences(of: "\n", with: " ")
            if text.count > maxTextLength {
                text = text.prefix(maxTextLength) + "…"
            }
            return text
        }
        
        private init() {}
    }
    
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
        if let selectedText = State.shared.selectedText {
            window.openPage(for: .text(selectedText))
        } else {
            window.openTranslatedPageForActivePage()
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
            switch command {
            case .translatePage:
                $0?.openTranslatedPageForActivePage()
            case .translateSelectedText:
                guard let text = State.shared.selectedText else {
                    assertionFailure()
                    return
                }
                $0?.openPage(for: .text(text))
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
                validationHandler(false, L10n.contextMenuTranslateText(with: State.shared.makeShortenedSelectedText() ?? ""))
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
                $0?.setLabel(L10n.toolbarItemTranslateText(with: State.shared.makeShortenedSelectedText() ?? ""))
            } else {
                $0?.setLabel(L10n.toolbarItemTranslatePage)
            }
        }
    }
}

private enum TranslationMedia {
    case text(String)
    case webpage(URL)
    
    func makeURL(for service: TranslationService, translateTo: Language) -> URL {
        switch service {
        case .baidu:
            return makeURLForBaidu(translateTo: translateTo)
        case .bing:
            return makeURLForBing(translateTo: translateTo)
        case .deepL:
            return makeURLForDeepL(translateTo: translateTo)
        case .google:
            return makeURLForGoogle(translateTo: translateTo)
        }
    }

    private func makeURLForBaidu(translateTo: Language) -> URL {
        return URL(string: "https://example.com/")!
    }
    
    private func makeURLForBing(translateTo: Language) -> URL {
        return URL(string: "https://example.com/")!
    }
    
    private func makeURLForDeepL(translateTo: Language) -> URL {
        return URL(string: "https://example.com/")!
    }
    
    private func makeURLForGoogle(translateTo: Language) -> URL {
        var urlComponents = URLComponents(string: "https://translate.google.com/")!
        var queryItems = [
            URLQueryItem(name: "tl", value: translateTo.id)
        ]
        switch self {
        case let .text(text):
            urlComponents.path = "/"
            queryItems.append(contentsOf: [
                URLQueryItem(name: "text", value: text)
            ])
        case let .webpage(url):
            urlComponents.path = "/translate"
            let urlString = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            queryItems.append(contentsOf: [
                URLQueryItem(name: "u", value: urlString)
            ])
        }
        urlComponents.queryItems = queryItems
        NSLog("★URL: \(urlComponents.url)")
        return urlComponents.url!
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
                    self.openPage(for: .webpage(url))
                }
            }
        }
    }
    
    func openPage(for media: TranslationMedia) {
        let settings = UserDefaults.group

        let url = media.makeURL(
            for: settings.pageTranslationService,
            translateTo: settings.pageTranslateTo)
        
        switch media {
        case .text:
            openTab(with: url, makeActiveIfPossible: true)
        case .webpage:
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
