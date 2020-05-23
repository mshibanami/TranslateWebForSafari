//
//  TranslationMedia.swift
//  TranslateWebForSafari Extension
//
//  Created by Manabu Nakazawa on 23/5/20.
//  Copyright © 2020 Manabu Nakazawa. All rights reserved.
//

import Foundation

enum TranslationMedia {
    case text(String)
    case page(URL)
    
    func makeURL(for service: TranslationService, langauge: Language) -> URL {
        switch service {
        case .baidu:
            return makeURLForBaidu(for: langauge)
        case .bing:
            return makeURLForBing(for: langauge)
        case .deepL:
            return makeURLForDeepL(for: langauge)
        case .google:
            return makeURLForGoogle(for: langauge)
        }
    }

    private func makeURLForBaidu(for language: Language) -> URL {
        switch self {
        case let .text(text):
            //https://www.deepl.com/translator#auto/fr/sdfsd
            var urlComponents = URLComponents(string: "https://fanyi.baidu.com/")!
            urlComponents.fragment = "auto/\(language.id)/\(text)"
            return urlComponents.url!
        case .page:
            assertionFailure("Baidu doesn't support page translation")
            return makeURLForGoogle(for: language)
        }
    }
    
    private func makeURLForBing(for language: Language) -> URL {
        return URL(string: "https://example.com/")!
    }
    
    private func makeURLForDeepL(for language: Language) -> URL {
        switch self {
        case let .text(text):
            //https://www.deepl.com/translator#auto/fr/sdfsd
            var urlComponents = URLComponents(string: "https://www.deepl.com/translator")!
            urlComponents.fragment = "auto/\(language.id)/\(text)"
            return urlComponents.url!
        case .page:
            assertionFailure("DeepL doesn't support page translation")
            return makeURLForGoogle(for: language)
        }
    }
    
    private func makeURLForGoogle(for language: Language) -> URL {
        var urlComponents = URLComponents(string: "https://translate.google.com/")!
        var queryItems = [
            URLQueryItem(name: "tl", value: language.id)
        ]
        switch self {
        case let .text(text):
            urlComponents.path = "/"
            queryItems.append(contentsOf: [
                URLQueryItem(name: "text", value: text)
            ])
        case let .page(url):
            urlComponents.path = "/translate"
            let urlString = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            queryItems.append(contentsOf: [
                URLQueryItem(name: "u", value: urlString)
            ])
        }
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}
