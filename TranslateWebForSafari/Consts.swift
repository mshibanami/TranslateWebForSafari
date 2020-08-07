// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

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
    static let extensionBundleIdentifier = "io.github.mshibanami.TranslateWebForSafari.Extension"
    static let appReviewURL = URL(string: "https://youtu.be/7lAS9WE32pg")!
    
    static let isDownloadedFromAppStore: Bool = {
        let url = Bundle.main.bundleURL.appendingPathComponent("Contents/_MASReceipt/receipt")
        return FileManager.default.fileExists(atPath: url.path)
    }()
}
