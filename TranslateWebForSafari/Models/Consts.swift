//
//  Consts.swift
//  TranslateWebForSafari
//
//  Created by Manabu Nakazawa on 21/5/20.
//  Copyright © 2020 Manabu Nakazawa. All rights reserved.
//

import Foundation

enum Consts {
    static let gitHubUserID = "mshibanami"
    static let gitHubRepositoryID = "TranslateWebForSafari"
    static let supportPageURL = URL(string: "https://github.com/\(gitHubUserID)/\(gitHubRepositoryID)")!
    static let bundleVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    static let bundleShortVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    static let appAppleID = "id1513175329"
    static let usesMojaveCompatibleAPIOnly: Bool = {
        if #available(OSX 10.14.4, *) {
            return false
        } else {
            return true
        }
    }()
    
    static let isDownloadedFromAppStore: Bool = {
        let url = Bundle.main.bundleURL.appendingPathComponent("Contents/_MASReceipt/receipt")
        return FileManager.default.fileExists(atPath: url.path)
    }()
}
