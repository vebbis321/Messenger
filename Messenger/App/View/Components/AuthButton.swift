//
//  AuthButton.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/19/23.
//

import UIKit

final class AuthButton: UIButton {

    var action: (()->())?

    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium)

    private var title: String
    init(frame: CGRect = .zero, title: String) {
        self.title = title
        super.init(frame: frame)

        setUpViews()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showLoading() {
        setTitle("", for: .normal)
        activityIndicator.startAnimating()

    }

    func hideLoading() {
        setTitle(title, for: .normal)
        activityIndicator.stopAnimating()
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
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .theme.buttonText

        addSubview(activityIndicator)
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
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
