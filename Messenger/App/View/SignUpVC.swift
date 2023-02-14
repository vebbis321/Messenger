//
//  SignUpVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/13/23.
//

import UIKit

final class SignUpVC: UIViewController {
    
    let imageView = UIImageView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        setUpConstraints()
    }
    
}

// MARK: - Views
private extension SignUpVC {
    private func setUpViews() {
        // self
        view.backgroundColor = .theme.background
        
        // MARK: - imageView
        imageView.image = UIImage(named: "Icon")
        
        view.addSubview(imageView)
    }
}

// MARK: - Constraints
private extension SignUpVC {
    private func setUpConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.bounds.height / 4).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.075).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: view.bounds.height * 0.075).isActive = true
    }
}
