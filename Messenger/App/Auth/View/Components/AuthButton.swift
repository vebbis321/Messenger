//
//  AuthButton.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/19/23.
//

import UIKit

final class AuthButton: UIButton {

    var action: (()->())?

//    private lazy var activityIndicator: UIActivityIndicatorView = {
//        let activity = UIActivityIndicatorView(style: .medium)
//        activity.hidesWhenStopped = true
//        activity.color = .theme.buttonText
//        return activity
//    }()

    private lazy var spinner = SpinnerView(colors: [.white], lineWidth: 2)

    private var title: String

    init(frame: CGRect = .zero, title: String) {
        self.title = title
        super.init(frame: frame)

        setUpViews()
        setUpConstraints()
    }

    var isLoading = false {
        didSet {
            updateView()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateView() {
        if isLoading {
            spinner.isAnimating = true
            titleLabel?.alpha = 0
            imageView?.alpha = 0
            // to prevent multiple click while in process
            isEnabled = false
        } else {
            spinner.isAnimating = false
            titleLabel?.alpha = 1
            imageView?.alpha = 0
            isEnabled = true
        }
      }

    
}
// MARK: - btnTapped
private extension AuthButton {
    @objc func btnTapped(sender: UIControl) {
        action?()
    }
}


// MARK: - Views
private extension AuthButton {
    private func setUpViews() {
        // self
        backgroundColor = .theme.button
        setTitleColor(.theme.buttonText, for: .normal)
        setTitleColor(.theme.buttonText, for: .highlighted)
        layer.cornerRadius = 3
        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        addTarget(self, action: #selector(btnTapped), for: .touchUpInside)

        // activityIndicator
        addSubview(spinner)
    }
}

// MARK: - Constraints
private extension AuthButton {
    private func setUpConstraints() {
        guard let titleLabel = titleLabel else { return }

        // self
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -15).isActive = true
        bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true

        // activityIndicator
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.heightAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height).isActive = true
        spinner.widthAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height).isActive = true
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
