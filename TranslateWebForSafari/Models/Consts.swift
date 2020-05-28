//
//  Consts.swift
//  TranslateWebForSafari
//
//  Created by Manabu Nakazawa on 21/5/20.
//  Copyright © 2020 Manabu Nakazawa. All rights reserved.
//

import Foundation

enum Consts {
    static let supportPageURL = URL(string: "https://github.com/mshibanami/TranslateWebForSafari")!
    static let usesMojaveCompatibleAPIOnly: Bool = {
        if #available(OSX 10.14.4, *) {
            return false
        } else {
            return true
        }
    }()
}
