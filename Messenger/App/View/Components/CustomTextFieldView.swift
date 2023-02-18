//
//  CustomTextField.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/13/23.
//

import UIKit
import Combine

class CustomTextFieldView: UIView {
    private var subscriptions = Set<AnyCancellable>()

    let textField = UITextField(frame: .zero)
    private let floatingLabel = UILabel(frame: .zero)
    private let iconBtn = CustomIconBtn(icon: "xmark")
    private var placeHolder: String
    private var keyboard: UIKeyboardType

    required init(frame: CGRect = .zero, placeholder: String, keyboard: UIKeyboardType = .default) {
        self.placeHolder = placeholder
        self.keyboard = keyboard
        super.init(frame: frame)
    
        setUpViews()
        setUpConstraints()
        setUpBindings()
        setUpActions()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func handleTextFieldBecameActive() {

        layer.borderColor = UIColor.theme.activeBorder?.cgColor
        floatingLabel.transform = .init(translationX: 0, y: -(textField.intrinsicContentSize.height * 0.45))
        floatingLabel.textColor = .theme.floatingLabel
        floatingLabel.font = .systemFont(ofSize: 12, weight: .regular)

        textField.transform = .init(translationX: 0, y: 7.5)

        if !(textField.text?.isEmpty ?? true) {
            iconBtn.isHidden = false
        }


    }

    func handleTextFieldBecameInactive() {

        layer.borderColor = UIColor.theme.border?.cgColor
        iconBtn.isHidden = true

        if textField.text?.isEmpty ?? true {
            floatingLabel.transform = .identity
            floatingLabel.textColor = .theme.placeholder
            floatingLabel.font = .systemFont(ofSize: 15, weight: .regular)

            textField.transform = .identity
        }

    }

    func handleTextFieldBecameNonEmpty() {
        iconBtn.isHidden = false
    }

    func handleTextFieldBecameEmpty() {
        iconBtn.isHidden = true
    }

    func setUpActions() {
        iconBtn.action = { [weak self] in
            self?.textField.text = ""
            NotificationCenter.default.post(
                name:UITextField.textDidChangeNotification, object: self?.textField)

        }
    }
}

// MARK: - setUpBindings
private extension CustomTextFieldView {
    private func setUpBindings() {
        Publishers.Merge(textField.textBecameActivePublisher(), textField.textBecameInActivePublisher())
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isActive in
                isActive ? self?.handleTextFieldBecameActive() : self?.handleTextFieldBecameInactive()
            }.store(in: &subscriptions)

        textField.textIsEmptyPublisher()
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isTextEmpty in
                isTextEmpty ? self?.handleTextFieldBecameEmpty() : self?.handleTextFieldBecameNonEmpty()
            }.store(in: &subscriptions)
    }
}

// MARK: - actions
extension CustomTextFieldView {

}

// MARK: - setUpViews
private extension CustomTextFieldView {
    private func setUpViews() {
        // self
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.theme.border?.cgColor
        layer.masksToBounds = true
        layer.cornerRadius = 3

        // textField
        textField.font = .systemFont(ofSize: 15, weight: .light)
        textField.keyboardType = keyboard

        // floatingLabel / placeholder
        floatingLabel.text = placeHolder
        floatingLabel.font = .systemFont(ofSize: 15, weight: .regular)
        floatingLabel.textColor = .theme.placeholder

        // iconBtn
        iconBtn.isHidden = true

        addSubview(textField)
        addSubview(floatingLabel)
        addSubview(iconBtn)
    }
}

// MARK: - setUpConstraints
private extension CustomTextFieldView {
    private func setUpConstraints() {
        let padding: CGFloat = 15

        // self
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: widthAnchor).isActive = true

        // iconBtn
        iconBtn.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding).isActive = true
        iconBtn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        // textField
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textField.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        textField.rightAnchor.constraint(equalTo: iconBtn.leftAnchor, constant: -padding).isActive = true

        // floatingLabel
        floatingLabel.translatesAutoresizingMaskIntoConstraints = false
        floatingLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        floatingLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        floatingLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding).isActive = true

        // self
        topAnchor.constraint(equalTo: textField.topAnchor, constant: -20).isActive = true
        bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20).isActive = true

    }
}



// MARK: - Preview
import SwiftUI

final class TestVC: UIViewController {
    let textFieldView = CustomTextFieldView(placeholder: "Mobile number or email address")
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        view.addSubview(textFieldView)


        textFieldView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        textFieldView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
    }
}

struct TestVCPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            TestVC()
        }
        .previewDevice("iPhone 12 mini")
    }
}
