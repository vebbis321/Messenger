//
//  CustomAuthTextFieldView.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 3/3/23.
//

import UIKit
import Combine


class CustomAuthTextFieldView: UIView {

    // MARK: - Components
    private var textField: UITextField!

    private lazy var floatingLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()

    private lazy var rightViewButton: UIButton? = nil
    private lazy var errorRightView = UIButton.createIconButton(icon: "exclamationmark.circle", size: 17, weight: .regular)

    // MARK: - Properties
    private var viewModel: ViewModel
    private let padding: CGFloat = 15
    private var txtFieldRightAnchorConstraint: NSLayoutConstraint!

    // MARK: - Public TextField State
    public var errorState: ErrorState? {
        didSet {
            evaluateErrorState()
            evaluateButtonState()
        }
    }

    // MARK: - Private TextField States
    private var focusState: FocusState = .inactive {
        didSet {
            evaluateTextFocusState()
            evaluateButtonState()
        }
    }

    private var textState: TextState = .isEmpty {
        didSet {
            guard viewModel.type != .Date else { return }
            evaluateTextState()
            evaluateButtonState()
        }
    }


    // MARK: - Private Methods
    private func evaluateTextState() {
        // so we don't set the properties of textField if its already set
        guard textField.transform != textState.textFieldScale else { return }
        floatingLabel.transform = textState == .isEmpty ? .identity : .init(translationX: 0, y: -(textField.intrinsicContentSize.height * 0.45))
        floatingLabel.font = textState.floatingLabelFont
        textField.transform = textState.textFieldScale
        floatingLabel.textColor = textState.floatingLabelColor

        guard errorState != .error else { return }
        floatingLabel.textColor = textState.floatingLabelColor
    }

    private func evaluateTextFocusState() {
        guard errorState != .error else { return }
        layer.borderColor = focusState.borderColor
    }

    private func evaluateErrorState() {
        switch errorState {
        case .none:
            floatingLabel.textColor = textState.floatingLabelColor
            layer.borderColor = focusState.borderColor
            rightViewButton?.updateIcon(newIcon: "xmark", newColor: .theme.tintColor, newSize: 17)

        case .some(let state):
            floatingLabel.textColor = state.floatingLabelColor
            layer.borderColor = state.borderColor

        }

    }

    private func evaluateButtonState() {
        guard let rightViewButton = rightViewButton else { return }
        switch viewModel.type {
        case .Default:
            switch textState {
            case .isEmpty:
                if errorState != nil {
                    rightViewButton.updateIcon(newIcon: "exclamationmark.circle", newColor: .red, newSize: 20)
                    rightViewButton.isHidden = false
                } else {
                    rightViewButton.isHidden = true
                }

            case .text:
                rightViewButton.isHidden = false
                guard errorState != nil else { return }
                rightViewButton.updateIcon(newIcon: "xmark", newColor: .theme.tintColor, newSize: 17)
            }
        case .Password:
            switch focusState {
            case .active:
                rightViewButton.isHidden = false
            case .inactive:
                rightViewButton.isHidden = true
            }
        case .Date: break
        }
    }


    // MARK: - Actions
    @objc private func handleTap() {
        textField.becomeFirstResponder()
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        textState = textField.hasText ? .text : .isEmpty
    }

    private func clearBtnTapped() {
        textField.text = ""
        textState = .isEmpty
    }

    private func toggleShowHidePasswordBtnTapped() {
        guard let rightViewButton = rightViewButton else { return }
        textField.togglePasswordVisibility()
        rightViewButton.updateIcon(
            newIcon: textField.isSecureTextEntry ? "eye.slash" : "eye",
            newColor: .theme.tintColor ?? .label,
            newWeight: .regular
        )
    }

