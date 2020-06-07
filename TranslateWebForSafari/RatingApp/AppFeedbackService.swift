//
//  AppFeedbackService.swift
//  TranslateWebForSafari
//
//  Created by Manabu Nakazawa on 7/6/20.
//  Copyright © 2020 Manabu Nakazawa. All rights reserved.
//

import Foundation

enum AppFeedbackService {
    case email(address: String)
    case twitter(userID: String)
    case gitHub(userID: String, repositoryID: String)
    
    var url: URL {
        switch self {
        case let .email(address):
            return URL(string: "mailto:\(address)")!
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
