// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import Foundation
import StoreKit

enum AppRatingSettings {
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
    
    static func showAppRatingRequestIfNeeded() {
        guard #available(OSX 10.14, *), AppRatingSettings.showsAppRatingRequest else {
            return
        }
        SKStoreReviewController.requestReview()
        markLastAppRating()
    }
    
    static func markLastAppRating() {
        UserDefaults.group.lastRatedBundleVersion = Consts.bundleVersion
        UserDefaults.group.lastRatedDate = Date()
    }
    
    static func incrementTranslationCount() {
        UserDefaults.group.translationCountForCurrentVersion += 1
        Log.info("Translation Count: \(UserDefaults.group.translationCountForCurrentVersion)")
    }
    
    private static var showsAppRatingRequest: Bool {
        return Consts.isDownloadedFromAppStore
            && UserDefaults.group.lastRatedDate == nil
            && UserDefaults.group.translationCountForCurrentVersion > 20
    }
}
