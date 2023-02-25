//
//  CustomSheetVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/23/23.
//

import UIKit

final class BirthdaysInfoView: UIView {


    private let xmarkBtn = CustomIconBtn(icon: "xmark")
    private let titleLabel = UILabel(frame: .zero)
    private let linkTextView = TappableTextView()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Views
private extension BirthdaysInfoView {
    private func setUpViews() {
        // self
        backgroundColor = .systemBackground

        // titleLabel
        titleLabel.text = "Birthdays"
        titleLabel.textColor = .theme.tintColor
        titleLabel.font = .systemFont(ofSize: 25, weight: .bold)
        titleLabel.numberOfLines = 0

        // linkTextView
        let linkText = "Learn more about how we use your info in our Privacy Policy"
        linkTextView.text = "Providing your date of birth improves the features and ads that you see and helps to keep the Facebook community safe. You can find your date of birth in your personal infromation account settings. \(linkText)"
        linkTextView.addTappableTexts([linkText: "https://www.facebook.com/privacy/policy/"])

        addSubview(xmarkBtn)
        addSubview(titleLabel)
        addSubview(linkTextView)

    }
}

// MARK: - Constraints
private extension BirthdaysInfoView {
    private func setUpConstraints() {
        xmarkBtn.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        xmarkBtn.leftAnchor.constraint(equalTo: leftAnchor).isActive = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: xmarkBtn.bottomAnchor, constant: 20).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

        linkTextView.translatesAutoresizingMaskIntoConstraints = false
        linkTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        linkTextView.pinSides(to: self)

    }
}
