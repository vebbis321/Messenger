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

    private var titleLabel = PaddingLabel(withInsets: 8, 8, 0, 0)
    private let vStack = UIStackView(frame: .zero)
    private var alertButtons: [AlertButtons]

    init(alertTitle: String, alertButtons: [AlertButtons]) {
        self.titleLabel.text = alertTitle
        self.alertButtons = alertButtons
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

    deinit {
        print("✅ Deinit CustomAlertController")
    }
}

private extension CustomAlertController {
    private func setUpViews() {
        // self
        view.backgroundColor = .black.withAlphaComponent(0.25)

        // titleLabel
        titleLabel.textColor = .theme.tintColor
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)

        // vStack
        vStack.axis = .vertical
        vStack.spacing = 10
        vStack.customize(backgroundColor: .tertiarySystemGroupedBackground, cornerRadius: 12)
        vStack.layoutMargins = UIEdgeInsets(top: 13, left: 0, bottom: 13, right: 0)
        vStack.isLayoutMarginsRelativeArrangement = true
        vStack.addArrangedSubview(titleLabel)

        // alertBtns
        alertButtons.forEach { btn in
            let uiBtn = UIButton(type: .custom)
            uiBtn.titleLabel?.font = btn.font
            uiBtn.setTitle(btn.title, for: .normal)
            uiBtn.setTitleColor(.theme.alertText, for: .normal)
            uiBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 35, bottom: 0.01, right: 35)
            uiBtn.addAction(for: .touchUpInside) { action in
                btn.action()
            }
            uiBtn.translatesAutoresizingMaskIntoConstraints = false

            vStack.addArrangedSubview(uiBtn)
        }

        // seperators
        vStack.addHorizontalSeparators(color: .theme.sepearator ?? .gray)

        view.addSubview(vStack)
    }
}

private extension CustomAlertController {
    private func setUpConstraints() {
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
