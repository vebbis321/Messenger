//
//  PasswordTextFieldView.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/16/23.
//

import UIKit

final class PasswordTextFieldView: CustomTextFieldView {

    required init(frame: CGRect = .zero, placeholder: String, keyboard: UIKeyboardType = .default) {
        super.init(placeholder: placeholder, keyboard: keyboard)

        textField.isSecureTextEntry = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func handleTextFieldBecameInactive() {
        print("INACTIVE")

    }
        
    override func handleTextFieldBecameActive() {
        print("Active")
    }

    override func handleTextFieldBecameEmpty() {
        print("EMprty")
    }

    override func handleTextFieldBecameNonEmpty() {
        print("Not empty")
    }


}

