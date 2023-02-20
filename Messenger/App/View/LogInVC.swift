//
//  SignUpVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/13/23.
//

import UIKit

final class LogInVC: UIViewController {

    private let messengerLogo = UIImageView(frame: .zero)

    private var vStack: UIStackView!
    private let emailNumberTextField = AuthTextFieldView(placeholder: "Mobile number or email address")
    private let passwordTextField = AuthPasswordTextFieldView(placeholder: "Password")
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
    
}

// MARK: - Actions
private extension LogInVC {
    private func setUpActions() {
        loginBtn.action = {

        }

        forgotPasswordBtn.action = {

        }

        secondaryButton.action = {
            
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

        // vStack
        vStack = .init(arrangedSubviews: [emailNumberTextField, passwordTextField, loginBtn, forgotPasswordBtn])
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.spacing = 10

        // metaLogo
        metaLogo.image = UIImage(named: "MetaLogo")?.withRenderingMode(.alwaysTemplate)
        metaLogo.contentMode = .scaleAspectFit
        metaLogo.tintColor = .theme.metaLogo

        view.addSubview(messengerLogo)
        view.addSubview(vStack)
        view.addSubview(secondaryButton)
        view.addSubview(metaLogo)
    }
}

// MARK: - Constraints
private extension LogInVC {
    private func setUpConstraints() {
        messengerLogo.translatesAutoresizingMaskIntoConstraints = false
        
        messengerLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        messengerLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height * 0.115).isActive = true
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
        metaLogo.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        metaLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        metaLogo.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }
}



