// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import AppKit

class FeedbackMenuPresenter {
    var onFinishSelectingMenuItem: () -> Void
    
    private let services = AppRatingSettings.feedbackServices
    
    init(onFinishSelectingMenuItem: @escaping () -> Void) {
        self.onFinishSelectingMenuItem = onFinishSelectingMenuItem
    }
    
    func showMenu(with event: NSEvent?, for view: NSView) {
        let menu = NSMenu()
        services.enumerated()
            .map({ index, service in
                let menuItem = NSMenuItem(
                    title: service.serviceTitle,
                    action: #selector(self.didSelectFeedbackMenuItem(_:)),
                    keyEquivalent: "")
                menuItem.target = self
                menuItem.tag = index
                return menuItem
            })
            .forEach { menu.addItem($0) } // Don't use setter of menu.items because of High Sierra's limitation
        
        guard let event = event ?? NSApplication.shared.currentEvent else {
            return
        }
        NSMenu.popUpContextMenu(menu, with: event, for: view)
    }
    
    @objc private func didSelectFeedbackMenuItem(_ sender: NSMenuItem) {
        guard let service = services[optional: sender.tag] else {
            assertionFailure()
            return
        }
        NSWorkspace.shared.open(service.url)
        self.onFinishSelectingMenuItem()
    }
}
