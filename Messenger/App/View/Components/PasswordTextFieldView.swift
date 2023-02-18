//
//  PasswordTextFieldView.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/16/23.
//

import UIKit

final class PasswordTextFieldView: CustomTextFieldView {

    required init(frame: CGRect = .zero, placeholder: String, rightBtnIcon: String = "eye.slash", keyboard: UIKeyboardType = .default) {
        super.init(placeholder: placeholder, rightBtnIcon: rightBtnIcon, keyboard: keyboard)
        textField.isSecureTextEntry = true
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func handleTextFieldBecameActive() {
        layer.borderColor = UIColor.theme.activeBorder?.cgColor
        iconBtn.isHidden = false

        floatingLabel.transform = .init(translationX: 0, y: -(textField.intrinsicContentSize.height * 0.45))
        floatingLabel.textColor = .theme.floatingLabel
        floatingLabel.font = .systemFont(ofSize: 12, weight: .regular)

        textField.transform = .init(translationX: 0, y: 7.5)
    }

    override func handleTextFieldBecameEmpty() {

    }

    override func handleTextFieldBecameNonEmpty() {

    }

    override func setUpActions() {
        textField.togglePasswordVisibility()
    }


}

