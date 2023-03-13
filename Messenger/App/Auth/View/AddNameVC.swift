//
//  AddNameVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/21/23.
//

import UIKit
import Combine

final class AddNameVC: DefaultCreateAccountVC {

    let subLabel: UILabel = .createSubLabel(with: "Enter the name you use in real life.") 
    let hStack = UIStackView(frame: .zero)
    let firstNameTextField = AuthTextField(viewModel: .init(placeholder: "First name", returnKey: .continue, type: .Default(.Name)))
    let surnameTextField = AuthTextField(viewModel: .init(placeholder: "Surname", returnKey: .done, type: .Default(.Name)))
    let nextButton = AuthButton(title: "Next")

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setUpViews()
        setUpConstraints()

    }
}

// MARK: - Bindings / Action
private extension AddNameVC {

    private func buttonAction() {
        print("JE")
        if firstNameTextField.validationSubject.value == .valid &&
            surnameTextField.validationSubject.value == .valid {
            print("JE2")
            // if valid on first press move to next vc
            coordinator?.user.firstName = firstNameTextField.textFieldSubject.value
            coordinator?.user.surname = surnameTextField.textFieldSubject.value
            coordinator?.goToAddBirthdayVC()
        } else {
            print("JE3")
            firstNameTextField.startValidation()
            surnameTextField.startValidation()
        }

    }
}

// MARK: - Views
private extension AddNameVC {
    private func setUpViews() {

        // txtFields
        firstNameTextField.delegate = self
        surnameTextField.delegate = self

        // hStack
        hStack.axis = .horizontal
        hStack.distribution = .fillEqually
        hStack.spacing = 10
        hStack.addArrangedSubview(firstNameTextField)
        hStack.addArrangedSubview(surnameTextField)

        // nextBtn
        nextButton.addAction(for: .touchUpInside) { [weak self] _ in
            self?.buttonAction()
        }

        contentView.addSubview(subLabel)
        contentView.addSubview(hStack)
        contentView.addSubview(nextButton)
    }
}

// MARK: - Constraints
private extension AddNameVC {
    private func setUpConstraints() {
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        subLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        subLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 30).isActive = true
        hStack.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        hStack.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        nextButton.topAnchor.constraint(equalTo: hStack.bottomAnchor, constant: 15).isActive = true
        nextButton.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

    }
}

// MARK: - TextFieldDelegate
extension AddNameVC: TextFieldDelegate {
    func textFieldShouldReturn(_ textFieldView: CustomTextField) -> Bool {
        if textFieldView == firstNameTextField {
            textFieldView.textField.resignFirstResponder()
            surnameTextField.textField.becomeFirstResponder()
        } else {
            textFieldView.textField.resignFirstResponder()
            buttonAction()
        }
        return true
    }
}
