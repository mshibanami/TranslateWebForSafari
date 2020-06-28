//
//  Log.swift
//  TranslateWebForSafari
//
//  Created by Manabu Nakazawa on 7/6/20.
//  Copyright © 2020 Manabu Nakazawa. All rights reserved.
//

import Foundation

enum Log {
    static func debug(_ format: String, args: CVarArg...) {
        #if DEBUG
        log(prefix: "⚫️", format: format, args: args)
        #endif
    }
    
    static func info(_ format: String, args: CVarArg...) {
        log(prefix: "🔵", format: format, args: args)
    }
    
    static func warn(_ format: String, args: CVarArg...) {
        log(prefix: "🟠", format: format, args: args)
    }
    
    private static func log(prefix: String, format: String, args: CVarArg...) {
        NSLog(prefix + format, args)
    }
}
