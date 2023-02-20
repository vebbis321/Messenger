//
//  SecondaryButton.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/20/23.
//

import UIKit

final class SecondaryButton: TextButton {
    override init(frame: CGRect = .zero, buttonText: String) {
        super.init(buttonText: buttonText)
        addBorder()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Border
private extension SecondaryButton {
    private func addBorder() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.theme.border?.cgColor
        layer.masksToBounds = true
        layer.cornerRadius = 3

        guard let titleLabel = titleLabel else {
            fatalError() // Remove in production
        }

        topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10).isActive = true
        bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
    }
}
