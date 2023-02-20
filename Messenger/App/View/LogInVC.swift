//
//  SignUpVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/13/23.
//

import UIKit
import Combine

final class LogInVC: UIViewController {

    weak var coordinator: AuthCoordinator?

    private let containerView = UIView(frame: .zero)

    private var keyboardPublisher: AnyCancellable?
    private var flowLayoutConstraint: NSLayoutConstraint!

    private let messengerLogo = UIImageView(frame: .zero)

    private var vStack: UIStackView!
    private let emailNumberTextField = AuthTextFieldClearView(placeholder: "Mobile number or email address", returnKey: .continue)
    private let passwordTextField = AuthPasswordTextFieldView(placeholder: "Password", returnKey: .done)
    private let loginBtn = AuthButton(title: "Log In")
    private let forgotPasswordBtn = TextButton(buttonText: "Forgotten Password?")

    private let secondaryButton = SecondaryButton(buttonText: "Create new account")
    private let metaLogo = UIImageView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setUpViews()
        setUpConstraints()
        setUpActions()



    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if keyboardPublisher == nil {
            keyboardPublisher = keyboardListener()
                .sink(receiveValue: { [unowned self] keyboard in
                    switch keyboard.state {
                    case .willShow:
                        manageKeyboardChange(value: keyboard.height)
                    case .willHide:
                        manageKeyboardChange(value: 0)
                    }
                })
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardPublisher = nil
        keyboardPublisher?.cancel()
    }

    func manageKeyboardChange(value: CGFloat) {
        if value != 0 {
            flowLayoutConstraint.constant = ((value - (view.frame.height - vStack.frame.maxY)) - 20)
        } else {
            flowLayoutConstraint.constant = value
        }

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:  { [weak self] in
            self?.view.layoutIfNeeded()
        }, completion: nil)

    }
    
}

// MARK: - Actions
private extension LogInVC {
    private func setUpActions() {
        loginBtn.action = {

        }

        forgotPasswordBtn.action = {

        }

        secondaryButton.action = { [weak self] in
            self?.coordinator?.goToCreateAccount()
        }
    }
}

// MARK: - Views
private extension LogInVC {
    private func setUpViews() {
        // self
        view.backgroundColor = .theme.background

        // messengerLogo
        messengerLogo.image = UIImage(named: "Icon")

        // txtFields
        emailNumberTextField.textField.delegate = self
        passwordTextField.textField.delegate = self

        // vStack
        vStack = .init(arrangedSubviews: [emailNumberTextField, passwordTextField, loginBtn, forgotPasswordBtn])
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.spacing = 10

        // metaLogo
        metaLogo.image = UIImage(named: "MetaLogo")?.withRenderingMode(.alwaysTemplate)
        metaLogo.contentMode = .scaleAspectFit
        metaLogo.tintColor = .theme.metaLogo

        // containerView
        view.addSubview(containerView)
        containerView.addSubview(messengerLogo)
        containerView.addSubview(vStack)
        containerView.addSubview(secondaryButton)
        containerView.addSubview(metaLogo)
    }
}

// MARK: - Constraints
private extension LogInVC {
    private func setUpConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        flowLayoutConstraint = containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        flowLayoutConstraint.isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        messengerLogo.translatesAutoresizingMaskIntoConstraints = false
        messengerLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        messengerLogo.topAnchor.constraint(equalTo: containerView.topAnchor, constant: view.bounds.height * 0.115).isActive = true
        messengerLogo.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.07).isActive = true
        messengerLogo.widthAnchor.constraint(equalToConstant: view.bounds.height * 0.07).isActive = true

        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.topAnchor.constraint(equalTo: messengerLogo.bottomAnchor, constant: view.frame.height * 0.115).isActive = true
        vStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        vStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true

        secondaryButton.bottomAnchor.constraint(equalTo: metaLogo.topAnchor, constant: -15).isActive = true
        secondaryButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        secondaryButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true

        metaLogo.translatesAutoresizingMaskIntoConstraints = false
        metaLogo.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15).isActive = true
        metaLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        metaLogo.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }
}

// MARK: - TextFieldDelegate
extension LogInVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailNumberTextField.textField {
            textField.resignFirstResponder()
            passwordTextField.textField.becomeFirstResponder()
        } else {
            // login
        }
        return true
    }
}

