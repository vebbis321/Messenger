//
//  AddPassvordVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/28/23.
//

import UIKit

final class AddPasswordVC: DefaultCreateAccountVC {

    let subLabel = SubLabel(labelText: "Create a password with at least 6 letters and numbers. It should be something that others can't guess.")
    let passwordTextField = AuthPasswordTextFieldView(placeholder: "Password", returnKey: .done)
    let nextButton = AuthButton(title: "Next")


    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setUpViews()
        setUpConstraints()
    }

    deinit {
        coordinator?.password = nil
        print("✅ Deinit AddPasswordVC")
    }
}

private extension AddPasswordVC {
    private func setUpViews() {

        // emailTextField
        passwordTextField.textField.delegate = self

        nextButton.action = { [weak self] in
            self?.coordinator?.goToAgreeAndCreateAccountVC()
        }

        contentView.addSubview(subLabel)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(nextButton)
    }
}

private extension AddPasswordVC {
    private func setUpConstraints() {
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        subLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        subLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        passwordTextField.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 30).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        nextButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15).isActive = true
        nextButton.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

    }
}

// MARK: - TextFieldDelegate
extension AddPasswordVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField.textField {
            textField.resignFirstResponder()
            // go to next view
        }
        return true
    }
}

