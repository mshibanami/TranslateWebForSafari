// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import AppKit

class AppRatedView: NSView {
    var onSelectPositiveButton: ((NSView) -> Void)?
    var onSelectNegativeButton: ((NSView) -> Void)?
    
    private let titleLabel: NSTextField = {
        let label = NSTextField(labelWithString: "")
        label.font = NSFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var positiveButton: NSButton = {
        let button = NSButton(title: "", target: self, action: #selector(didSelectPositiveButton(_:)))
        button.isHighlighted = true
        return button
    }()
    
    private lazy var negativeButton: NSButton = {
        let button = NSButton(title: "", target: self, action: #selector(didSelectNegativeButton(_:)))
        button.isBordered = false
        button.font = NSFont.boldSystemFont(ofSize: 12)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        let stackView = NSStackView(views: [
            titleLabel,
            positiveButton,
            negativeButton])
        stackView.setCustomSpacing(14, after: titleLabel)
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
    
    func setup(title: String, positiveAnswer: String?, negativeAnswer: String?) {
        titleLabel.stringValue = title
        positiveButton.isHidden = (positiveAnswer == nil)
        positiveButton.title = positiveAnswer ?? ""
        negativeButton.isHidden = (negativeAnswer == nil)
        negativeButton.title = negativeAnswer ?? ""
    }
    
    @objc private func didSelectPositiveButton(_ sender: NSView) {
        onSelectPositiveButton?(sender)
    }
    
    @objc private func didSelectNegativeButton(_ sender: NSView) {
        onSelectNegativeButton?(sender)
    }
}
