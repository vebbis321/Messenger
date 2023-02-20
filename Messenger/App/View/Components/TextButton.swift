//
//  TextButton.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/20/23.
//

import UIKit

class TextButton: UIButton {

    var action: (()->())?

    private var buttonText: String

    init(frame: CGRect = .zero, buttonText: String) {
        self.buttonText = buttonText
        super.init(frame: frame)

        setUpLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
private extension TextButton {
    private func setUpLayout() {
        setTitle(buttonText, for: .normal)
        setTitleColor(.theme.textButton, for: .normal)
        titleLabel?.textAlignment = .center
        titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - Action
private extension TextButton {
    @objc func btnTapped() {
        action?()
    }
}
