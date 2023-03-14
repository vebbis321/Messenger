//
//  AddPassvordVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/28/23.
//

import UIKit

final class AddPasswordVC: DefaultCreateAccountVC {

    let subLabel = UILabel.createSubLabel(with: "Create a password with at least 6 letters and numbers. It should be something that others can't guess.")
    let passwordTextField = AuthTextField(viewModel: .init(placeholder: "Password", returnKey: .done, type: .Password))
    lazy var nextButton = AuthButton(title: "Next")


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

// MARK: - Action
private extension AddPasswordVC {
    private func buttonAction() {
        if passwordTextField.validationSubject.value == .valid {
            // if valid on first press move to next vc
            coordinator?.password = passwordTextField.textFieldSubject.value
            coordinator?.goToAgreeAndCreateAccountVC()
        } else {
            passwordTextField.startValidation()
        }

    }
}

// MARK: - Views
private extension AddPasswordVC {
    private func setUpViews() {

        // emailTextField
        passwordTextField.delegate = self

        nextButton.addAction(for: .touchUpInside) { [weak self] _ in
            self?.buttonAction()
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
extension AddPasswordVC: TextFieldDelegate {
    func textFieldShouldReturn(_ textFieldView: CustomTextField) -> Bool {
        if textFieldView == passwordTextField {
            textFieldView.resignFirstResponder()
            // go to next view
        }
        return true
    }
}


