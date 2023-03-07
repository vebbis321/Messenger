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
        size: CGFloat = 20,
        weight: UIImage.SymbolWeight = .regular
    ) -> UIButton {


        let button = IncreaseTapAreaButton()
        let config = UIImage.SymbolConfiguration(weight: weight)
        let iconImage = UIImage(systemName: icon, withConfiguration: config)?.withTintColor(.theme.tintColor!, renderingMode: .alwaysOriginal)
        button.setImage(iconImage, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        // constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: size).isActive = true
        button.widthAnchor.constraint(equalToConstant: size).isActive = true
        return button
    }

    func updateIcon(
        newIcon: String,
        newColor: UIColor? = nil,
        newWeight: UIImage.SymbolWeight = .regular,
        newSize: CGFloat = 20
    ) {

        setImage(UIImage(systemName: newIcon)?.withTintColor(newColor ?? .theme.tintColor!, renderingMode: .alwaysOriginal), for: .normal)
        widthConstraint?.constant = newSize
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

// MARK: - AuthButton
public extension UIButton {
    static func createAuthButton(with title: String) -> LoadingButton {

        let button = LoadingButton()
        button.text = title
        guard let titleLabel = button.titleLabel else { return button }
        button.backgroundColor = .theme.button
        button.setTitleColor(.theme.buttonText, for: .normal)
        button.setTitleColor(.theme.buttonText, for: .highlighted)
        button.layer.cornerRadius = 3
        button.setTitle(button.text, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)

        // activityIndicator
        button.activityIndicator.hidesWhenStopped = true
        button.activityIndicator.color = .theme.buttonText

        button.addSubview(button.activityIndicator)

        // self
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -15).isActive = true
        button.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true

        // activityIndicator
        button.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        button.activityIndicator.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        button.activityIndicator.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true

        return button
    }

    func showLoading() {
        guard let button = self as? LoadingButtonProtocol else { return }
        button.setTitle("", for: .normal)
        button.activityIndicator.startAnimating()

    }

    func hideLoading() {
        guard let button = self as? LoadingButtonProtocol else { return }
        button.setTitle(button.text, for: .normal)
        button.activityIndicator.stopAnimating()
    }
}


