//
//  TranslationMedia.swift
//  TranslateWebForSafari Extension
//
//  Created by Manabu Nakazawa on 23/5/20.
//  Copyright © 2020 Manabu Nakazawa. All rights reserved.
//

import Foundation

enum TranslationMedia {
    case text(String, Language?)
    case page(URL, Language?)
    
    fileprivate typealias QueryParameter = (key: String, encodedValue: String)
    
    var sourceLanguage: Language? {
        switch self {
        case let .text(_, language):
            return language
        case let .page(_, language):
            return language
        }
    }
    
    func makeURL(for service: TranslationService, targetLanguage: Language) -> URL? {
        switch service {
        case .baidu:
            return makeURLForBaidu(targetLanguage: targetLanguage)
        case .bing:
            return makeURLForBing(targetLanguage: targetLanguage)
        case .deepL:
            return makeURLForDeepL(targetLanguage: targetLanguage)
        case .google:
            return makeURLForGoogle(targetLanguage: targetLanguage)
        }
    }

    private func makeURLForBaidu(targetLanguage: Language) -> URL? {
        switch self {
        case let .text(text, sourceLanguage):
            let sourceID = sourceLanguage?.id ?? "auto"
            let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            return URL(string: "https://fanyi.baidu.com/#\(sourceID)/\(targetLanguage.id)/\(encodedText)")
        case .page:
            assertionFailure("Baidu doesn't support page translation")
            return makeURLForGoogle(targetLanguage: targetLanguage)
        }
    }
    
    private func makeURLForBing(targetLanguage: Language) -> URL? {
        var urlComponents: URLComponents
        var percentEncodedQueries: [QueryParameter] = [
            (key: "to", encodedValue: targetLanguage.id),
            (key: "from", encodedValue: sourceLanguage?.id ?? "auto")
        ]
        switch self {
        case let .text(text, _):
            urlComponents = URLComponents(string: "https://www.bing.com/translator/")!
            guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                break
            }
            percentEncodedQueries.append((key: "text", encodedValue: encodedText))
        case let .page(url, _):
            urlComponents = URLComponents(string: "https://www.translatetheweb.com/")!
            guard let encodedURL = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                break
            }
            percentEncodedQueries.append((key: "a", encodedValue: encodedURL))
        }
        urlComponents.percentEncodedQuery = percentEncodedQueries.map({ "\($0)=\($1)" }).joined(separator: "&")
        return urlComponents.url
    }
    
    private func makeURLForDeepL(targetLanguage: Language) -> URL? {
        switch self {
        case let .text(text, sourceLanguage):
            let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            let sourceCode = sourceLanguage?.id ?? "auto"
            return URL(string: "https://www.deepl.com/translator#\(sourceCode)/\(targetLanguage.id)/\(encodedText)")
        case .page:
            assertionFailure("DeepL doesn't support page translation")
            return makeURLForGoogle(targetLanguage: targetLanguage)
        }
    }
    
    private func makeURLForGoogle(targetLanguage: Language) -> URL? {
        var parameters: [QueryParameter] = [
            (key: "tl", encodedValue: targetLanguage.id),
            (key: "sl", encodedValue: sourceLanguage?.id ?? "auto")
        ]
        switch self {
        case let .text(text, _):
            guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                break
            }
            parameters.append((key: "text", encodedValue: encodedText))
            return URL(string: "https://translate.google.com/?\(parameters.makeQueryString())")
        case let .page(url, _):
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
