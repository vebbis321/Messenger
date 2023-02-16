//
//  SignUpVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/13/23.
//

import UIKit

final class SignUpVC: UIViewController {
    
    let imageView = UIImageView(frame: .zero)
    let emailNumberTextField = CustomTextFieldView(placeholder: "Mobile number or email address")
    let passwordTextField = PasswordTextFieldView(placeholder: "Password")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setUpViews()
        setUpConstraints()
    }
    
}

// MARK: - Views
private extension SignUpVC {
    private func setUpViews() {
        // self
        view.backgroundColor = .theme.background
        
        // imageView
        imageView.image = UIImage(named: "Icon")
        
        view.addSubview(imageView)
        view.addSubview(emailNumberTextField)
    }
}

// MARK: - Constraints
private extension SignUpVC {
    private func setUpConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.25).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.075).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: view.bounds.height * 0.075).isActive = true

        emailNumberTextField.centerYAnchor.constraint(equalTo: imageView.topAnchor, constant: view.frame.height * 0.25).isActive = true
        emailNumberTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        emailNumberTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
    }

}



