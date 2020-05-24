// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import Cocoa
import SafariServices.SFSafariApplication

class MainViewController: NSViewController {
    private static var pageTranslationServices: [TranslationService] {
        TranslationService.allCases.filter { $0.supportsPageTranslation }
    }
    
    private static var textTranslationServices: [TranslationService] {
        TranslationService.allCases
    }
    
    private lazy var containerStackView: NSStackView = {
        let view = NSStackView(views: [
            appIconImageView,
            appTitleLabel,
            upperSeparatorView,
            settingsGridView,
            lowerSeparatorView,
            openSafariPreferencesButton
        ])
        view.orientation = .vertical
        view.alignment = .centerX
        view.distribution = .equalCentering
        view.setCustomSpacing(10, after: appIconImageView)
        view.setCustomSpacing(30, after: appTitleLabel)
        view.setCustomSpacing(30, after: upperSeparatorView)
        view.setCustomSpacing(30, after: settingsGridView)
        view.setCustomSpacing(30, after: lowerSeparatorView)
        return view
    }()
    
    private let appIconImageView: NSImageView = {
        let image = NSImage(named: "AppIcon")!
        let view = NSImageView(image: image)
        view.imageScaling = .scaleProportionallyUpOrDown
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 100),
            view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: image.size.height / image.size.width)
        ])
        return view
    }()
    
    private let appTitleLabel: NSTextField = {
        let label = NSTextField(settingLabelWithString: L10n.appName)
        label.font = NSFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var openSafariPreferencesButton: NSButton = {
        let button = NSButton(
            title: L10n.openSafariPreferences,
            target: self,
            action: #selector(didTapOpenSafariPreferences(_:)))
        button.isHighlighted = true
        return button
    }()
    
    private let upperSeparatorView: NSView = {
        let view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.separatorColor.cgColor
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    private let lowerSeparatorView: NSView = {
        let view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.separatorColor.cgColor
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    private lazy var pageTranslationStackView: NSStackView = {
        let view = NSStackView(views: [
            pageTranslationServicePopUpButton,
            {
                let view = NSStackView(views: [
                    NSTextField(settingLabelWithString: L10n.translateTo),
                    pageTranslateToPopUpButton
                ])
                return view
            }()
        ])
        view.spacing = 6
        view.orientation = .vertical
        view.alignment = .leading
        return view
    }()
    
    private lazy var textTranslationStackView: NSStackView = {
        let view = NSStackView(views: [
            textTranslationServicePopUpButton,
            {
                let view = NSStackView(views: [
                    NSTextField(settingLabelWithString: L10n.translateTo),
                    textTranslateToPopUpButton
                ])
                return view
            }()
        ])
        view.spacing = 6
        view.orientation = .vertical
        view.alignment = .leading
        return view
    }()
    
    private lazy var settingsGridView: NSGridView = {
        let view = NSGridView(views: [
            [NSTextField(settingLabelWithString: "Page Translation"), pageTranslationStackView],
            [NSTextField(settingLabelWithString: "Text Translation"), textTranslationStackView],
        ])
        view.rowSpacing = 20
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.column(at: 0).xPlacement = .trailing
        view.rowAlignment = .firstBaseline
        return view
    }()
    
    private lazy var aboutThisExtensionButton: NSButton = {
        let button = NSButton(title: L10n.aboutThisExtension, target: self, action: #selector(didTapAboutThisApp(_:)))
        button.font = NSFont.boldSystemFont(ofSize: 12)
        button.setButtonType(.momentaryPushIn)
        button.isBordered = true
        button.showsBorderOnlyWhileMouseInside = true
        button.bezelStyle = .recessed
        return button
    }()
    
    private lazy var pageTranslationServicePopUpButton: NSPopUpButton = {
        let button = NSPopUpButton(title: "", target: self, action: #selector(didTapPageTranslationService(_:)))
        let menu = NSMenu()
        for service in Self.pageTranslationServices {
            menu.addItem(NSMenuItem(title: service.localizedName, action: nil, keyEquivalent: ""))
        }
        button.menu = menu
        return button
    }()
    
    private lazy var pageTranslateToPopUpButton: NSPopUpButton = {
        let button = NSPopUpButton(title: "", target: self, action: #selector(didTapPageTranslateTo(_:)))
        let menu = NSMenu()
        return button
    }()
    
    private lazy var textTranslationServicePopUpButton: NSPopUpButton = {
        let button = NSPopUpButton(title: "", target: self, action: #selector(didTapTextTranslationService(_:)))
        let menu = NSMenu()
        for service in Self.textTranslationServices {
            menu.addItem(NSMenuItem(title: service.localizedName, action: nil, keyEquivalent: ""))
        }
        button.menu = menu
        return button
    }()
    
    private lazy var textTranslateToPopUpButton: NSPopUpButton = {
        let button = NSPopUpButton(title: "", target: self, action: #selector(didTapTextTranslateTo(_:)))
        let menu = NSMenu()
        return button
    }()
    
    override func loadView() {
        let view = NSView()
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerStackView)
        aboutThisExtensionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(aboutThisExtensionButton)
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            containerStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            containerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            upperSeparatorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            lowerSeparatorView.widthAnchor.constraint(equalTo: upperSeparatorView.widthAnchor),
            view.widthAnchor.constraint(greaterThanOrEqualToConstant: 500),
            view.trailingAnchor.constraint(equalTo: aboutThisExtensionButton.trailingAnchor, constant: 10),
            view.bottomAnchor.constraint(equalTo: aboutThisExtensionButton.bottomAnchor, constant: 10),
        ])
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        resetUI()
    }
    
    private func setupBindings() {
        openSafariPreferencesButton.target = self
        openSafariPreferencesButton.action = #selector(didTapOpenSafariPreferences(_:))
        aboutThisExtensionButton.target = self
        aboutThisExtensionButton.action = #selector(didTapAboutThisApp(_:))
    }
    
    private func resetUI() {
        let settings = UserDefaults.group
        
        pageTranslateToPopUpButton.removeAllItems()
        for language in settings.pageTranslationService.supportedLanguages() {
            pageTranslateToPopUpButton.addItem(withTitle: language.titleForMenu)
        }
        
        textTranslateToPopUpButton.removeAllItems()
        for language in settings.textTranslationService.supportedLanguages() {
            textTranslateToPopUpButton.addItem(withTitle: language.titleForMenu)
        }
        
        updateButtonsSelections()
    }
    
    private func updateButtonsSelections() {
        let settings = UserDefaults.group
        
        // Page Translation
        let pageService = settings.pageTranslationService
        if let index = Self.pageTranslationServices.firstIndex(of: pageService) {
            pageTranslationServicePopUpButton.selectItem(at: index)
        }
        if let index = pageService.supportedLanguages().firstIndex(of: settings.pageTargetLanguage) {
            pageTranslateToPopUpButton.selectItem(at: index)
        }
        
        // Text Translation
        let textService = settings.textTranslationService
        if let index = Self.textTranslationServices.firstIndex(of: textService) {
            textTranslationServicePopUpButton.selectItem(at: index)
        }
        if let index = textService.supportedLanguages().firstIndex(of: settings.textTargetLanguage) {
            textTranslateToPopUpButton.selectItem(at: index)
        }
    }
    
    private func currentSelectionOfPageTranslationService() -> TranslationService? {
        let selectedIndex = pageTranslationServicePopUpButton.indexOfSelectedItem
        guard selectedIndex >= 0, let service = Self.pageTranslationServices[optional: selectedIndex] else {
            return nil
        }
        return service
    }
    
    private func currentSelectionOfTextTranslationService() -> TranslationService? {
        let selectedIndex = textTranslationServicePopUpButton.indexOfSelectedItem
        guard selectedIndex >= 0, let service = Self.textTranslationServices[optional: selectedIndex] else {
            return nil
        }
        return service
    }
    
    // MARK: Actions
    
    @IBAction private func didTapOpenSafariPreferences(_ sender: AnyObject?) {
        SFSafariApplication.showPreferencesForExtension(withIdentifier: "io.github.mshibanami.TranslateWebForSafari.Extension")
    }
    
    @IBAction private func didTapAboutThisApp(_ sender: AnyObject?) {
        NSWorkspace.shared.open(Consts.supportPageURL)
    }
    
    @IBAction private func didTapPageTranslationService(_ sender: AnyObject?) {
        guard let service = currentSelectionOfPageTranslationService() else {
            assertionFailure()
            return
        }
        UserDefaults.group.pageTranslationService = service
        resetUI()
    }

    @IBAction private func didTapPageTranslateTo(_ sender: AnyObject?) {
        guard let service = currentSelectionOfPageTranslationService() else {
            assertionFailure()
            return
        }
        UserDefaults.group.pageTargetLanguage = service.supportedLanguages()[pageTranslateToPopUpButton.indexOfSelectedItem]
    }
    
    @IBAction private func didTapTextTranslationService(_ sender: AnyObject?) {
        guard let service = currentSelectionOfTextTranslationService() else {
            assertionFailure()
            return
        }
        UserDefaults.group.textTranslationService = service
        resetUI()
    }
    
    @IBAction private func didTapTextTranslateTo(_ sender: AnyObject?) {
        guard let service = currentSelectionOfTextTranslationService() else {
            assertionFailure()
            return
        }
        UserDefaults.group.textTargetLanguage = service.supportedLanguages()[textTranslateToPopUpButton.indexOfSelectedItem]
    }
}

private extension Language {
    var titleForMenu: String {
        return "\(id) - \(localizedName)"
    }
}

private extension NSTextField {
    convenience init(settingLabelWithString string: String) {
        self.init(labelWithString: string + ":")
    }
}
