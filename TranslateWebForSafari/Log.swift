// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

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
