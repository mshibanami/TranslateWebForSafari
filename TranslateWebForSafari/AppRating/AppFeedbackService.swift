// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import Foundation

enum AppFeedbackService {
    case email(address: String)
    case twitter(userID: String)
    case gitHub(userID: String, repositoryID: String)
    
    var url: URL {
        switch self {
        case let .email(address):
            return URL(
                mailTo: address,
                subject: "Feedback for \(L10n.appName)",
                body: """
                \n
                • \(L10n.appName) \(Consts.bundleShortVersion) (\(Consts.bundleVersion)) \(Consts.isDownloadedFromAppStore ? "App Store" : "GitHub")
                • macOS \(ProcessInfo.processInfo.operatingSystemVersionString)
                • Language: \(Locale.current.languageCode ?? "-")
                • Region: \(Locale.current.regionCode ?? "-")
                """)
        case let .twitter(userID):
            return URL(string: "https://twitter.com/\(userID)")!
        case let .gitHub(userID, repositoryID):
            return URL(string: "https://github.com/\(userID)/\(repositoryID)/issues")!
        }
    }
    
    var serviceTitle: String {
        switch self {
        case .email:
            return "Email"
        case .twitter:
            return "Twitter"
        case .gitHub:
            return "GitHub"
        }
    }
}

private extension URL {
    init(mailTo emailAddress: String, subject: String?, body: String?) {
        let encodedAddress = emailAddress.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserved)!
        var components = URLComponents(string: "mailto:\(encodedAddress)")!
        let percentEncodedQueries: [URLQueryParameter] = [
            subject.flatMap { (key: "subject", value: $0) } ?? nil,
            body.flatMap { (key: "body", value: $0) } ?? nil
            ].compactMap { $0 }
        components.percentEncodedQuery = percentEncodedQueries.makeQueryString()
        self = components.url!
    }
}
