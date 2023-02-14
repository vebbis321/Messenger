//
//  CustomTextField.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/13/23.
//

import UIKit

final class CustomTextFieldView: UIView {
    let textField = UITextField(frame: .zero)
    private let floatingLabel = UILabel(frame: .zero)

    var placeHolder: String

    init(frame: CGRect = .zero, placeHolder: String) {
        self.placeHolder = placeHolder
        super.init(frame: frame)

        setUpViews()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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

        // floatingLabel / placeholder
        floatingLabel.text = placeHolder
        floatingLabel.font = .systemFont(ofSize: 18, weight: .regular)
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


    }
}



// MARK: - Preview
import SwiftUI

final class TestVC: UIViewController {
    let textFieldView = CustomTextFieldView(placeHolder: "Mobile number or email address")
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
