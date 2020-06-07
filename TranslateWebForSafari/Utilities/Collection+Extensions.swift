//
//  Collection+Extensions.swift
//  TranslateWebForSafari
//
//  Created by Manabu Nakazawa on 23/5/20.
//  Copyright © 2020 Manabu Nakazawa. All rights reserved.
//

import Foundation

extension Collection {
    subscript (optional index: Index?) -> Self.Element? {
        guard let index = index else {
            return nil
        }
        return indices.contains(index) ? self[index] : nil
    }
}
