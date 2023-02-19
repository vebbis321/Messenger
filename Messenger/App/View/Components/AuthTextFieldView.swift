//
//  CustomTextFieldView.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/19/23.
//

import UIKit
import Combine

final class AuthTextFieldView: CustomAuthTextFieldImpl {

    private var subscriptions = Set<AnyCancellable>()

    init(frame: CGRect = .zero, placeholder: String, keyboard: UIKeyboardType = .default) {
        super.init(placeholder: placeholder, icon: "xmark", keyboard: keyboard)

        setUpBindings()
        setUpActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Bindings / Actions
private extension AuthTextFieldView {
    func setUpBindings() {
        Publishers.Merge(textField.textBecameActivePublisher(), textField.textBecameInActivePublisher())
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isActive in
                isActive ? self?.handleTextFieldBecameActive() : self?.handleTextFieldBecameInactive()
            }.store(in: &subscriptions)

        textField.textIsEmptyPublisher()
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isTextEmpty in
                isTextEmpty ? self?.handleTextFieldBecameEmpty() : self?.handleTextFieldBecameNonEmpty()
            }.store(in: &subscriptions)
    }

    func setUpActions() {
        iconBtn.action = { [weak self] in
            self?.textField.text = ""
            NotificationCenter.default.post(
                name:UITextField.textDidChangeNotification, object: self?.textField)

        }
    }
}

// MARK: - Functions
private extension AuthTextFieldView {

    func handleTextFieldBecameActive() {
        layer.borderColor = UIColor.theme.activeBorder?.cgColor
        floatingLabel.transform = .init(translationX: 0, y: -(textField.intrinsicContentSize.height * 0.45))
        floatingLabel.textColor = .theme.floatingLabel
        floatingLabel.font = .systemFont(ofSize: 13, weight: .regular)

        textField.transform = .init(translationX: 0, y: 7.5)

        if !(textField.text?.isEmpty ?? true) {
            iconBtn.isHidden = false
        }
    }

    func handleTextFieldBecameInactive() {

        layer.borderColor = UIColor.theme.border?.cgColor
        iconBtn.isHidden = true

        if textField.text?.isEmpty ?? true {
            floatingLabel.transform = .identity
            floatingLabel.textColor = .theme.placeholder
            floatingLabel.font = .systemFont(ofSize: 17, weight: .regular)

            textField.transform = .identity
        }
    }

    func handleTextFieldBecameNonEmpty() {
        iconBtn.isHidden = false
    }

    func handleTextFieldBecameEmpty() {
        iconBtn.isHidden = true
    }
}
