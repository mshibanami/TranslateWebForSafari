// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import Cocoa
import SafariServices.SFSafariApplication

class ViewController: NSViewController {
    @IBOutlet var appNameLabel: NSTextField!
    
    private let appIconImageView: NSImageView = {
        let view = NSImageView(image: NSImage(named: "AppIcon")!)
        return view
    }()
    
    private let appTitleLabel: NSTextField = {
        let label = NSTextField(labelWithString: L10n.appName)
        label.font = NSFont.systemFont(ofSize: 13)
        return label
    }()
    
    private let openSafariPreferencesButton: NSButton = {
        let button = NSButton(title: L10n.openSafariPreferences, target: nil, action: nil)
        button.font = NSFont.systemFont(ofSize: 13)
        button.isHighlighted = true
        return button
    }()
    
    private let aboutThisExtensionButton: NSButton = {
        let button = NSButton(title: L10n.aboutThisExtension, target: nil, action: nil)
        button.font = NSFont.boldSystemFont(ofSize: 12)
        button.setButtonType(.momentaryPushIn)
        button.isBordered = true
        button.showsBorderOnlyWhileMouseInside = true
        button.bezelStyle = .recessed
        return button
    }()
    
    override func loadView() {
        let stackView = NSStackView(views: [
            appIconImageView,
            appTitleLabel,
            openSafariPreferencesButton,
            aboutThisExtensionButton
        ])
        stackView.orientation = .vertical
        stackView.alignment = .centerX
        stackView.distribution = .equalCentering
        stackView.setCustomSpacing(20, after: appIconImageView)
        stackView.setCustomSpacing(30, after: appTitleLabel)
        stackView.setCustomSpacing(16, after: openSafariPreferencesButton)
        
        let view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view.widthAnchor.constraint(equalToConstant: 480)])
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openSafariPreferencesButton.target = self
        openSafariPreferencesButton.action = #selector(didTapOpenSafariPreferences(_:))
        aboutThisExtensionButton.target = self
        aboutThisExtensionButton.action = #selector(didTapAboutThisApp(_:))
    }
    
    @IBAction func didTapOpenSafariPreferences(_ sender: AnyObject?) {
        SFSafariApplication.showPreferencesForExtension(withIdentifier: "io.github.mshibanami.TranslateWebForSafari.Extension")
    }
    
    @IBAction func didTapAboutThisApp(_ sender: AnyObject?) {
        NSWorkspace.shared.open(Consts.supportPageURL)
    }
}
