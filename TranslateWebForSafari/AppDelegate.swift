// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var windowController: NSWindowController?
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        AppRatingSettings.setup()
        setupMenuItems()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupWindow()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    private func setupWindow() {
        let window = NSWindow(contentViewController: MainViewController())
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.styleMask = [.titled, .miniaturizable, .closable]
        windowController = NSWindowController(window: window)
        windowController?.showWindow(self)

        let frameAutosaveName = NSWindow.FrameAutosaveName("MainWindow")
        windowController?.windowFrameAutosaveName = frameAutosaveName
        window.setFrameAutosaveName(frameAutosaveName)
    }
    
    private func setupMenuItems() {
        let mainMenu = NSMenu(title: "MainMenu")
        NSApp.mainMenu = mainMenu
        
        let menuList: [(String, (NSMenu) -> ([NSMenuItem]))] = [
            (L10n.appName, { (menu: NSMenu) in
                [
                    NSMenuItem(title: L10n.menuItemHideApp, action: #selector(NSApp.hide(_:)), keyEquivalent: "h"),
                    NSMenuItem(title: L10n.menuItemHideOthers, action: #selector(NSApp.hideOtherApplications(_:)), keyEquivalent: "h", keyEquivalentModifierMask: [.command, .option]),
                    NSMenuItem(title: L10n.menuItemShowAll, action: #selector(NSApp.unhideAllApplications(_:)), keyEquivalent: ""),
                    NSMenuItem.separator(),
                    NSMenuItem(title: L10n.menuItemQuitApp, action: #selector(NSApp.terminate(_:)), keyEquivalent: "q")
                ]
            }),
            (L10n.menuItemWindow, { (menu: NSMenu) in
                [
                    NSMenuItem(title: L10n.menuItemClose, action: #selector(NSWindow.performClose(_:)), keyEquivalent: "w"),
                ]
            })
        ]
        
        for (menuTitle, itemsListFunc) in menuList {
            let menuItem = NSMenuItem(title: menuTitle, action: nil, keyEquivalent: "")
            mainMenu.addItem(menuItem)
            let submenu = NSMenu(title: menuTitle)
            for i in itemsListFunc(submenu) {
                submenu.addItem(i)
            }
            menuItem.submenu = submenu
        }
    }
}

extension NSMenu {
    private func removeFromSuperMenuItem() {
        let servicesMenu = NSApp.servicesMenu
        let supermenu = servicesMenu?.supermenu
        supermenu?.removeItem(at: (supermenu?.indexOfItem(withSubmenu: servicesMenu))!)
    }
}

extension NSMenuItem {
    public convenience init(title string: String, action selector: Selector?, keyEquivalent charCode: String, keyEquivalentModifierMask: NSEvent.ModifierFlags) {
        self.init(title: string, action: selector, keyEquivalent: charCode)
        self.keyEquivalentModifierMask = keyEquivalentModifierMask
    }
}
