//
//  L10n.swift
//  TranslateWebForSafari
//
//  Created by Manabu Nakazawa on 14/5/20.
//  Copyright © 2020 Manabu Nakazawa. All rights reserved.
//

import Foundation

class L10n {
    static let contextMenuTranslatePage = NSLocalizedString("Translate this page (Translate Web)", comment: "")
    static let toolbarItemTranslatePage = NSLocalizedString("Translate the current page", comment: "")
    
    static func contextMenuTranslateText(with text: String) -> String {
        return String.localizedStringWithFormat(
            NSLocalizedString("Translate \"%@\" (Translate Web)", comment: ""),
            text)
    }
    
    static func toolbarItemTranslateText(with text: String) -> String {
        return String.localizedStringWithFormat(
            NSLocalizedString("Translate \"%@\"", comment: ""),
            text)
    }
}
