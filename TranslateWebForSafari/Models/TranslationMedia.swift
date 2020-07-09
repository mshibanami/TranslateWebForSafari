// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import Foundation

enum TranslationMedia {
    case text(String, Language?)
    case page(URL, Language?)
    
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
        case .papago:
            return makeURLForPapago(targetLanguage: targetLanguage)
        case .yandex:
            return makeURLForYandex(targetLanguage: targetLanguage)
        }
    }

    private func makeURLForBaidu(targetLanguage: Language) -> URL? {
        switch self {
        case let .text(text, sourceLanguage):
            let sourceID = sourceLanguage?.id ?? "auto"
            let encodedText = text.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserved) ?? ""
            return URL(string: "https://fanyi.baidu.com/#\(sourceID)/\(targetLanguage.id)/\(encodedText)")
        case .page:
            assertionFailure("Baidu doesn't support page translation")
            return makeURLForGoogle(targetLanguage: targetLanguage)
        }
    }
    
    private func makeURLForBing(targetLanguage: Language) -> URL? {
        var urlComponents: URLComponents
        var percentEncodedQueries: [URLQueryParameter] = [
            (key: "to", value: targetLanguage.id),
            (key: "from", value: sourceLanguage?.id ?? "auto")
        ]
        switch self {
        case let .text(text, _):
            urlComponents = URLComponents(string: "https://www.bing.com/translator/")!
            percentEncodedQueries.append((key: "text", value: text))
        case let .page(url, _):
            urlComponents = URLComponents(string: "https://www.translatetheweb.com/")!
            percentEncodedQueries.append((key: "a", value: url.absoluteString))
        }
        urlComponents.percentEncodedQuery = percentEncodedQueries.makeQueryString()
        return urlComponents.url
    }
    
    private func makeURLForDeepL(targetLanguage: Language) -> URL? {
        switch self {
        case let .text(text, sourceLanguage):
            let encodedText = text.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserved) ?? ""
            let sourceCode = sourceLanguage?.id ?? "auto"
            return URL(string: "https://www.deepl.com/translator#\(sourceCode)/\(targetLanguage.id)/\(encodedText)")
        case .page:
            assertionFailure("DeepL doesn't support page translation")
            return makeURLForGoogle(targetLanguage: targetLanguage)
        }
    }
    
    private func makeURLForGoogle(targetLanguage: Language) -> URL? {
        var parameters: [URLQueryParameter] = [
            (key: "tl", value: targetLanguage.id),
            (key: "sl", value: sourceLanguage?.id ?? "auto")
        ]
        let baseURLString: String
        if Locale.current.isInChina {
            baseURLString = "https://translate.google.cn"
        } else {
            baseURLString = "https://translate.google.com"
        }
        switch self {
        case let .text(text, _):
            parameters.append((key: "text", value: text))
            return URL(string: "\(baseURLString)/?\(parameters.makeQueryString())")
        case let .page(url, _):
            parameters.append((key: "u", value: url.absoluteString.removingPercentEncoding ?? ""))
            return URL(string: "\(baseURLString)/translate?\(parameters.makeQueryString())")
        }
    }
    
    private func makeURLForPapago(targetLanguage: Language) -> URL? {
        var parameters: [URLQueryParameter] = []
        switch self {
        case let .text(text, _):
            parameters.append(contentsOf: [
                (key: "tk", value: targetLanguage.id),
                (key: "sk", value: sourceLanguage?.id ?? "auto"),
                (key: "st", value: text)
            ])
            return URL(string: "https://papago.naver.com/?\(parameters.makeQueryString())")
        case let .page(url, _):
            parameters.append(contentsOf: [
                (key: "target", value: targetLanguage.id),
                (key: "source", value: sourceLanguage?.id ?? "auto"),
                (key: "url", value: url.absoluteString.removingPercentEncoding ?? "")
            ])
            return URL(string: "https://papago.naver.net/website?\(parameters.makeQueryString())")
        }
    }
    
    private func makeURLForYandex(targetLanguage: Language) -> URL? {
        var parameters: [URLQueryParameter] = [
            (key: "lang", value: [sourceLanguage?.id, targetLanguage.id].compactMap { $0 }.joined(separator: "-"))
        ]
        
        switch self {
        case let .text(text, _):
            parameters.append((key: "text", value: text))
            return URL(string: "https://translate.yandex.com/?\(parameters.makeQueryString())")
        case let .page(url, _):
            parameters.append((key: "url", value: url.absoluteString.removingPercentEncoding ?? ""))
            return URL(string: "https://translate.yandex.com/translate?\(parameters.makeQueryString())")
        }
    }
}
