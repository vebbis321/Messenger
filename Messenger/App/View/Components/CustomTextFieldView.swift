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

    private var placeHolder: String
    private var keyboard: UIKeyboardType

    required init(frame: CGRect = .zero, placeholder: String, keyboard: UIKeyboardType = .default) {
        self.placeHolder = placeholder
        self.keyboard = keyboard
        super.init(frame: frame)

        setUpViews()
        setUpConstraints()
        setUpBindings()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func handleTextFieldBecameActive() {
        layer.borderColor = UIColor.black.cgColor

        floatingLabel.transform = .init(scaleX: 0.3, y: 0.3)
        floatingLabel.transform = .init(translationX: 0, y: -textField.intrinsicContentSize.height / 2)
        floatingLabel.textColor = .theme.floatingLabel
        floatingLabel.font = .systemFont(ofSize: 12, weight: .regular)
        textField.transform = .init(translationX: 0, y: 7.5)
        layoutIfNeeded()
    }

    func handleTextFieldBecameInactive() {
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        if textField.text?.isEmpty ?? true {
            floatingLabel.transform = .init(scaleX: 1, y: 1)
            floatingLabel.transform = .identity
            floatingLabel.textColor = .theme.placeholder
            floatingLabel.font = .systemFont(ofSize: 15, weight: .regular)
            textField.transform = .identity
        }
    }

    func handleTextFieldBecameNonEmpty() {

    }

    func handleTextFieldBecameEmpty() {


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
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        layer.masksToBounds = true
        layer.cornerRadius = 3

        // textField
        textField.font = .systemFont(ofSize: 15, weight: .regular)
        textField.keyboardType = keyboard

        // floatingLabel / placeholder
        floatingLabel.text = placeHolder
        floatingLabel.font = .systemFont(ofSize: 15, weight: .regular)
        floatingLabel.textColor = .theme.placeholder

        addSubview(textField)
        addSubview(floatingLabel)
    }
}

// MARK: - setUpConstraints
private extension CustomTextFieldView {
    private func setUpConstraints() {
        let padding: CGFloat = 15

        // self
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: widthAnchor).isActive = true

        // textField
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textField.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor, constant: padding).isActive = true

        floatingLabel.translatesAutoresizingMaskIntoConstraints = false
        floatingLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        floatingLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        floatingLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: padding).isActive = true

        topAnchor.constraint(equalTo: textField.topAnchor, constant: -20).isActive = true
        bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20).isActive = true

        print("textfield \(textField.intrinsicContentSize.height)")
        print("floatingLabel \(floatingLabel.intrinsicContentSize.height)")
        print("self \(intrinsicContentSize.height)")

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
        .previewDevice("iPhone 14 Pro")
    }
}
