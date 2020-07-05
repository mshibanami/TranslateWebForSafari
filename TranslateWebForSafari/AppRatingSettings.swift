//
//  AppRatingSettings.swift
//  TranslateWebForSafari
//
//  Created by Manabu Nakazawa on 7/6/20.
//  Copyright © 2020 Manabu Nakazawa. All rights reserved.
//

import Foundation

enum AppRatingSettings {
    static let ratingService: AppRatingService = {
        return Consts.isDownloadedFromAppStore
            ? .appStore(appAppleID: Consts.appAppleID)
            : .gitHub(userID: Consts.gitHubUserID, repositoryID: Consts.gitHubRepositoryID)
    }()
    
    static func setup() {
        if UserDefaults.group.lastRunBundleVersion != Consts.bundleVersion {
            UserDefaults.group.lastRunBundleVersion = Consts.bundleVersion
            UserDefaults.group.translationCountForCurrentVersion = 0
        }
        Log.info("[Settings] lastRatedDate: \(String(describing: UserDefaults.group.lastRatedDate))")
        Log.info("[Settings] lastRatedBundleVersion: \(String(describing: UserDefaults.group.lastRatedBundleVersion))")
        Log.info("[Settings] lastRunBundleVersion: \(String(describing: UserDefaults.group.lastRunBundleVersion))")
        Log.info("[Settings] translationCountForCurrentVersion: \(UserDefaults.group.translationCountForCurrentVersion)")
    }
    
    static let feedbackServices: [AppFeedbackService] = {
        return [
            .email(address: "mshibanami+translateweb" + "@" + "gma" + "il.c" + "om"),
            .gitHub(userID: Consts.gitHubUserID, repositoryID: Consts.gitHubRepositoryID),
            .twitter(userID: "mshibanami")
        ]
    }()
    
    static var showsAppRatingRequest: Bool {
        let elapesedSinceLastRating = Date().timeIntervalSince1970
            - (UserDefaults.group.lastRatedDate ?? Date.distantPast).timeIntervalSince1970
        
        return UserDefaults.group.lastRatedBundleVersion != Consts.bundleVersion
            && UserDefaults.group.translationCountForCurrentVersion > 1
            && elapesedSinceLastRating > TimeInterval(60 * 60 * 24 * 30)
    }
    
    static func markLastAppRating() {
        UserDefaults.group.lastRatedBundleVersion = Consts.bundleVersion
        UserDefaults.group.lastRatedDate = Date()
    }
    
    static func incrementTranslationCount() {
        UserDefaults.group.translationCountForCurrentVersion += 1
        Log.info("Translation Count: \(UserDefaults.group.translationCountForCurrentVersion)")
    }
}
