//
//  SignUpVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/13/23.
//

import UIKit
import Combine

final class LogInVC: UIViewController {

    weak var coordinator: LogInCoordinator?

    private let containerView = UIView(frame: .zero)

    private var keyboardPublisher: AnyCancellable?
    private var flowLayoutConstraint: NSLayoutConstraint!

    private let messengerLogo = UIImageView(frame: .zero)

    private var vStack: UIStackView!
    private let emailNumberTextField = AuthTextField(viewModel: .init(placeholder: "Mobile number or email address", returnKey: .continue, type: .Default(.Email)))
    private let passwordTextField = AuthTextField(viewModel: .init(placeholder: "Password", returnKey: .done, type: .Password))
    private lazy var loginBtn = AuthButton(title: "Log In")
    private lazy var forgotPasswordBtn: UIButton = .createTextButton(with: "Forgotten Password?")
    private lazy var secondaryButton: UIButton = .createSecondaryButton(with: "Create new account")
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
        loginBtn.addAction(for: .touchUpInside)  { _ in 

        }

        forgotPasswordBtn.addAction(for: .touchUpInside) { action in

        }

        secondaryButton.addAction(for: .touchUpInside) { [weak self] action in
            self?.coordinator?.startCreateAccountCoordinator()
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
        emailNumberTextField.delegate = self
        passwordTextField.delegate = self

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
        let padding: CGFloat = 20

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
        vStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding).isActive = true
        vStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding).isActive = true

        secondaryButton.bottomAnchor.constraint(equalTo: metaLogo.topAnchor, constant: -15).isActive = true
        secondaryButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding).isActive = true
        secondaryButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding).isActive = true

        metaLogo.translatesAutoresizingMaskIntoConstraints = false
        metaLogo.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15).isActive = true
        metaLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        metaLogo.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }
}

// MARK: - TextFieldDelegate
extension LogInVC: TextFieldDelegate {
    func textFieldShouldReturn(_ textField: CustomTextField) -> Bool {
        if textField == emailNumberTextField {
            textField.textField.resignFirstResponder()
            passwordTextField.textField.becomeFirstResponder()
        } else {
            // login
        }
        return true
    }
}

