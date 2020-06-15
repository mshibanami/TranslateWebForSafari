// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import Cocoa
import SafariServices.SFSafariApplication

class MainViewController: NSViewController {
    private static let pageTranslationServices = TranslationService.allCases.filter { $0.supportsPageTranslation }
    private static let textTranslationServices = TranslationService.allCases
    private static let toolbarItemBehavior = ToolbarItemBehavior.allCases
        
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
        let label = NSTextField(labelWithString: L10n.appShortName)
        label.font = NSFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let forSafariLabel: NSTextField = {
        let label = NSTextField(labelWithString: L10n.forSafari)
        label.font = NSFont.systemFont(ofSize: 18)
        label.textColor = Colors.subtitleColor
        return label
    }()
    
    private let versionLabel: NSTextField = {
        let label = NSTextField(labelWithString: L10n.appVersion(
            version: Consts.bundleShortVersion,
            buildVersion: Consts.bundleVersion))
        label.font = NSFont.systemFont(ofSize: 13)
        label.isSelectable = true
        label.textColor = Colors.subtitleColor
        return label
    }()
    
    private lazy var openSafariPreferencesButton: NSButton = {
        let button = NSButton(
            title: L10n.openSafariPreferences,
            target: self,
            action: #selector(didSelectOpenSafariPreferences(_:)))
        button.isHighlighted = true
        return button
    }()
    
    private lazy var aboutThisExtensionButton: NSButton = {
        let button = NSButton(title: L10n.aboutThisExtension, target: self, action: #selector(didSelectAboutThisApp(_:)))
        button.font = NSFont.boldSystemFont(ofSize: 12)
        button.setButtonType(.momentaryPushIn)
        button.isBordered = true
        button.showsBorderOnlyWhileMouseInside = true
        button.bezelStyle = .recessed
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()
    
    private lazy var pageTranslationStackView: NSStackView = {
        let view = NSStackView(views: [
            pageTranslationServicePopUpButton,
            NSStackView(views: [
                NSTextField(settingLabelWithString: L10n.translateTo),
                pageTranslateToPopUpButton]),
            pageTranslationOpenInNewTabButton
        ])
        view.spacing = 6
        view.orientation = .vertical
        view.alignment = .leading
        return view
    }()
    
    private lazy var textTranslationStackView: NSStackView = {
        let view = NSStackView(views: [
            textTranslationServicePopUpButton,
            NSStackView(views: [
                NSTextField(settingLabelWithString: L10n.translateTo),
                textTranslateToPopUpButton]),
            textTranslationOpenInNewTabButton
        ])
        view.spacing = 6
        view.orientation = .vertical
        view.alignment = .leading
        return view
    }()
    
    private lazy var toolbarItemBehaviorStackView: NSStackView = {
        let view = NSStackView(views: Self.toolbarItemBehavior.map {
            let button = NSButton(radioButtonWithTitle: $0.localizedTitle, target: self, action: #selector(didSelectToolbarItemBehavior(_:)))
            return  button
        })
        view.spacing = 6
        view.orientation = .vertical
        view.alignment = .leading
        return view
    }()
    
    private lazy var settingsGridView: NSGridView = {
        let view = NSGridView(views: [
            [NSTextField(settingLabelWithString: L10n.pageTranslation), pageTranslationStackView],
            [NSTextField(settingLabelWithString: L10n.textTranslation), textTranslationStackView],
            [NSTextField(settingLabelWithString: L10n.toolbarItemBehavior), toolbarItemBehaviorStackView]
        ])
        view.rowSpacing = 24
        view.column(at: 0).xPlacement = .trailing
        view.rowAlignment = .firstBaseline
        return view
    }()
    
    private lazy var pageTranslationServicePopUpButton: NSPopUpButton = {
        let button = NSPopUpButton(title: "", target: self, action: #selector(didSelectPageTranslationService(_:)))
        let menu = NSMenu()
        menu.items = Self.pageTranslationServices.map {
            NSMenuItem(title: $0.localizedName, action: nil, keyEquivalent: "")
        }
        button.menu = menu
        return button
    }()
    
    private lazy var pageTranslateToPopUpButton = NSPopUpButton(title: "", target: self, action: #selector(didSelectPageTranslateTo(_:)))
    
    private lazy var pageTranslationOpenInNewTabButton = NSButton(checkboxWithTitle: L10n.openInNewTab, target: self, action: #selector(didSelectPageTranslationOpenInNewTabButton(_:)))
    
    private lazy var textTranslationServicePopUpButton: NSPopUpButton = {
        let button = NSPopUpButton(title: "", target: self, action: #selector(didSelectTextTranslationService(_:)))
        let menu = NSMenu()
        menu.items = Self.textTranslationServices.map {
            NSMenuItem(title: $0.localizedName, action: nil, keyEquivalent: "")
        }
        button.menu = menu
        return button
    }()
    
    private lazy var textTranslateToPopUpButton = NSPopUpButton(title: "", target: self, action: #selector(didSelectTextTranslateTo(_:)))
    
    private lazy var textTranslationOpenInNewTabButton = NSButton(checkboxWithTitle: L10n.openInNewTab, target: self, action: #selector(didSelectTextTranslationOpenInNewTabButton(_:)))
    
    private lazy var appRatingViewController = AppRatingViewController(
        ratingService: AppRatingSettings.ratingService,
        feedbackServices: AppRatingSettings.feedbackServices)
    
    private lazy var rateAppContainerView: NSView = {
        let view = NSView()
        var appRateTopSeparator = Self.makeSeparatorView()
        view.addAutoLayoutSubview(appRateTopSeparator)
        NSLayoutConstraint.activate([
            appRateTopSeparator.topAnchor.constraint(equalTo: view.topAnchor),
            appRateTopSeparator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            appRateTopSeparator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        return view
    }()
    
    override func loadView() {
        let titleStackView = NSStackView(views: [
            appTitleLabel,
            forSafariLabel,
        ])
        titleStackView.spacing = 6
        titleStackView.orientation = .horizontal
        titleStackView.alignment = .firstBaseline
        titleStackView.distribution = .fill
        
        let headerTrailingStackView = NSStackView(views: [
            titleStackView,
            versionLabel
        ])
        headerTrailingStackView.spacing = 8
        headerTrailingStackView.orientation = .vertical
        headerTrailingStackView.alignment = .leading
        headerTrailingStackView.distribution = .fill
        
        let headerStackView = NSStackView(views: [
            appIconImageView,
            headerTrailingStackView
        ])
        headerStackView.spacing = 20
        headerStackView.orientation = .vertical
        headerStackView.alignment = .centerY
        headerStackView.distribution = .fill
        
        let settingsUpperSeparator = Self.makeSeparatorView()
        let settingsLowerSeparator = Self.makeSeparatorView()
        
        let contentStackView = NSStackView(views: [
            headerStackView,
            settingsUpperSeparator,
            settingsGridView,
            settingsLowerSeparator,
            openSafariPreferencesButton,
            aboutThisExtensionButton
        ])
        contentStackView.orientation = .vertical
        contentStackView.distribution = .fill
        contentStackView.setCustomSpacing(20, after: headerStackView)
        contentStackView.setCustomSpacing(30, after: settingsUpperSeparator)
        contentStackView.setCustomSpacing(30, after: settingsGridView)
        contentStackView.setCustomSpacing(30, after: settingsLowerSeparator)
        contentStackView.setCustomSpacing(10, after: aboutThisExtensionButton)
        
        let contentEdgeView = NSView()
        contentEdgeView.addAutoLayoutSubview(contentStackView)
        contentStackView.fillToSuperview(edgeInsets: .init(top: 10, left: 30, bottom: 10, right: 30))
        
        let stackView = NSStackView(views: [
            contentEdgeView,
            rateAppContainerView
        ])
        stackView.orientation = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .fill
        let view = NSView()
        view.addAutoLayoutSubview(stackView)
        stackView.fillToSuperview()
        NSLayoutConstraint.activate([
            aboutThisExtensionButton.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            rateAppContainerView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppRatingSettings.showsAppRatingRequest {
            addChild(appRatingViewController)
            rateAppContainerView.addAutoLayoutSubview(appRatingViewController.view, positioned: .below)
            appRatingViewController.view.fillToSuperview()
        }
        
        setupGestureHandlers()
        resetUI()
    }
    
    private func setupGestureHandlers() {
        openSafariPreferencesButton.target = self
        openSafariPreferencesButton.action = #selector(didSelectOpenSafariPreferences(_:))
        aboutThisExtensionButton.target = self
        aboutThisExtensionButton.action = #selector(didSelectAboutThisApp(_:))
        appRatingViewController.onSelectDismiss = { [weak self] in
            guard let self = self else {
                return
            }
            self.appRatingViewController.view.isHidden = true
            self.appRatingViewController.heightConstraint?.constant = 0
            self.view.window?.setContentSize(self.view.fittingSize)
            AppRatingSettings.markLastAppRating()
        }
    }
    
    private func resetUI() {
        let settings = UserDefaults.group
        
        pageTranslateToPopUpButton.removeAllItems()
        for language in settings.pageTranslationService.supportedLanguagesForPageTranslation() {
            pageTranslateToPopUpButton.addItem(withTitle: language.titleForMenu)
        }
        
        textTranslateToPopUpButton.removeAllItems()
        for language in settings.textTranslationService.supportedLanguagesForTextTranslation() {
            textTranslateToPopUpButton.addItem(withTitle: language.titleForMenu)
        }
        
        updateUI()
    }
    
    private func updateUI() {
        let settings = UserDefaults.group
        
        // Page Translation
        let pageService = settings.pageTranslationService
        if let index = Self.pageTranslationServices.firstIndex(of: pageService) {
            pageTranslationServicePopUpButton.selectItem(at: index)
        }
        if let index = pageService.supportedLanguagesForPageTranslation().firstIndex(of: settings.pageTargetLanguage) {
            pageTranslateToPopUpButton.selectItem(at: index)
        }
        
        // Text Translation
        let textService = settings.textTranslationService
        if let index = Self.textTranslationServices.firstIndex(of: textService) {
            textTranslationServicePopUpButton.selectItem(at: index)
        }
        if let index = textService.supportedLanguagesForTextTranslation().firstIndex(of: settings.textTargetLanguage) {
            textTranslateToPopUpButton.selectItem(at: index)
        }
        
        // Toolbar button behavior
        if let index = Self.toolbarItemBehavior.firstIndex(of: settings.toolbarItemBehavior) {
            if let button = toolbarItemBehaviorStackView.arrangedSubviews[optional: index] as? NSButton {
                button.state = .on
            } else {
                assertionFailure()
            }
        }
        
        // Open in a new tab
        switch settings.pageTranslationTransitionBehavior {
        case .newTab:
            pageTranslationOpenInNewTabButton.state = .on
        case .currentTab:
            pageTranslationOpenInNewTabButton.state = .off
        }
        switch settings.textTranslationTransitionBehavior {
        case .newTab:
            textTranslationOpenInNewTabButton.state = .on
        case .currentTab:
            textTranslationOpenInNewTabButton.state = .off
        }
    }
    
    private func currentSelectionOfPageTranslationService() -> TranslationService? {
        let selectedIndex = pageTranslationServicePopUpButton.indexOfSelectedItem
        guard let service = Self.pageTranslationServices[optional: selectedIndex] else {
            return nil
        }
        return service
    }
    
    private func currentSelectionOfTextTranslationService() -> TranslationService? {
        let selectedIndex = textTranslationServicePopUpButton.indexOfSelectedItem
        guard let service = Self.textTranslationServices[optional: selectedIndex] else {
            return nil
        }
        return service
    }
    
    private static func makeSeparatorView() -> NSView {
        let view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = Colors.separatorColor.cgColor
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
    
    // MARK: Actions
    
    @objc private func didSelectPageTranslationService(_ sender: NSView) {
        guard let service = currentSelectionOfPageTranslationService() else {
            assertionFailure()
            return
        }
        UserDefaults.group.pageTranslationService = service
        resetUI()
    }

    @objc private func didSelectTextTranslationService(_ sender: NSView) {
        guard let service = currentSelectionOfTextTranslationService() else {
            assertionFailure()
            return
        }
        UserDefaults.group.textTranslationService = service
        resetUI()
    }
    
    @objc private func didSelectPageTranslateTo(_ sender: NSView) {
        guard let service = currentSelectionOfPageTranslationService() else {
            assertionFailure()
            return
        }
        UserDefaults.group.pageTargetLanguage = service.supportedLanguagesForPageTranslation()[pageTranslateToPopUpButton.indexOfSelectedItem]
    }
    
    @objc private func didSelectTextTranslateTo(_ sender: NSView) {
        guard let service = currentSelectionOfTextTranslationService() else {
            assertionFailure()
            return
        }
        UserDefaults.group.textTargetLanguage = service.supportedLanguagesForTextTranslation()[textTranslateToPopUpButton.indexOfSelectedItem]
    }
    
    @objc private func didSelectPageTranslationOpenInNewTabButton(_ sender: NSView) {
        UserDefaults.group.pageTranslationTransitionBehavior
            = (pageTranslationOpenInNewTabButton.state == .on) ? .newTab : .currentTab
    }
    
    @objc private func didSelectTextTranslationOpenInNewTabButton(_ sender: NSView) {
        UserDefaults.group.textTranslationTransitionBehavior
            = (textTranslationOpenInNewTabButton.state == .on) ? .newTab : .currentTab
    }
    
    @objc private func didSelectToolbarItemBehavior(_ sender: NSView) {
        guard let index = toolbarItemBehaviorStackView.arrangedSubviews.firstIndex(of: sender),
            let behavior = Self.toolbarItemBehavior[optional: index] else {
            return
        }
        UserDefaults.group.toolbarItemBehavior = behavior
    }
    
    @objc private func didSelectOpenSafariPreferences(_ sender: NSView) {
        SFSafariApplication.showPreferencesForExtension(withIdentifier: "io.github.mshibanami.TranslateWebForSafari.Extension")
    }
    
    @objc private func didSelectAboutThisApp(_ sender: AnyObject?) {
        NSWorkspace.shared.open(Consts.supportPageURL)
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
