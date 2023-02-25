//
//  CustomSheetVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/23/23.
//

import UIKit

final class CustomSheetVC: UIViewController {

    private let containerView = UIView(frame: .zero)
    private let handler = SheetHandlerView()
    private let xmarkBtn = CustomIconBtn(icon: "xmark")
    private let titleLabel = UILabel(frame: .zero)
    private let linkTextView = TappableTextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
}

// MARK: - Views
private extension CustomSheetVC {
    private func setUpViews() {
        // self
        view.backgroundColor = .black.withAlphaComponent(0.25)

        // containerView
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true

        // titleLabel
        titleLabel.text = "Birthdays"
        titleLabel.textColor = .theme.tintColor
        titleLabel.font = .systemFont(ofSize: 25, weight: .bold)
        titleLabel.numberOfLines = 0

        // linkTextView
        let linkText = "Learn more about how we use your info in our Privacy Policy"
        linkTextView.text = "Providing your date of birth improves the features and ads that you see and helps to keep the Facebook community safe. You can find your date of birth in your personal infromation account settings. \(linkText)"
        linkTextView.addTappableTexts([linkText: "https://www.facebook.com/privacy/policy/"])

        view.addSubview(containerView)
        containerView.addSubview(handler)
        containerView.addSubview(xmarkBtn)
        containerView.addSubview(titleLabel)
        containerView.addSubview(linkTextView)

    }
}

// MARK: - Constraints
private extension CustomSheetVC {
    private func setUpConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.25).isActive = true
        containerView.pinSides(to: view)
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        handler.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5).isActive = true
        handler.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true

        xmarkBtn.topAnchor.constraint(equalTo: handler.bottomAnchor, constant: 10).isActive = true
        xmarkBtn.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20).isActive = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: xmarkBtn.bottomAnchor, constant: 20).isActive = true
        titleLabel.pinSides(to: containerView, padding: 20)

        linkTextView.translatesAutoresizingMaskIntoConstraints = false
        linkTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        linkTextView.pinSides(to: containerView, padding: 20)

    }
}
