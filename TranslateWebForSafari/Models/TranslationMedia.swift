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
    
    func makeURL(for service: TranslationService, targetLanguage: Language, regionCode: String?) -> URL? {
        switch service {
        case .baidu:
            return makeURLForBaidu(targetLanguage: targetLanguage, regionCode: regionCode)
        case .bing:
            return makeURLForBing(targetLanguage: targetLanguage)
        case .deepL:
            return makeURLForDeepL(targetLanguage: targetLanguage, regionCode: regionCode)
        case .google:
            return makeURLForGoogle(targetLanguage: targetLanguage, regionCode: regionCode)
        case .papago:
            return makeURLForPapago(targetLanguage: targetLanguage)
        case .yandex:
            return makeURLForYandex(targetLanguage: targetLanguage)
        }
    }

    private func makeURLForBaidu(targetLanguage: Language, regionCode: String?) -> URL? {
        switch self {
        case let .text(text, sourceLanguage):
            let sourceID = sourceLanguage?.id ?? "auto"
            let encodedText = text.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserved) ?? ""
            return URL(string: "https://fanyi.baidu.com/#\(sourceID)/\(targetLanguage.id)/\(encodedText)")
        case .page:
            assertionFailure("Baidu doesn't support page translation")
            return makeURLForGoogle(targetLanguage: targetLanguage, regionCode: regionCode)
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
    
    private func makeURLForDeepL(targetLanguage: Language, regionCode: String?) -> URL? {
        switch self {
        case let .text(text, sourceLanguage):
            let encodedText = text.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserved) ?? ""
            let sourceCode = sourceLanguage?.id ?? "auto"
            return URL(string: "https://www.deepl.com/translator#\(sourceCode)/\(targetLanguage.id)/\(encodedText)")
        case .page:
            assertionFailure("DeepL doesn't support page translation")
            return makeURLForGoogle(targetLanguage: targetLanguage, regionCode: regionCode)
        }
    }
    
    private func makeURLForGoogle(targetLanguage: Language, regionCode: String?) -> URL? {
        var parameters: [URLQueryParameter] = [
            (key: "tl", value: targetLanguage.id),
            (key: "sl", value: sourceLanguage?.id ?? "auto")
        ]
        
        let baseURL = makeBaseURLForGoogle(regionCode: regionCode)
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)

        switch self {
        case let .text(text, _):
            parameters.append((key: "text", value: text))
            urlComponents?.percentEncodedQuery = parameters.makeQueryString()
        case let .page(url, _):
            urlComponents?.path = "/translate"
            parameters.append((key: "u", value: url.absoluteString.removingPercentEncoding ?? ""))
            urlComponents?.percentEncodedQuery = parameters.makeQueryString()
        }
        return urlComponents?.url
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
    
    private func makeBaseURLForGoogle(regionCode: String?) -> URL {
        let defaultURL = URL(string: "https://translate.google.com/")!
        guard let regionCode = regionCode else {
            return defaultURL
        }
        switch regionCode {
        case "CN":
            return URL(string: "https://translate.google.cn/")!
        default:
            return defaultURL
        }
    }
}
