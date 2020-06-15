//
//  UserDefaults+AppSettings.swift
//  TranslateWebForSafari
//
//  Created by Manabu Nakazawa on 23/5/20.
//  Copyright © 2020 Manabu Nakazawa. All rights reserved.
//

import Foundation

extension UserDefaults {
    enum AppKey: String {
        case pageTranslationService = "pageTranslationService"
        case textTranslationService = "textTranslationService"
        case pageTargetLanguage = "pageTargetLanguage"
        case textTargetLanguage = "textTargetLanguage"
        case toolbarItemBehavior = "toolbarItemBehavior"
        case pageTranslationTransitionBehavior = "pageTranslationTransitionBehavior"
        case textTranslationTransitionBehavior = "textTranslationTransitionBehavior"
        case translationCountForCurrentVersion = "translationCountForCurrentVersion"
        case lastRunBundleVersion = "lastRunBundleVersion"
        case lastRatedBundleVersion = "lastRatedBundleVersion"
        case lastRatedDate = "lastRatedDate"
    }
        
    static var group: UserDefaults = UserDefaults(suiteName: "group.io.github.mshibanami.TranslateWebForSafari")!
    
    var pageTranslationService: TranslationService {
        get {
            guard
                let serviceValue = string(forKey: AppKey.pageTranslationService.rawValue),
                let service = TranslationService(rawValue: serviceValue) else {
                    return .google
            }
            return service
        }
        
        set {
            let languageID = pageTargetLanguage.id
            set(newValue.rawValue, forKey: AppKey.pageTranslationService.rawValue)
            pageTargetLanguage = newValue.supportedLanguagesForPageTranslation().first(where: { $0.id == languageID})
                ?? newValue.defaultLanguage()
        }
    }
    
    var pageTargetLanguage: Language {
        get {
            guard
                let id = string(forKey: AppKey.pageTargetLanguage.rawValue),
                let language = pageTranslationService.supportedLanguagesForPageTranslation().first(where: { $0.id == id }) else {
                    return pageTranslationService.defaultLanguage()
            }
            return language
        }
        set {
            set(newValue.id, forKey: AppKey.pageTargetLanguage.rawValue)
        }
    }
    
    var textTranslationService: TranslationService {
        get {
            guard
                let serviceValue = string(forKey: AppKey.textTranslationService.rawValue),
                let service = TranslationService(rawValue: serviceValue) else {
                    return .google
            }
            return service
        }
        set {
            let languageID = textTargetLanguage.id
            set(newValue.rawValue, forKey: AppKey.textTranslationService.rawValue)
            textTargetLanguage = newValue.supportedLanguagesForTextTranslation().first(where: { $0.id == languageID})
                ?? newValue.defaultLanguage()
        }
    }
    
    var textTargetLanguage: Language {
        get {
            guard
                let id = string(forKey: AppKey.textTargetLanguage.rawValue),
                let language = textTranslationService.supportedLanguagesForTextTranslation().first(where: { $0.id == id }) else {
                    return textTranslationService.defaultLanguage()
            }
            return language
        }
        set {
            set(newValue.id, forKey: AppKey.textTargetLanguage.rawValue)
        }
    }
    
    var toolbarItemBehavior: ToolbarItemBehavior {
        get {
            guard
                let id = string(forKey: AppKey.toolbarItemBehavior.rawValue),
                let behavior = ToolbarItemBehavior(rawValue: id) else {
                    return .translateTextIfSelected
            }
            return behavior
        }
        set {
            set(newValue.rawValue, forKey: AppKey.toolbarItemBehavior.rawValue)
        }
    }
    
    var pageTranslationTransitionBehavior: TransitionBehavior {
        get {
            guard
                let id = string(forKey: AppKey.pageTranslationTransitionBehavior.rawValue),
                let behavior = TransitionBehavior(rawValue: id) else {
                    return TransitionBehavior.currentTab
            }
            return behavior
        }
        set {
            set(newValue.rawValue, forKey: AppKey.pageTranslationTransitionBehavior.rawValue)
        }
    }
    
    var textTranslationTransitionBehavior: TransitionBehavior {
        get {
            guard
                let id = string(forKey: AppKey.textTranslationTransitionBehavior.rawValue),
                let behavior = TransitionBehavior(rawValue: id) else {
                    return TransitionBehavior.newTab
            }
            return behavior
        }
        set {
            set(newValue.rawValue, forKey: AppKey.textTranslationTransitionBehavior.rawValue)
        }
    }
    
    // MARK: - App Rating
    
    var translationCountForCurrentVersion: Int {
        get {
            return integer(forKey: AppKey.translationCountForCurrentVersion.rawValue)
        }
        set {
            set(newValue, forKey: AppKey.translationCountForCurrentVersion.rawValue)
        }
    }
    
    var lastRunBundleVersion: String? {
        get {
            return string(forKey: AppKey.lastRunBundleVersion.rawValue)
        }
        set {
            set(newValue, forKey: AppKey.lastRunBundleVersion.rawValue)
        }
    }
    
    var lastRatedBundleVersion: String? {
        get {
            return string(forKey: AppKey.lastRatedBundleVersion.rawValue)
        }
        set {
            set(newValue, forKey: AppKey.lastRatedBundleVersion.rawValue)
        }
    }
    
    var lastRatedDate: Date? {
        get {
            return object(forKey: AppKey.lastRatedDate.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKey.lastRatedDate.rawValue)
        }
    }
    
    // MARK: - Helpers
    
    func translationService(for media: TranslationMedia) -> TranslationService {
        switch media {
        case .text:
            return textTranslationService
        case .page:
            return pageTranslationService
        }
    }
    
    func language(for media: TranslationMedia) -> Language {
        switch media {
        case .text:
            return textTargetLanguage
        case .page:
            return pageTargetLanguage
        }
    }
}
