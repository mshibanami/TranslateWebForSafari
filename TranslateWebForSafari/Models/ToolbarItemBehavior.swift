//
//  ToolbarItemBehavior.swift
//  TranslateWebForSafari
//
//  Created by Manabu Nakazawa on 26/5/20.
//  Copyright © 2020 Manabu Nakazawa. All rights reserved.
//

import Foundation

enum ToolbarItemBehavior: String, CaseIterable {
    case alwaysTranslatePage = "alwaysTranslatePage"
    case alwaysTranslateSelectedText = "alwaysTranslateSelectedText"
    case translateTextIfSelected = "translateTextIfSelected"
    
    static var defaultValue = Self.translateTextIfSelected
    
    var localizedTitle: String {
        switch self {
        case .alwaysTranslatePage:
            return L10n.alwaysTranslatePage
        case .alwaysTranslateSelectedText:
            return L10n.alwaysTranslateSelectedText
        case .translateTextIfSelected:
            return L10n.translateTextIfSelected
        }
    }
}
