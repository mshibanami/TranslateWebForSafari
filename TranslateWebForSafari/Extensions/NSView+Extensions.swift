//
//  NSView+Extensions.swift
//  TranslateWebForSafari
//
//  Created by Manabu Nakazawa on 4/6/20.
//  Copyright © 2020 Manabu Nakazawa. All rights reserved.
//

import AppKit

extension NSView {
    @discardableResult
    public func fillToSuperview(edgeInsets: NSEdgeInsets? = nil) -> NSView {
        guard let superview = superview else {
            assertionFailure("No superview found!")
            return self
        }
        translatesAutoresizingMaskIntoConstraints = false
        let insets = edgeInsets ?? NSEdgeInsets()
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right)
        ])
        return self
    }
}
