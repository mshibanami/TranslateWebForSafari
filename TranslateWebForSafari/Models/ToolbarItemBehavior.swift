// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import Foundation

enum ToolbarItemBehavior: String, CaseIterable {
    case alwaysTranslatePage = "alwaysTranslatePage"
    case alwaysTranslateSelectedText = "alwaysTranslateSelectedText"
    case translateTextIfSelected = "translateTextIfSelected"
    
    var localizedTitle: String {
        switch self {
        case .alwaysTranslatePage:
            return L10n.alwaysTranslatePage
        case .alwaysTranslateSelectedText:
            return L10n.alwaysTranslateSelectedText
        case .translateTextIfSelected:
            return L10n.textAndRecommended(text: L10n.translateTextIfSelected)
        }
    }
}
