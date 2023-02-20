//
//  CustomTextField.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/13/23.
//

import UIKit
import Combine

class AuthTextFieldView: UIView {

    let textField = UITextField(frame: .zero)
    let iconBtn: CustomIconBtn
    let floatingLabel = UILabel(frame: .zero)

    private var placeHolder: String
    private var keyboard: UIKeyboardType
    private var returnKey: UIReturnKeyType

    init(frame: CGRect = .zero, placeholder: String, icon: String, keyboard: UIKeyboardType = .default, returnKey: UIReturnKeyType) {
        self.placeHolder = placeholder
        self.keyboard = keyboard
        self.returnKey = returnKey
        self.iconBtn = .init(icon: icon)
        super.init(frame: frame)
    
        setUpViews()
        setUpConstraints()
      
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: -Views
private extension AuthTextFieldView {
    private func setUpViews() {
        // self
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.theme.border?.cgColor
        layer.masksToBounds = true
        layer.cornerRadius = 3

        // textField
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.keyboardType = keyboard
        textField.returnKeyType = returnKey

        // floatingLabel / placeholder
        floatingLabel.text = placeHolder
        floatingLabel.font = .systemFont(ofSize: 17, weight: .regular)
        floatingLabel.textColor = .theme.placeholder

        // iconBtn
        iconBtn.isHidden = true

        addSubview(textField)
        addSubview(floatingLabel)
        addSubview(iconBtn)
    }
}

// MARK: - Constrains
private extension AuthTextFieldView {
    private func setUpConstraints() {
        let padding: CGFloat = 15

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
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: textField.topAnchor, constant: -20).isActive = true
        bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20).isActive = true

    }
}


// MARK: - Preview
//import SwiftUI
//
//final class TestVC: UIViewController {
//    let textFieldView = AuthTextFieldClearView(placeholder: "Mobile number or email address")
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .theme.background
//        view.addSubview(textFieldView)
//
//
//        textFieldView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
//        textFieldView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
//    }
//}
//
//struct TestVCPreview: PreviewProvider {
//    static var previews: some View {
//        UIViewControllerPreview {
//            TestVC()
//        }
//        .previewDevice("iPhone 12 mini")
//    }
//}
