//
//  RateAppView.swift
//  TranslateWebForSafari
//
//  Created by Manabu Nakazawa on 4/6/20.
//  Copyright © 2020 Manabu Nakazawa. All rights reserved.
//

import Cocoa

class RateAppView: NSView {
    var onSelectRate: ((Int) -> Void)? {
        get {
            return ratingStarsView.onSelectRate
        }
        set {
            ratingStarsView.onSelectRate = newValue
        }
    }
    
    var onSelectNegativeButton: (() -> Void)?
    
    private let titleLabel: NSTextField = {
        let label = NSTextField(labelWithString: "")
        label.font = NSFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let negativeButton: NSButton = {
        let button = NSButton(title: "", target: nil, action: nil)
        button.isBordered = false
        button.font = NSFont.boldSystemFont(ofSize: 12)
        return button
    }()
    
    private let ratingStarsView: RatingStarsView = {
        let view = RatingStarsView()
        return view
    }()
    
    init() {
        super.init(frame: .zero)

        let stackView = NSStackView(views: [
            titleLabel,
            ratingStarsView,
            negativeButton
        ])
        stackView.setCustomSpacing(8, after: titleLabel)
        stackView.orientation = .vertical
        stackView.distribution = .fill
        addAutoLayoutSubview(stackView)
        stackView.fillToSuperview()
        negativeButton.target = self
        negativeButton.action = #selector(didSelectNegativeButton(_:))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(title: String, canRate: Bool, negativeAnswer: String?) {
        titleLabel.stringValue = title
        ratingStarsView.setIsUserInteractionEnabled(canRate)
        negativeButton.isHidden = (negativeAnswer == nil)
        negativeButton.title = negativeAnswer ?? ""
    }
    
    @objc private func didSelectNegativeButton(_ sender: NSView) {
        onSelectNegativeButton?()
    }
}


class RatingStarsView: NSView {
    private static let userInfoTagKey = "tag"
    
    var onSelectRate: ((Int) -> Void)?
    
    private var stackView: NSStackView = {
        let stackView = NSStackView()
        stackView.spacing = 0
        return stackView
    }()
    
    var selectingIndex: Int? {
        didSet {
            updateUI()
        }
    }
    
    var selectedIndex: Int? {
        didSet {
            updateUI()
        }
    }

    init() {
        super.init(frame: .zero)
        
        let starButtons = (0..<5).map { index -> NSButton in
            let button = NSButton(image: NSImage(), target: self, action: #selector(didSelectStar(_:)))
            button.isBordered = false
            button.tag = index
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 40),
                button.heightAnchor.constraint(equalToConstant: 22),
            ])
            button.addTrackingArea(NSTrackingArea(
                rect: NSRect(origin: .zero, size: button.fittingSize),
                options: [.mouseEnteredAndExited, .activeAlways],
                owner: self,
                userInfo: [Self.userInfoTagKey: index]))
            return button
        }
        for button in starButtons {
            (button.cell as! NSButtonCell).imageDimsWhenDisabled = false
            stackView.addArrangedSubview(button)
        }
        addAutoLayoutSubview(stackView)
        stackView.fillToSuperview()
        
        stackView.addTrackingArea(NSTrackingArea(
            rect: NSRect(origin: .zero, size: stackView.fittingSize),
            options: [.mouseEnteredAndExited, .activeAlways],
            owner: self,
            userInfo: nil))
        
        updateUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setIsUserInteractionEnabled(_ isUserInteractionEnabled: Bool) {
        for button in stackView.arrangedSubviews as! [NSButton] {
            button.isEnabled = isUserInteractionEnabled
        }
    }
    
    @objc private func didSelectStar(_ sender: NSButton) {
        let selectedIndex = sender.tag
        self.selectedIndex = selectedIndex
        onSelectRate?(selectedIndex)
    }
    
    private func updateUI() {
        let starIndex = selectedIndex ?? selectingIndex ?? -1
        
        for (index, button) in (stackView.arrangedSubviews as! [NSButton]).enumerated() {
            let isFilled = index <= starIndex
            button.image = isFilled ? #imageLiteral(resourceName: "starFill") : #imageLiteral(resourceName: "starOutline")
            button.setTintColor(isFilled ? .clear : NSColor.knobColor)
        }
    }
    
    override func mouseEntered(with event: NSEvent) {
        guard let mouseOveredButtonIndex = event.trackingArea?.userInfo?[Self.userInfoTagKey] as? Int else {
            return
        }
        self.selectingIndex = mouseOveredButtonIndex
    }
    
    override func mouseExited(with event: NSEvent) {
        guard event.trackingArea?.userInfo?[Self.userInfoTagKey] == nil else {
            return
        }
        self.selectingIndex = nil
    }
}

extension NSButton {
    func setTintColor(_ tintColor: NSColor) {
        if #available(OSX 10.14, *) {
            contentTintColor = tintColor
        } else {
            image = image?.withTintColor(tintColor)
        }
    }
}

extension NSImage {
    func withTintColor(_ tintColor: NSColor) -> NSImage {
        guard isTemplate else {
            return self
        }
        guard let image = self.copy() as? NSImage else {
            return self
        }
        image.lockFocus()
        tintColor.set()
        let bounds = NSMakeRect(0, 0, image.size.width, image.size.height)
        bounds.fill(using: .sourceAtop)
        image.unlockFocus()
        return image
    }
}
