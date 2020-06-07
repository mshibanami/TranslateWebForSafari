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
    func fillToSuperview(edgeInsets: NSEdgeInsets? = nil) -> NSView {
        guard let superview = superview else {
            assertionFailure()
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
    
    @discardableResult
    func centerInSuperview() -> NSView {
        guard let superview = superview else {
            assertionFailure()
            return self
        }
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
        return self
    }
    
    func addAutoLayoutSubview(_ view: NSView, positioned place: NSWindow.OrderingMode = .above, relativeTo otherView: NSView? = nil) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view, positioned: place, relativeTo: otherView)
    }
}
