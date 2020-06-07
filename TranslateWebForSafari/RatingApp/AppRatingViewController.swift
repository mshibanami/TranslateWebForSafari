//
//  AppRatingViewController.swift
//  TranslateWebForSafari
//
//  Created by Manabu Nakazawa on 5/6/20.
//  Copyright © 2020 Manabu Nakazawa. All rights reserved.
//

import AppKit

class AppRatingViewController: NSViewController {
    private enum Mode {
        case opening
        case gotHighRate
        case gotLowRate
    }
    
    private var mode: Mode {
        guard let selectedRateIndex = selectedRateIndex else {
            return .opening
        }
        switch selectedRateIndex {
        case 0, 1, 2, 3:
            return .gotLowRate
        case 4:
            return .gotHighRate
        default:
            assertionFailure()
            return .opening
        }
    }
    
    var onSelectDismiss: (() -> Void)?
    var heightConstraint: NSLayoutConstraint?
    
    private var selectedRateIndex: Int? {
        didSet {
            updateUI(animated: true)
        }
    }
    
    private lazy var rateAppView = RateAppView()
    private lazy var appRatedView: AppRatedView = {
        let view = AppRatedView()
        view.alphaValue = 0
        return view
    }()
    
    private let ratingService: AppRatingService
    private let feedbackServices: [AppFeedbackService]
    
    init(ratingService: AppRatingService, feedbackServices: [AppFeedbackService]) {
        self.ratingService = ratingService
        self.feedbackServices = feedbackServices
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = Colors.rateAppBackgroundColor.cgColor
        
        view.addAutoLayoutSubview(rateAppView)
        rateAppView.centerInSuperview()
        
        view.addAutoLayoutSubview(appRatedView)
        appRatedView.centerInSuperview()
        
        heightConstraint = view.heightAnchor.constraint(equalToConstant: 110)
        heightConstraint?.isActive = true
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        updateUI(animated: false)
    }
    
    func setupBindings() {
        rateAppView.onSelectRate = { [weak self] index in
            self?.rateAppView.setup(
                title: index < 4
                    ? "Thank you 🙂"
                    : "Thank you!! 🙏",
                canRate: false,
                negativeAnswer: "")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.selectedRateIndex = index
            }
        }
        
        rateAppView.onSelectNegativeButton = { [weak self] in
            self?.onSelectDismiss?()
        }
        
        appRatedView.onSelectNegativeButton = { [weak self] view in
            self?.onSelectDismiss?()
        }
        
        appRatedView.onSelectPositiveButton = { [weak self] view in
            guard let self = self else {
                return
            }
            switch self.mode {
            case .opening:
                assertionFailure()
            case .gotHighRate:
                NSWorkspace.shared.open(self.ratingService.url)
                self.onSelectDismiss?()
            case .gotLowRate:
                let menu = NSMenu()
                menu.items = self.feedbackServices.enumerated().map { index, service in
                    let menuItem = NSMenuItem(
                        title: service.serviceTitle,
                        action: #selector(self.didSelectFeedbackMenuItem(_:)),
                        keyEquivalent: "")
                    menuItem.tag = index
                    return menuItem
                }
                
                guard let event = NSApplication.shared.currentEvent else {
                    return
                }
                NSMenu.popUpContextMenu(menu, with: event, for: view)
            }
        }
    }
    
    private func updateUI(animated: Bool) {
        switch mode {
        case .opening:
            rateAppView.alphaValue = 1
            appRatedView.layer?.setAffineTransform(.init(translationX: 10, y: 0))
        case .gotHighRate, .gotLowRate:
            appRatedView.layer?.setAffineTransform(.init(translationX: 10, y: 0))
            appRatedView.layer?.setAffineTransform(.init(translationX: 0, y: 0))
        }
        
        switch mode {
        case .opening:
            rateAppView.setup(
                title: "How would you rate this version?",
                canRate: true,
                negativeAnswer: "No thanks")
        case .gotHighRate:
            appRatedView.setup(
                title: ratingService.ratingRequestTitle,
                positiveAnswer: ratingService.positiveButtonTitle,
                negativeAnswer: "No thanks")
        case .gotLowRate:
            appRatedView.setup(
                title: "Would you mind giving us some feedback?",
                positiveAnswer: "Send Feedback…",
                negativeAnswer: "No thanks")
        }
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.4
            context.allowsImplicitAnimation = true
            switch mode {
            case .opening:
                break
            case .gotHighRate, .gotLowRate:
                rateAppView.alphaValue = 0
                rateAppView.layer?.setAffineTransform(.init(translationX: 0, y: -20))
            }
        }, completionHandler: {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.3
                context.allowsImplicitAnimation = true
                switch self.mode {
                case .opening:
                    self.appRatedView.isHidden = true
                    break
                case .gotHighRate, .gotLowRate:
                    self.appRatedView.isHidden = false
                    self.appRatedView.alphaValue = 1
                    self.appRatedView.layer?.setAffineTransform(.init(translationX: 0, y: 0))
                }
            }
        })
    }

    private func updateUIAnimation() {
        

    }
    
    @objc private func didSelectFeedbackMenuItem(_ sender: NSMenuItem) {
        guard let service = feedbackServices[optional: sender.tag] else {
            assertionFailure()
            return
        }
        NSWorkspace.shared.open(service.url)
    }
}

private extension AppRatingService {
    var ratingRequestTitle: String {
        switch self {
        case .appStore:
            return "Would you mind giving us 5 stars on App Store as well?"
        case .gitHub:
            return "Would you mind giving us a star on GitHub as well?"
        }
    }
    
    var positiveButtonTitle: String {
        switch self {
        case .appStore:
            return "Sure, go to App Store"
        case .gitHub:
            return "Sure, go to GitHub"
        }
    }
}
