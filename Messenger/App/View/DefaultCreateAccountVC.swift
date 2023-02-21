//
//  DefaultCreateAccountVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/21/23.
//

import UIKit

class DefaultCreateAccountVC: UIViewController {

    weak var coordinator: CreateAccountCoordinator?


    init(titleStr: String) {
        self.titleLabel.text = titleStr
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .theme.tintColor
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()

    let alreadyHaveAnAccountBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Already have an account?", for: .normal)
        btn.setTitleColor(.theme.hyperlink, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.01, bottom: 0.01, right: 0) // remove padding
        return btn
    }()

    @objc func alreadyHaveAnAccountTapped() {
        coordinator?.rootViewController.popToRootViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // hide "back" from back button
        navigationController?.navigationBar.topItem?.backBarButtonItem = .init(title: "", style: .plain, target: nil, action: nil)

        // background
        view.backgroundColor = .theme.background

        alreadyHaveAnAccountBtn.addTarget(self, action: #selector(alreadyHaveAnAccountTapped), for: .touchUpInside)
        view.addSubview(titleLabel)
        view.addSubview(alreadyHaveAnAccountBtn)

        // title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true

        // btn
        alreadyHaveAnAccountBtn.translatesAutoresizingMaskIntoConstraints = false
        alreadyHaveAnAccountBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alreadyHaveAnAccountBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true


    }
}
