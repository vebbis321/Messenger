//
//  AddEmailVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/28/23.
//

import UIKit

final class AddEmailVC: DefaultCreateAccountVC {

    let subLabel: UILabel = .createSubLabel(with: "Enter the address at which you can be contacted. No one will see this on your profile.")
    let emailTextField = AuthTextField(viewModel: .init(placeholder: "Email address", returnKey: .done, type: .Default(.Email)))
    let nextButton: UIButton = AuthButton(title: "Next")


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


        nextButton.addAction(for: .touchUpInside) { [weak self] _ in
            guard let self = self else { return }
            self.coordinator?.user.email = self.emailTextField.textField.text!
            self.coordinator?.goToAddPasswordVC()
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


