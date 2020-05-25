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
    
    fileprivate typealias QueryParameter = (key: String, encodedValue: String)
    
    func makeURL(for service: TranslationService, langauge: Language) -> URL? {
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

    private func makeURLForBaidu(for language: Language) -> URL? {
        switch self {
        case let .text(text):
            let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            return URL(string: "https://fanyi.baidu.com/#auto/\(language.id)/\(encodedText)")
        case .page:
            assertionFailure("Baidu doesn't support page translation")
            return makeURLForGoogle(for: language)
        }
    }
    
    private func makeURLForBing(for language: Language) -> URL? {
        var urlComponents: URLComponents
        var percentEncodedQueries: [QueryParameter] = [
            (key: "to", encodedValue: language.id)
        ]
        switch self {
        case let .text(text):
            urlComponents = URLComponents(string: "https://www.bing.com/translator/")!
            guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                break
            }
            percentEncodedQueries.append((key: "text", encodedValue: encodedText))
        case let .page(url):
            urlComponents = URLComponents(string: "https://www.translatetheweb.com/")!
            guard let encodedURL = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                break
            }
            percentEncodedQueries.append((key: "a", encodedValue: encodedURL))
        }
        urlComponents.percentEncodedQuery = percentEncodedQueries.map({ "\($0)=\($1)" }).joined(separator: "&")
        return urlComponents.url
    }
    
    private func makeURLForDeepL(for language: Language) -> URL? {
        switch self {
        case let .text(text):
            let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            return URL(string: "https://www.deepl.com/translator#auto/\(language.id)/\(encodedText)")
        case .page:
            assertionFailure("DeepL doesn't support page translation")
            return makeURLForGoogle(for: language)
        }
    }
    
    private func makeURLForGoogle(for language: Language) -> URL? {
        var parameters: [QueryParameter] = [
            (key: "tl", encodedValue: language.id)
        ]
        switch self {
        case let .text(text):
            guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                break
            }
            parameters.append((key: "text", encodedValue: encodedText))
            return URL(string: "https://translate.google.com/?\(parameters.makeQueryString())")
        case let .page(url):
            guard let encodedURL = url.absoluteString.removingPercentEncoding?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                break
            }
            parameters.append((key: "u", encodedValue: encodedURL))
            return URL(string: "https://translate.google.com/translate?\(parameters.makeQueryString())")
        }
        return nil
    }
}

private extension Array where Element == TranslationMedia.QueryParameter {
    func makeQueryString() -> String {
        return map({ "\($0)=\($1)" }).joined(separator: "&")
    }
}
