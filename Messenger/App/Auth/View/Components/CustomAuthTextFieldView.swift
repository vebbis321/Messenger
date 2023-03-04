//
//  CustomAuthTextFieldView.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 3/3/23.
//

import UIKit
import Combine

extension UITextField {
    func applyCustomClearButton() {
        clearButtonMode = .never
        rightViewMode   = .whileEditing

        let padding: CGFloat = 15

        let clearButton = UIButton(frame: .init(x: padding, y: 0, width: 17, height: 17))
        clearButton.setImage(UIImage(systemName: "xmark")?.withTintColor(.theme.tintColor ?? .label, renderingMode: .alwaysOriginal), for: .normal)

        clearButton.addAction(for: .touchUpInside) { [weak self] action in
            self?.text = ""
        }

        let view = UIView(frame: CGRect(x: 0, y: 0, width: padding + 17, height: 17))
        view.addSubview(clearButton)

        rightView = view
    }

    func applyShowHidePasswordBtn() {
        clearButtonMode = .never
        rightViewMode   = .whileEditing

        let padding: CGFloat = 15

        let btn = UIButton(frame: .init(x: padding, y: 0, width: 20, height: 20))
        btn.setImage(UIImage(systemName: "eye.slash")?.withTintColor(.theme.tintColor ?? .label, renderingMode: .alwaysOriginal), for: .normal)

        btn.addAction(for: .touchUpInside) { [weak self] action in
            guard let self = self else { return }
            self.togglePasswordVisibility()
            btn.setImage(
                UIImage(systemName: self.isSecureTextEntry ? "eye.slash" : "eye")?.withTintColor(.theme.tintColor ?? .label, renderingMode: .alwaysOriginal), for: .normal)
        }

        let view = UIView(frame: CGRect(x: 0, y: 0, width: padding + 20, height: 20))
        view.addSubview(btn)

        rightView = view
    }

    func applyErrorImage() {
        clearButtonMode = .never
        rightViewMode   = .always

        let padding: CGFloat = 15

        let image = UIImageView(frame: .init(x: padding, y: 0, width: 17, height: 17))
        image.image =  UIImage(systemName: "exclamationmark.circle")?.withTintColor(.red, renderingMode: .alwaysOriginal)

        let view = UIView(frame: CGRect(x: 0, y: 0, width: padding + 20, height: 17))
        view.addSubview(image)

        rightView = view
    }

}

class CustomAuthTextFieldView: UIView {

    struct ViewModel {
        enum TextFieldType {
            case Default
            case Password
            case Date

            var isSecure: Bool {
                self == .Password ? true : false
            }

            var floatingLabelColor: UIColor? {
                switch self {
                case .Default:
                    return .theme.placeholder
                case .Password:
                    return .theme.placeholder
                case .Date:
                    return .theme.floatingLabel
                }
            }

            var textColor: UIColor? {
                switch self {
                case .Default:
                    return .label
                case .Password:
                    return .label
                case .Date:
                    return .clear
                }
            }
        }

        enum State {
            case normal
            case error

            var floatingLabelColor: UIColor? {
                switch self {
                case .normal:
                    return .theme.floatingLabel
                case .error:
                    return .red
                }
            }

            var borderColor: CGColor? {
                switch self {
                case .normal:
                    return UIColor.theme.border?.cgColor
                case .error:
                    return UIColor.red.cgColor
                }
            }
        }

        /// The placeholder text.
        let placeholder: String
        let keyboard: UIKeyboardType = .default
        let returnKey: UIReturnKeyType
        let textContentType: UITextContentType? = nil
        let type: TextFieldType
    }

    lazy var textField: UITextField = {
        var txtField: UITextField!
        if self.viewModel.type == .Date {
            txtField = DateTextField()
        } else {
            txtField = UITextField()
        }
        txtField.font = .systemFont(ofSize: 17, weight: .regular)
        return txtField
    }()

    private func setUpSelf() {
        backgroundColor = .white
        layer.borderWidth = 1
        layer.masksToBounds = true
        layer.cornerRadius = 3
        layer.borderColor = UIColor.theme.border?.cgColor
    }

    private func customSetupConfigs() {
        textField.keyboardType = viewModel.keyboard
        textField.returnKeyType = viewModel.returnKey
        textField.textContentType = viewModel.textContentType
        floatingLabel.text = viewModel.placeholder

        floatingLabel.textColor = viewModel.type.textColor
        textField.textColor = viewModel.type.textColor
        textField.isSecureTextEntry = viewModel.type.isSecure
    }

    private func addRightView() {
        switch viewModel.type {
        case .Default:
            return textField.applyCustomClearButton()
        case .Password:
            return textField.applyShowHidePasswordBtn()
        case .Date:
            break
        }
    }

    var state: ViewModel.State? {
        didSet {
            guard let state = state else {
                return
            }
            floatingLabel.textColor = state.floatingLabelColor
            layer.borderColor = state.borderColor
        }
    }

    private var viewModel: ViewModel
    private let floatingLabel = UILabel(frame: .zero)


    init(frame: CGRect = .zero, viewModel: ViewModel) {

        self.viewModel = viewModel

        super.init(frame: frame)
        setUpViews()
        setUpConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CustomAuthTextFieldView {
    private func setUpViews() {
        setUpSelf()
        customSetupConfigs()
        addRightView()
        addSubview(textField)
        addSubview(floatingLabel)
    }
}


// MARK: - Constrains
private extension CustomAuthTextFieldView {
    private func setUpConstraints() {
        let padding: CGFloat = 15

        // textField
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textField.pinSides(to: self, padding: padding)

        // floatingLabel
        floatingLabel.translatesAutoresizingMaskIntoConstraints = false
        floatingLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        floatingLabel.pinSides(to: self, padding: padding)

        // self
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: textField.topAnchor, constant: -20).isActive = true
        bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20).isActive = true

    }
}

final class TextfieldVC: UIViewController {
    let txtField = CustomAuthTextFieldView(
        viewModel: .init(
            placeholder: "Clear",
            returnKey: .default, type: .Default))
    let txtField2 = CustomAuthTextFieldView(
        viewModel: .init(
            placeholder: "Password",
            returnKey: .default, type: .Password))
    let txtField3 = CustomAuthTextFieldView(
        viewModel: .init(
            placeholder: "Date",
            returnKey: .default, type: .Date))

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .theme.background

        view.addSubview(txtField)
        view.addSubview(txtField2)
        view.addSubview(txtField3)

        txtField.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        txtField.pinSides(to: view, padding: 20)

        txtField2.topAnchor.constraint(equalTo: txtField.bottomAnchor, constant: 10).isActive = true
        txtField2.pinSides(to: view, padding: 20)

        txtField3.topAnchor.constraint(equalTo: txtField2.bottomAnchor, constant: 10).isActive = true
        txtField3.pinSides(to: view, padding: 20)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        txtField.state = .error
    }
}


import SwiftUI

struct TxtFieldVCPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            TextfieldVC()
        }
        .previewDevice("iPhone 12 mini")
    }
}
