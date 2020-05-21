//
//  L10n.swift
//  TranslateWebForSafari
//
//  Created by Manabu Nakazawa on 14/5/20.
//  Copyright © 2020 Manabu Nakazawa. All rights reserved.
//

import Foundation

class L10n {
    static let appName = "Translate Web for Safari"
    static let openSafariPreferences = NSLocalizedString("Open Safari Preferences…", comment: "")
    static let aboutThisExtension = NSLocalizedString("About this extension", comment: "")
    static let menuItemHideApp = String(format: NSLocalizedString("Hide %@", comment: ""), appName)
    static let menuItemHideOthers = NSLocalizedString("Hide Others", comment: "")
    static let menuItemShowAll = NSLocalizedString("Show All", comment: "")
    static let menuItemQuitApp = String(format: NSLocalizedString("Quit %@", comment: ""), appName)
    static let menuItemWindow = NSLocalizedString("Window", comment: "")
    static let menuItemClose = NSLocalizedString("Close", comment: "")
    static let toolbarItemTranslatePage = NSLocalizedString("Translate the current page", comment: "")
    static let contextMenuTranslatePage = NSLocalizedString("Translate this page (Translate Web)", comment: "")
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
