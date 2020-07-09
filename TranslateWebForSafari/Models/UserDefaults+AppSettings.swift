// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import Foundation
import ShortcutRecorder

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
        case pageTranslationShortcut = "pageTranslationShortcut"
        case textTranslationShortcut = "textTranslationShortcut"
        case textOrPageTranslationShortcut = "textOrPageTranslationShortcut"
    }
    
    static var group: UserDefaults = UserDefaults(suiteName: "group.io.github.mshibanami.TranslateWebForSafari")!
    
    var pageTranslationService: TranslationService {
        get {
            guard
                let serviceValue = string(forKey: AppKey.pageTranslationService.rawValue),
                let service = TranslationService(rawValue: serviceValue) else {
                    return Locale.current.regionCode == "CN"
                        ? .yandex
                        : .google
            }
            return service
        }
        
        set {
            set(newValue.rawValue, forKey: AppKey.pageTranslationService.rawValue)
            let languageID = pageTargetLanguage.id
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
            set(newValue.rawValue, forKey: AppKey.textTranslationService.rawValue)
            let languageID = textTargetLanguage.id
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
    
    var pageTranslationShortcut: Shortcut? {
        get {
            return (object(forKey: AppKey.pageTranslationShortcut.rawValue) as? Data).flatMap {
                NSKeyedUnarchiver.unarchiveObject(with: $0) as? Shortcut
            }
        }
        set {
            set(newValue, forKey: AppKey.pageTranslationShortcut.rawValue)
        }
    }
    
    var textTranslationShortcut: Shortcut? {
        get {
            return (object(forKey: AppKey.textTranslationShortcut.rawValue) as? Data).flatMap {
                NSKeyedUnarchiver.unarchiveObject(with: $0) as? Shortcut
            }
        }
        set {
            set(newValue, forKey: AppKey.textTranslationShortcut.rawValue)
        }
    }
    
    var textOrPageTranslationShortcut: Shortcut? {
        get {
            return (object(forKey: AppKey.textOrPageTranslationShortcut.rawValue) as? Data).flatMap {
                NSKeyedUnarchiver.unarchiveObject(with: $0) as? Shortcut
            }
        }
        set {
            set(newValue, forKey: AppKey.textOrPageTranslationShortcut.rawValue)
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
