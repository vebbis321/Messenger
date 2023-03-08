//
//  UIButton+Components.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 3/7/23.
//

import UIKit

// MARK: - SF Symbol Button
public extension UIButton {
    static func createIconButton(
        icon: String,
        size: CGFloat = 17,
        weight: UIImage.SymbolWeight = .medium
    ) -> UIButton {

        let button = IncreaseTapAreaButton()

        let config = UIImage.SymbolConfiguration(pointSize: size, weight: weight)
        let iconImage = UIImage(systemName: icon, withConfiguration: config)?.withTintColor(.theme.tintColor!, renderingMode: .alwaysOriginal)
        button.setImage(iconImage, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.backgroundColor = .green

        // constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: size).isActive = true
        return button
    }

    func updateIcon(
        newIcon: String,
        newColor: UIColor? = nil,
        newWeight: UIImage.SymbolWeight = .medium,
        newSize: CGFloat = 17
    ) {

        let config = UIImage.SymbolConfiguration(pointSize: newSize, weight: newWeight)
        let iconImage = UIImage(systemName: newIcon, withConfiguration: config)?.withTintColor(newColor ?? .theme.tintColor!, renderingMode: .alwaysOriginal)
        setImage(iconImage, for: .normal)
        heightConstraint?.constant = newSize

    }
}

// MARK: - TextButton
public extension UIButton {
    static func createTextButton(with buttonText: String) -> UIButton {
        let button = UIButton(frame: .zero)
        button.setTitle(buttonText, for: .normal)
        button.setTitleColor(.theme.tintColor, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    static func createSecondaryButton(with buttonText: String) -> UIButton {
        let button = createTextButton(with: buttonText)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.theme.border?.cgColor
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 3

        guard let titleLabel = button.titleLabel else {
            fatalError() // Remove in production
        }

        button.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10).isActive = true
        button.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        return button
    }
}



