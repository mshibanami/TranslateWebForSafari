//
//  Log.swift
//  TranslateWebForSafari
//
//  Created by Manabu Nakazawa on 7/6/20.
//  Copyright © 2020 Manabu Nakazawa. All rights reserved.
//

import Foundation

enum Log {
    static func info(_ format: String, args: CVarArg...) {
        NSLog("🔵" + format, args)
    }
}
