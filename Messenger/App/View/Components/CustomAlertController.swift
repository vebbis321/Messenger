//
//  CustomAlertController.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/21/23.
//

import UIKit

struct AlertButtons {
    var font: UIFont
    var title: String
    var action: (()->())
}

final class CustomAlertController: UIViewController {

    private var alertTitle: String
    private var alertButtons: [AlertButtons]
    private let vStack = UIStackView(frame: .zero)


    init(alertTitle: String, alertButtons: [AlertButtons]) {
        self.alertTitle = alertTitle
        self.alertButtons = alertButtons
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.7)

        vStack.axis = .vertical

        alertButtons.forEach { btn in
            let uiBtn = UIButton(type: .custom)
            uiBtn.titleLabel?.font = btn.font
            uiBtn.setTitle(btn.title, for: .normal)
            uiBtn.setTitleColor(.theme.hyperlink, for: .normal)
            let action = UIAction { _ in
                btn.action()
            }
            uiBtn.addAction(action, for: .touchUpInside)

            vStack.addArrangedSubview(uiBtn)
        }

        view.addSubview(vStack)

        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
}
