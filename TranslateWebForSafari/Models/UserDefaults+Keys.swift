//
//  UserDefaults+Keys.swift
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
        case pageTranslateTo = "pageTranslateTo"
        case textTranslateTo = "textTranslateTo"
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
            let languageID = pageTranslateTo.id
            set(newValue.rawValue, forKey: AppKey.pageTranslationService.rawValue)
            pageTranslateTo = newValue.supportedLanguages().first(where: { $0.id == languageID})
                ?? newValue.defaultLanguage()
        }
    }
    
    var pageTranslateTo: Language {
        get {
            guard
                let id = string(forKey: AppKey.pageTranslateTo.rawValue),
                let language = pageTranslationService.supportedLanguages().first(where: { $0.id == id }) else {
                    return pageTranslationService.defaultLanguage()
            }
            return language
        }
        set {
            set(newValue.id, forKey: AppKey.pageTranslateTo.rawValue)
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
            let languageID = textTranslateTo.id
            set(newValue.rawValue, forKey: AppKey.textTranslationService.rawValue)
            textTranslateTo = newValue.supportedLanguages().first(where: { $0.id == languageID})
                ?? newValue.defaultLanguage()
        }
    }
    
    var textTranslateTo: Language {
        get {
            guard
                let id = string(forKey: AppKey.textTranslateTo.rawValue),
                let language = textTranslationService.supportedLanguages().first(where: { $0.id == id }) else {
                    return textTranslationService.defaultLanguage()
            }
            return language
        }
        set {
            set(newValue.id, forKey: AppKey.textTranslateTo.rawValue)
        }
    }
    
    
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
            return textTranslateTo
        case .page:
            return pageTranslateTo
        }
    }
}
