// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import Foundation
import AppKit

enum Colors {
    static var separatorColor: NSColor {
        if #available(OSX 10.14, *) {
            return NSColor.separatorColor
        } else {
            return NSColor(named: "separatorColor")!
        }
    }
    
    static var subtitleColor: NSColor {
        return NSColor(named: "subtitleColor")!
    }
    
    static var rateAppBackgroundColor: NSColor {
        return NSColor(named: "rateAppBackgroundColor")!
    }
}
