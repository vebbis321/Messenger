//
//  DefaultCreateAccountVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/21/23.
//

import UIKit

class DefaultCreateAccountVC: UIViewController {

    weak var coordinator: CreateAccountCoordinator?

    let contentView = UIView(frame: .zero)
    let scrollView = UIScrollView(frame: .zero)

    private let titleLabel = UILabel(frame: .zero)
    private let alreadyHaveAnAccountBtn = UIButton(type: .custom)

    init(titleStr: String) {
        self.titleLabel.text = titleStr
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        setUpConstraints()
    }

    @objc func alreadyHaveAnAccountTapped() {

        let alert = CustomAlertController(
            alertTitle: "Already have an acoount?",
            alertButtons: [
                .init(font: .systemFont(ofSize: 17, weight: .bold), title: "Log in", action: { [weak self] in
                    self?.dismiss(animated: true, completion: { [weak self] in
                        self?.coordinator?.rootViewController.popToRootViewController(animated: true)
                    })

                }),
                .init(font: .systemFont(ofSize: 17, weight: .regular), title: "Continue creating account", action: { [weak self] in
                    self?.dismiss(animated: true)
                })
            ]
        )
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        present(alert, animated: true, completion: nil)

    }
}

// MARK: - setUpViews
private extension DefaultCreateAccountVC {
    private func setUpViews() {
        // self
        // hide "back" from back button
        navigationController?.navigationBar.topItem?.backBarButtonItem = .init(title: "", style: .plain, target: nil, action: nil)
        view.backgroundColor = .theme.background

        // contentView
        scrollView.delaysContentTouches = true

        // titleLabel
        titleLabel.textColor = .theme.tintColor
        titleLabel.font = .systemFont(ofSize: 25, weight: .bold)
        titleLabel.numberOfLines = 0

        // alreadyHaveAnAccountBtn
        alreadyHaveAnAccountBtn.setTitle("Already have an account?", for: .normal)
        alreadyHaveAnAccountBtn.setTitleColor(.theme.hyperlink, for: .normal)
        alreadyHaveAnAccountBtn.titleLabel?.textAlignment = .center
        alreadyHaveAnAccountBtn.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        alreadyHaveAnAccountBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.01, bottom: 0.01, right: 0) // remove padding
        alreadyHaveAnAccountBtn.addTarget(self, action: #selector(alreadyHaveAnAccountTapped), for: .touchUpInside)

        view.addSubview(scrollView)
        view.addSubview(alreadyHaveAnAccountBtn)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(contentView)
    }
}

// MARK: - Constraints
private extension DefaultCreateAccountVC {
    private func setUpConstraints() {
        // btn
        alreadyHaveAnAccountBtn.translatesAutoresizingMaskIntoConstraints = false
        alreadyHaveAnAccountBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alreadyHaveAnAccountBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true

        // scrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: alreadyHaveAnAccountBtn.topAnchor, constant: -10).isActive = true

        // title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -20).isActive = true

        // contentView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40).isActive = true
        contentView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
}
