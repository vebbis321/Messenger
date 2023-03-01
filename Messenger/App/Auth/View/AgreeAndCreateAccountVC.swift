//
//  AgreeAndCreateAccountVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/28/23.
//

import UIKit

final class AgreeAndCreateAccountVC: DefaultCreateAccountVC {

    let viewModel = AgreeAndCreateAccountVM()
    let subLabel = SubLabel(labelText: "Create a password with at least 6 letters and numbers. It should be something that others can't guess.")
    let tappableTextFields: [TappableTextView] = Array(0..<4).map { _ in .init() }
    let vStack = UIStackView(frame: .zero)
    let nextButton = AuthButton(title: "I Agree")



    init(titleStr: String, password: String) {
        super.init(titleStr: titleStr)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setUpViews()
        setUpConstraints()
    }
}

private extension AgreeAndCreateAccountVC {
    private func setUpViews() {

        // tappableTextFields
        for (index, textField) in tappableTextFields.enumerated() {
            textField.text = viewModel.textItemVms[index].text
            textField.addTappableTexts(viewModel.textItemVms[index].tappableTextAndUrlString)
            vStack.addArrangedSubview(textField)
        }

        // vStack
        vStack.axis = .vertical
        vStack.spacing = 20

        // nextBtn
        nextButton.action = { [weak self] in
//            self?.coordinator?.goToAddEmailVC()
        }

        // content
        contentView.addSubview(subLabel)
        contentView.addSubview(vStack)
        contentView.addSubview(nextButton)
    }
}

private extension AgreeAndCreateAccountVC {
    private func setUpConstraints() {
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        subLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        subLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 20).isActive = true
        vStack.pinSides(to: contentView)

        nextButton.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 20).isActive = true
        nextButton.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

    }
}




