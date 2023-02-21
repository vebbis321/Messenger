//
//  AddNameVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/21/23.
//

import UIKit

final class AddNameVC: DefaultCreateAccountVC {
    let subLabel = UILabel(frame: .zero)
    let hStack = UIStackView(frame: .zero)
    let firstNameTextField = AuthTextFieldClearView(placeholder: "First name", keyboard: .default, returnKey: .continue)
    let surnameTextField = AuthTextFieldClearView(placeholder: "Surname", keyboard: .default, returnKey: .done)
    let nextButton = AuthButton(title: "Next")


    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        setUpConstraints()
    }
}

private extension AddNameVC {
    private func setUpViews() {
        // subLabel
        subLabel.font = .preferredFont(forTextStyle: .subheadline)
        subLabel.text = "Enter the name you use in real life."

        // hStack
        hStack.axis = .horizontal
        hStack.distribution = .fillEqually
        hStack.spacing = 10
        hStack.addArrangedSubview(firstNameTextField)
        hStack.addArrangedSubview(surnameTextField)

        nextButton.action = {
            print("Tapped")
        }

        contentView.addSubview(subLabel)
        contentView.addSubview(hStack)
        contentView.addSubview(nextButton)
    }
}

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
