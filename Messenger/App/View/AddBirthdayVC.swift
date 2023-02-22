//
//  AddDateVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/22/23.
//

import UIKit

final class AddBirthdayVC: DefaultCreateAccountVC {

    private let subLinkTextView = SubLinkTextView()
    private let textFieldView = AuthDateTextFieldView()
    private let datePicker = UIDatePicker()
    private let nextBtn = AuthButton(title: "Next")

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setUpViews()
        setUpConstraints()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDate()
    }
}

// MARK: - Action
extension AddBirthdayVC {
    @objc func handleDateChanged() {
        updateDate()
    }

    func updateDate() {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        textFieldView.textField.text = formatter.string(from: datePicker.date)
        let age = Calendar.current.dateComponents([.year], from: datePicker.date, to: Date())
        textFieldView.floatingLabel.text = "Date of birth (\(age.year ?? 0) year old)"
    }
}

// MARK: - UITextFieldDelegate
extension AddBirthdayVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
           if textField.tag == 1 {
               textField.text = ""
               return false
           }
           return true
       }
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           if textField.tag == 1 {
               textField.text = ""
               return false
           }
           return true
       }
}

// MARK: - setUpViews
private extension AddBirthdayVC {
    private func setUpViews() {
        let clickText =  "Why do I need to provide my date of birth?"
        subLinkTextView.text = "Choose your date of birth. You can always make this private later. \(clickText)"
        subLinkTextView.addLinks([clickText: ""])
        subLinkTextView.onLinkTap = { _ in
            print("tapped")
            return true
        }

        datePicker.preferredDatePickerStyle = .wheels
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(handleDateChanged), for: .valueChanged)

        textFieldView.textField.inputView = datePicker
        textFieldView.textField.delegate = self

        view.addSubview(subLinkTextView)
        view.addSubview(textFieldView)
        view.addSubview(nextBtn)

    }
}

// MARK: - setUpConstraints
private extension AddBirthdayVC {
    private func setUpConstraints() {
        subLinkTextView.translatesAutoresizingMaskIntoConstraints = false
        subLinkTextView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        subLinkTextView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        subLinkTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        textFieldView.topAnchor.constraint(equalTo: subLinkTextView.bottomAnchor, constant: 20).isActive = true
        textFieldView.pinSides(to: contentView)

        nextBtn.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 15).isActive = true
        nextBtn.pinSides(to: contentView)
    }
}


