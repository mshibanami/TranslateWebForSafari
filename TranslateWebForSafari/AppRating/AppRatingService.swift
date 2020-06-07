//
//  AppRatingService.swift
//  TranslateWebForSafari
//
//  Created by Manabu Nakazawa on 6/6/20.
//  Copyright © 2020 Manabu Nakazawa. All rights reserved.
//

import Foundation
enum AppRatingService {
    case appStore(appAppleID: String)
    case gitHub(userID: String, repositoryID: String)
    
    var url: URL {
        switch self {
        case let .appStore(appAppleID):
            return URL(string: "macappstore://apps.apple.com/app/\(appAppleID)?mt=12")!
        case let .gitHub(userID, repositoryID):
            return URL(string: "https://github.com/\(userID)/\(repositoryID)")!
        }
    }
    
    var localizedName: String {
        switch self {
        case .appStore:
            return L10n.appStore
        case .gitHub:
            return L10n.gitHub
        }
    }
}
