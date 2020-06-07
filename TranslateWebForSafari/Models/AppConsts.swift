//
//  AppConsts.swift
//  TranslateWebForSafari
//
//  Created by Manabu Nakazawa on 7/6/20.
//  Copyright © 2020 Manabu Nakazawa. All rights reserved.
//

import Foundation

enum AppConsts {
    static let ratingService: AppRatingService = {
        return Consts.isDownloadedFromAppStore
            ? .appStore(appAppleID: Consts.appAppleID)
            : .gitHub(userID: Consts.gitHubUserID, repositoryID: Consts.gitHubRepositoryID)
    }()
    
    static let feedbackServices: [AppFeedbackService] = {
        return [
            .email(address: "mshibanami+translateweb" + "@" + "gma" + "il.c" + "om"),
            .gitHub(userID: Consts.gitHubUserID, repositoryID: Consts.gitHubRepositoryID),
            .twitter(userID: "mshibanami")
        ]
    }()
}
