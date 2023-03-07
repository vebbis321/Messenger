//
//  CustomTextFieldView.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/19/23.
//

import UIKit
import Combine

class AuthTextFieldClearView: AuthTextFieldView<UITextField> {

    private var subscriptions = Set<AnyCancellable>()
    lazy var clearBtn: UIButton = .createIconButton(icon: "xmark", size: 17)

    override init(frame: CGRect = .zero, placeholder: String, keyboard: UIKeyboardType = .default, returnKey: UIReturnKeyType) {
        super.init(placeholder: placeholder, keyboard: keyboard, returnKey: returnKey)

        updateLayout()
        setUpBindings()
        setUpActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Bindings / Actions
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

    private func setUpActions() {
        clearBtn.addAction(for: .touchUpInside) { [weak self] _ in
            self?.textField.text = ""
            NotificationCenter.default.post(
                name:UITextField.textDidChangeNotification, object: self?.textField)
        }
    }
}

// MARK: - updateLayout
private extension AuthTextFieldClearView {
    private func updateLayout() {
        clearBtn.isHidden = true
        addSubview(clearBtn)

        clearBtn.translatesAutoresizingMaskIntoConstraints = false
        clearBtn.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        clearBtn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        txtFieldRightAnchorConstraint.constant = -(30 + clearBtn.intrinsicContentSize.width)
        layoutIfNeeded()
    }
}

extension AuthTextFieldClearView {
    // MARK: - Functions
    func handleTextFieldBecameActive() {
        layer.borderColor = UIColor.theme.activeBorder?.cgColor
        floatingLabel.transform = .init(translationX: 0, y: -(textField.intrinsicContentSize.height * 0.45))
        floatingLabel.textColor = .theme.floatingLabel
        floatingLabel.font = .systemFont(ofSize: 13, weight: .regular)

        textField.transform = .init(translationX: 0, y: 7.5)

        if !(textField.text?.isEmpty ?? true) {
            clearBtn.isHidden = false
        }
    }

    func handleTextFieldBecameInactive() {

        layer.borderColor = UIColor.theme.border?.cgColor
        clearBtn.isHidden = true

        if textField.text?.isEmpty ?? true {
            floatingLabel.transform = .identity
            floatingLabel.textColor = .theme.placeholder
            floatingLabel.font = .systemFont(ofSize: 17, weight: .regular)

            textField.transform = .identity
        }
    }

    func handleTextFieldBecameNonEmpty() {
        clearBtn.isHidden = false
    }

    func handleTextFieldBecameEmpty() {
        clearBtn.isHidden = true
    }
}


