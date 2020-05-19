// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    private class State {
        static let shared = State()
        
        var selectedText: String? {
            didSet {
                selectedText = selectedText?.trimmingCharacters(in: .whitespacesAndNewlines)
            }
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
        }
    }
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        if let selectedText = State.shared.selectedText, !selectedText.isEmpty {
            window.openTab(
                with: TranslationMedia.text(selectedText).makeURLForGoogleTranslate(),
                makeActiveIfPossible: true)
        } else {
            window.openTranslatedPageForActivePage()
        }
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        validationHandler(true, "")
    }
    
    override func contextMenuItemSelected(withCommand command: String, in page: SFSafariPage, userInfo: [String : Any]? = nil) {
        guard let command = ContextMenuCommand(rawValue: command) else {
            return
        }
        page.getContainingTab {
            $0.getContainingWindow {
                switch command {
                case .translatePage:
                    $0?.openTranslatedPageForActivePage()
                case .translateSelectedText:
                    guard let text = State.shared.selectedText else {
                        return
                    }
                    $0?.openPage(for: .text(text))
                }
            }
        }
    }
    
    override func validateContextMenuItem(withCommand command: String, in page: SFSafariPage, userInfo: [String : Any]? = nil, validationHandler: @escaping (Bool, String?) -> Void) {
        guard let command = ContextMenuCommand(rawValue: command) else {
            return
        }
        switch command {
        case .translateSelectedText:
            if let text = State.shared.selectedText, !text.isEmpty {
                validationHandler(false, L10n.contextMenuTranslateText(with: text))
            } else {
                validationHandler(true, nil)
            }
        case .translatePage:
            validationHandler(false, L10n.contextMenuTranslatePage)
        }
    }
}

private enum TranslationMedia {
    case text(String)
    case webpage(URL)
    
    func makeURLForGoogleTranslate() -> URL {
        var urlComponents = URLComponents(string: "https://translate.google.com/")!
        switch self {
        case let .text(text):
            urlComponents.path = "/"
            urlComponents.queryItems = [
                URLQueryItem(name: "text", value: text)
            ]
        case let .webpage(url):
            urlComponents.path = "/translate"
            let urlString = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            urlComponents.queryItems = [
                URLQueryItem(name: "u", value: urlString)
            ]
        }
        return urlComponents.url!
    }
}

private extension SFSafariWindow {
    func openTranslatedPageForActivePage() {
        getActiveTab {
            $0?.getActivePage {
                $0?.getPropertiesWithCompletionHandler { properties in
                    guard let url = properties?.url else {
                        return
                    }
                    self.openPage(for: .webpage(url))
                }
            }
        }
    }
    
    func openPage(for media: TranslationMedia) {
        switch media {
        case .text:
            openTab(with: media.makeURLForGoogleTranslate(), makeActiveIfPossible: true)
        case .webpage:
            getActiveTab {
                $0?.navigate(to: media.makeURLForGoogleTranslate())
            }
        }
    }
}

private enum ContextMenuCommand: String {
    case translatePage = "translatePage"
    case translateSelectedText = "translateSelectedText"
}
