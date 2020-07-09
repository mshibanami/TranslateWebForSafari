// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

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
    
    func subviews<T>(of type: T.Type) -> [T] {
        return subviews.compactMap { $0 as? T }
            + subviews
                .compactMap({ $0.subviews(of: T.self) })
                .reduce(into: [], { $0 += $1 })
    }
}
