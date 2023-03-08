//
//  AddEmailVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/28/23.
//

import UIKit

final class AddEmailVC: DefaultCreateAccountVC {

    let subLabel: UILabel = .createSubLabel(with: "Enter the address at which you can be contacted. No one will see this on your profile.") 
    let emailTextField = AuthTextFieldClearView(placeholder: "Email address", keyboard: .emailAddress, returnKey: .done)
    let nextButton = AuthButton(title: "Next")


    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setUpViews()
        setUpConstraints()
    }
}

private extension AddEmailVC {
    private func setUpViews() {

        // emailTextField
        emailTextField.textField.delegate = self

        nextButton.addAction(for: .touchUpInside) { [weak self] _ in
            self?.coordinator?.goToAddPasswordVC()
        }

        contentView.addSubview(subLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(nextButton)
    }
}

private extension AddEmailVC {
    private func setUpConstraints() {
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        subLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        subLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        emailTextField.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 30).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        nextButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15).isActive = true
        nextButton.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

    }
}

// MARK: - TextFieldDelegate
extension AddEmailVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField.textField {
            textField.resignFirstResponder()
            // go to next view
        }
        return true
    }
}

