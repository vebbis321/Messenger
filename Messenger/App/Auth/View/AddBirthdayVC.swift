//
//  AddDateVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/22/23.
//

import UIKit

final class AddBirthdayVC: DefaultCreateAccountVC {

    private let tappableSubText = TappableTextView()
    private let textFieldView = AuthTextField(viewModel: .init(placeholder: "", returnKey: .default, type: .Date))
    private lazy var nextBtn = AuthButton(title: "Next")

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setUpViews()
        setUpConstraints()

    }
}


// MARK: - setUpViews
private extension AddBirthdayVC {
    private func setUpViews() {

        // tappableSubText
        
        let clickText = "Why do I need to provide my date of birth?"
        tappableSubText.text = "Choose your date of birth. You can always make this private later. \(clickText)"
        tappableSubText.addTappableTexts([clickText: nil])
        tappableSubText.onTextTap = { [weak self] in
            let slideVC = CustomModalVC(customView: BirthdaysInfoView())
            slideVC.modalPresentationStyle = .custom
            self?.present(slideVC, animated: true)
            return false
        }

        // nextBtn
        nextBtn.addAction(for: .touchUpInside) { [weak self] _ in
            guard let self = self else { return }
            print(self.textFieldView.datePicker.date.localizedDescription)
            self.coordinator?.user.dateOfBirth = self.textFieldView.datePicker.date.currentTimeMillis()
            self.coordinator?.goToAddEmailVC()
        }

        view.addSubview(tappableSubText)
        view.addSubview(textFieldView)
        view.addSubview(nextBtn)

    }
}

// MARK: - setUpConstraints
private extension AddBirthdayVC {
    private func setUpConstraints() {
        tappableSubText.translatesAutoresizingMaskIntoConstraints = false
        tappableSubText.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        tappableSubText.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        tappableSubText.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        textFieldView.topAnchor.constraint(equalTo: tappableSubText.bottomAnchor, constant: 20).isActive = true
        textFieldView.pinSides(to: contentView)

        nextBtn.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 15).isActive = true
        nextBtn.pinSides(to: contentView)
    }
}


