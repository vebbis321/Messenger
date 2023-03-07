//
//  AddNameVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/21/23.
//

import UIKit
import Combine

final class AddNameVC: DefaultCreateAccountVC {

    let viewModel = AddNameVM()

    let subLabel: UILabel = .createSubLabel(with: "Enter the name you use in real life.") 
    let hStack = UIStackView(frame: .zero)
    let firstNameTextField = AuthTextFieldErrorView(placeholder: "First name", keyboard: .default, returnKey: .continue)
    let surnameTextField = AuthTextFieldErrorView(placeholder: "Surname", keyboard: .default, returnKey: .done)
    let nextButton = UIButton.createAuthButton(with: "Next")

    private var subscriptions = Set<AnyCancellable>()
    private var nameSubscription: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setUpViews()
        setUpConstraints()
        setUpBindings()
    }
}

// MARK: - Bindings
private extension AddNameVC {
    private func setUpBindings() {
        firstNameTextField.textField.createBinding(with: viewModel.firstName, storeIn: &subscriptions)
        surnameTextField.textField.createBinding(with: viewModel.lastName, storeIn: &subscriptions)
    }

    private func startNameStateObserver() {
        nameSubscription = viewModel
            .nameStatus
            .removeDuplicates(by: { prev, curr in
                prev.0 == curr.0 || prev.1 == curr.1
            })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (firstNameStatus, surnameStatus) in
                if firstNameStatus != .valid {
                    self?.firstNameTextField.isError = true
                } else {
                    self?.firstNameTextField.isError = false
                }

                if surnameStatus != .valid {
                    self?.surnameTextField.isError = true
                } else {
                    self?.surnameTextField.isError = false
                }
            }
    }
}

// MARK: - Views
private extension AddNameVC {
    private func setUpViews() {

        // txtFields
        firstNameTextField.textField.delegate = self
        surnameTextField.textField.delegate = self

        // hStack
        hStack.axis = .horizontal
        hStack.distribution = .fillEqually
        hStack.spacing = 10
        hStack.addArrangedSubview(firstNameTextField)
        hStack.addArrangedSubview(surnameTextField)

        // nextBtn
        nextButton.addAction(for: .touchUpInside) { [weak self] _ in
            guard let self = self else { return }

            if self.viewModel.nameStatus.value == (.valid, .valid) {
                // if valid on first press move to next vc
                self.coordinator?.goToAddBirthdayVC()
            } else if self.nameSubscription == nil {
                // ... else start the nameStateObserver
                self.startNameStateObserver()
            }
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
extension AddNameVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField.textField {
            textField.resignFirstResponder()
            surnameTextField.textField.becomeFirstResponder()
        } else {
            // nextBtn action

        }
        return true
    }
}