    init(frame: CGRect = .zero, viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setup()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - setup
    private func setup() {
        // self
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
        backgroundColor = .white
        layer.borderWidth = 1
        layer.masksToBounds = true
        layer.cornerRadius = 3
        layer.borderColor = UIColor.theme.border?.cgColor

        switch viewModel.type {
        case .Date:
            textField = DisabledTextField()
        default:
            textField = UITextField(frame: .zero)
        }

        // defualt
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.delegate = self

        // custom
        textField.keyboardType = viewModel.keyboard
        textField.returnKeyType = viewModel.returnKey
        textField.textContentType = viewModel.textContentType

        floatingLabel.text = viewModel.placeholder
        floatingLabel.textColor = viewModel.type.floatingLabelColor

        textField.textColor = viewModel.type.textColor
        textField.isSecureTextEntry = viewModel.type.isSecure


        addSubview(textField)
        addSubview(floatingLabel)

        // textField
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        txtFieldRightAnchorConstraint = textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding)
        txtFieldRightAnchorConstraint.isActive = true


        // floatingLabel
        floatingLabel.translatesAutoresizingMaskIntoConstraints = false
        floatingLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        floatingLabel.pinSides(to: self, padding: padding)

        // self
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: textField.topAnchor, constant: -20).isActive = true
        bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20).isActive = true

        // Add rightView if rightView is not nil
        guard let rightViewBtnConf = viewModel.type.rightViewButton else { return }
        rightViewButton = .createIconButton(
              icon: rightViewBtnConf.icon,
              size: rightViewBtnConf.size
        )
        guard let rightViewButton = rightViewButton else { return }
        rightViewButton.isHidden = true
        rightViewButton.addAction(for: .touchUpInside) { [weak self] _ in
            guard let self = self else { return }
            switch self.viewModel.type {
            case .Default:
                self.clearBtnTapped()
            case .Password:
                self.toggleShowHidePasswordBtnTapped()
            default: break
            }
        }

        addSubview(rightViewButton)

        rightViewButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        rightViewButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        txtFieldRightAnchorConstraint.constant = -(30 + rightViewButton.intrinsicContentSize.width)
        layoutIfNeeded()

    }
}

// MARK: - UITextFieldDelegate
extension CustomAuthTextFieldView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        focusState = .active
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        focusState = .inactive
    }
}

extension CustomAuthTextFieldView {
    // MARK: - ViewModel
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
                case .Date:
                    return .theme.floatingLabel
                default:
                    return .theme.placeholder
                }
            }

            var textColor: UIColor? {
                switch self {
                case .Date:
                    return .clear
                default:
                    return .label
                }
            }

            var rightViewButton: RightViewButton? {
                switch self {
                case .Default:
                    return .init(icon: "xmark", size: 17)
                case .Password:
                    return .init(icon: "eye.slash", size: 20)
                case .Date:
                    return nil
                }
            }

        }

        struct RightViewButton {
            let icon: String
            let size: CGFloat
        }

        let placeholder: String
        let keyboard: UIKeyboardType = .default
        let returnKey: UIReturnKeyType
        let textContentType: UITextContentType? = nil
        let type: TextFieldType
    }

}

// MARK: - Public States
extension CustomAuthTextFieldView {
    public enum ErrorState {
        case error

        var floatingLabelColor: UIColor? {
            return .red
        }

        var borderColor: CGColor? {
            return UIColor.red.cgColor
        }
    }
}

// MARK: - Private States
private extension CustomAuthTextFieldView {
    private enum TextState {
        case isEmpty
        case text

        var floatingLabelColor: UIColor? {
            switch self {
            case .isEmpty:
                return .theme.placeholder
            case .text:
                return .theme.floatingLabel
            }
        }

        var floatingLabelFont: UIFont {
            switch self {
            case .isEmpty:
                return  .systemFont(ofSize: 17, weight: .regular)
            case .text:
                return .systemFont(ofSize: 13, weight: .regular)
            }
        }

        var textFieldScale: CGAffineTransform {
            switch self {
            case .isEmpty:
                return .identity
            case .text:
                return CGAffineTransform(translationX: 0, y: 7.5)
            }
        }

    }

    private enum FocusState {
        case active
        case inactive

        var borderColor: CGColor? {
            switch self {
            case .active:
                return UIColor.theme.activeBorder?.cgColor
            case .inactive:
                return UIColor.theme.border?.cgColor
            }
        }
    }

    private enum ButtonState {
        case isHidden
        case isShown
    }

}

// MARK: - Test VC
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
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .theme.background

        view.addSubview(txtField)
        view.addSubview(txtField2)
        view.addSubview(txtField3)

        txtField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        txtField.pinSides(to: view, padding: 20)

        txtField2.topAnchor.constraint(equalTo: txtField.bottomAnchor, constant: 10).isActive = true
        txtField2.pinSides(to: view, padding: 20)

        txtField3.topAnchor.constraint(equalTo: txtField2.bottomAnchor, constant: 10).isActive = true
        txtField3.pinSides(to: view, padding: 20)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        txtField.errorState = .error
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.txtField.errorState = .error
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.txtField.errorState = nil
            }
        }
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
