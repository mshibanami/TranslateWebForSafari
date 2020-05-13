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
    
    private enum TranslationMediaType {
        case text(String)
        case webpage(URL)
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
                with: makeURLForGoogleTranslate(mediaType: .text(selectedText)),
                makeActiveIfPossible: true)
        } else {
            window.getActiveTab { tab in
                tab?.getActivePage { page in
                    page?.getPropertiesWithCompletionHandler { [weak self] properties in
                        guard let self = self, let url = properties?.url else {
                            return
                        }
                        page?.dispatchMessageToScript(
                            withName: "openURL",
                            userInfo: ["url": self.makeURLForGoogleTranslate(mediaType: .webpage(url)).absoluteString])
                    }
                }
            }
        }
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        validationHandler(true, "")
    }
        
    private func makeURLForGoogleTranslate(mediaType: TranslationMediaType) -> URL {
        var urlComponents = URLComponents(string: "https://translate.google.com/")!
        switch mediaType {
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
