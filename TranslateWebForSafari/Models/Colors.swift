//
//  Color.swift
//  TranslateWebForSafari
//
//  Created by Manabu Nakazawa on 2/6/20.
//  Copyright © 2020 Manabu Nakazawa. All rights reserved.
//

import Foundation
import AppKit

enum Colors {
    static let separatorColor: NSColor = {
        if #available(OSX 10.14, *) {
            return NSColor.separatorColor
        } else {
            return NSColor(named: .init("separatorColor"))!
        }
    }()
}
