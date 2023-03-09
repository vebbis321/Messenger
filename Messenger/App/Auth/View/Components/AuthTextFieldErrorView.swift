//
//  AuthTextFieldErrorView.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 3/2/23.
//

import UIKit
import Combine

final class AuthTextFieldErrorView: AuthTextFieldClearView {

    private var subscriptions = Set<AnyCancellable>()
    var isError: Bool = false {
        didSet {
            if isError == true {
                textFieldBecameNonValid()
            } else {
                textFieldBecameValid()
            }
        }
    }

    override init(frame: CGRect = .zero, placeholder: String, keyboard: UIKeyboardType = .default, returnKey: UIReturnKeyType) {
        super.init(placeholder: placeholder, keyboard: keyboard, returnKey: returnKey)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setUpBindings() {
        Publishers.Merge(textField.textBecameActivePublisher(), textField.textBecameInActivePublisher())
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isActive in
                guard let self = self else { return }
                if self.isError {
                    isActive ? self.errorTextFieldBecameActive() : self.errorTextFieldBecameInActive()
                } else {
                    isActive ? self.handleTextFieldBecameActive() : self.handleTextFieldBecameInactive()
                }
            }.store(in: &subscriptions)

        textField.textIsEmptyPublisher()
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isTextEmpty in
                guard let self = self else { return }
                if self.isError {
                    isTextEmpty ? self.errorTextFieldBecameEmpty() : self.errorTextFieldBecameNonEmpty()
                } else {
                    isTextEmpty ? self.handleTextFieldBecameEmpty() : self.handleTextFieldBecameNonEmpty()
                }
            }.store(in: &subscriptions)
    }

}


// MARK: - Functions
private extension AuthTextFieldErrorView {
    private func textFieldBecameNonValid() {
        floatingLabel.textColor = .red
        layer.borderColor = UIColor.red.cgColor

        if !(textField.text?.isEmpty ?? true) {
            clearBtn.updateIcon(
                newIcon: "exclamationmark.circle",
                newColor: .red,
                newWeight: .regular
            )
            clearBtn.isEnabled = false
            clearBtn.isHidden = false
        }

    }

    private func textFieldBecameValid() {
        floatingLabel.textColor = .theme.placeholder
        layer.borderColor = UIColor.theme.activeBorder?.cgColor

        clearBtn.updateIcon(
            newIcon: "xmark"
        )
        clearBtn.isEnabled = true

        if (textField.text?.isEmpty ?? true) {
            clearBtn.isHidden = false
        }
    }

    private func errorTextFieldBecameActive() {
        floatingLabel.transform = .init(translationX: 0, y: -(textField.intrinsicContentSize.height * 0.45))
        floatingLabel.font = .systemFont(ofSize: 13, weight: .regular)
        textField.transform = .init(translationX: 0, y: 7.5)
    }

    private func errorTextFieldBecameInActive() {

        if textField.text?.isEmpty ?? true {
            floatingLabel.transform = .identity
            floatingLabel.font = .systemFont(ofSize: 17, weight: .regular)
            textField.transform = .identity
        }
    }

    private func errorTextFieldBecameEmpty() {
        clearBtn.updateIcon(
            newIcon: "exclamationmark.circle",
            newColor: .red,
            newWeight: .regular
        )
        clearBtn.isEnabled = false
        clearBtn.isHidden = false
    }

    private func errorTextFieldBecameNonEmpty() {
        clearBtn.updateIcon(
            newIcon: "xmark"
        )
        clearBtn.isEnabled = true
        clearBtn.isHidden = false
    }
}

