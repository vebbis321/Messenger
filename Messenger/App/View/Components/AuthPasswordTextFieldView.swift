//
//  PasswordTextFieldView.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/16/23.
//

import UIKit
import Combine

final class AuthPasswordTextFieldView: AuthTextFieldView<UITextField> {

    private var subscriptions = Set<AnyCancellable>()

    private let showHidePasswordBtn = CustomIconBtn(icon: "eye.slash")

    init(frame: CGRect = .zero, placeholder: String, returnKey: UIReturnKeyType) {
        super.init(placeholder: placeholder, returnKey: returnKey)
        updateLayout()
        setUpBindings()
        setUpAction()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - updateLayout
private extension AuthPasswordTextFieldView {
    private func updateLayout() {
        textField.isSecureTextEntry = true
        textField.textContentType = .password

        showHidePasswordBtn.isHidden = true
        addSubview(showHidePasswordBtn)

        showHidePasswordBtn.translatesAutoresizingMaskIntoConstraints = false
        showHidePasswordBtn.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        showHidePasswordBtn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        txtFieldRightAnchorConstraint.constant = -(15 + showHidePasswordBtn.intrinsicContentSize.width)
        layoutIfNeeded()
    }
}

// MARK: - Bindings / Actions
private extension AuthPasswordTextFieldView {
    private func setUpBindings() {
        Publishers.Merge(textField.textBecameActivePublisher(), textField.textBecameInActivePublisher())
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isActive in
                isActive ? self?.handleTextFieldBecameActive() : self?.handleTextFieldBecameInactive()
            }.store(in: &subscriptions)
    }

    private func setUpAction() {
        showHidePasswordBtn.action = { [weak self] in
            guard let self = self else { return }

            self.textField.togglePasswordVisibility()
            let isSecure = self.textField.isSecureTextEntry
            self.showHidePasswordBtn.updateIcon(for: "eye\(isSecure ? ".slash" : "")")
        }
    }
}

// MARK: - Funtctions
private extension AuthPasswordTextFieldView {

    private func handleTextFieldBecameActive() {
        layer.borderColor = UIColor.theme.activeBorder?.cgColor
        showHidePasswordBtn.isHidden = false
        floatingLabel.transform = .init(translationX: 0, y: -(textField.intrinsicContentSize.height * 0.45))
        floatingLabel.textColor = .theme.floatingLabel
        floatingLabel.font = .systemFont(ofSize: 13, weight: .regular)

        textField.transform = .init(translationX: 0, y: 7.5)

    }

    private func handleTextFieldBecameInactive() {

        layer.borderColor = UIColor.theme.border?.cgColor

        if textField.text?.isEmpty ?? true {
            showHidePasswordBtn.isHidden = true
            floatingLabel.transform = .identity
            floatingLabel.textColor = .theme.placeholder
            floatingLabel.font = .systemFont(ofSize: 17, weight: .regular)

            textField.transform = .identity
        }
    }

}
