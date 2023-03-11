//
//  CustomAuthTextFieldView.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 3/3/23.
//

import UIKit
import Combine

public protocol CustomTextField: UIView {
    var textField: UITextField { get set }
}


public protocol TextFieldDelegate: AnyObject {
    func textFieldDidBeginEditing(_ customTextField: CustomTextField)
    func textFieldDidEndEditing(_ customTextField: CustomTextField)
    func textFieldShouldReturn(_ customTextField: CustomTextField) -> Bool
    func textField(_ customTextField: CustomTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func textFieldDidChange(_ customTextField: CustomTextField)
    func textFieldDidTapMultilineAction(_ customTextField: CustomTextField)
}

public extension TextFieldDelegate {
    func textFieldDidBeginEditing(_ customTextField: CustomTextField) {
        // Default empty implementation
    }

    func textFieldDidEndEditing(_ customTextField: CustomTextField) {
        // Default empty implementation
    }

    func textFieldShouldReturn(_ customTextField: CustomTextField) -> Bool {
        return true
    }

    func textField(_ customTextField: CustomTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

    func textFieldDidChange(_ customTextField: CustomTextField) {
        // Default empty implementation
    }

    func textFieldDidTapMultilineAction(_ customTextField: CustomTextField) {
        // Default empty implementation
    }
}


class AuthTextField: UIView, CustomTextField {

    // MARK: - Components
    lazy var textField: UITextField = {
        return viewModel.type.textFieldType
    }()
    private lazy var floatingLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    private lazy var iconButton: UIButton? = nil
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(handleDateChanged), for: .valueChanged)
        return datePicker
    }()

    // MARK: - override
    override func didMoveToWindow() {
        // similar to viewWillAppear

        guard viewModel.type == .Date else {
            print("STARTED \(viewModel.type)")
            startValidation()
            return
        }
        updateDate()
    }

    // MARK: - Private Properties
    private var viewModel: ViewModel
    private let padding: CGFloat = 15
    private var txtFieldRightAnchorConstraint: NSLayoutConstraint!

    // MARK: - Delegate
    weak var delegate: TextFieldDelegate?

    // MARK: - Public TextField State
    private var subscriptions = Set<AnyCancellable>()
    var textFieldSubject = CurrentValueSubject<String, Never>("")

    public func startValidation() {
        textField.createBinding(with: textFieldSubject, storeIn: &subscriptions)
        textField.validateText(validationType: .password, subject: textFieldSubject)
            .sink { state in
                print(state)
            }
            .store(in: &subscriptions)
    }

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
            evaluateIsTextEmptyState()
            evaluateButtonState()
        }
    }

    // MARK: - Private Methods
    private func evaluateIsTextEmptyState() {
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
            iconButton?.updateIcon(newIcon: "xmark", newColor: .theme.tintColor)

        case .some(let state):
            floatingLabel.textColor = state.floatingLabelColor
            layer.borderColor = state.borderColor
        }

    }

    private func evaluateButtonState() {
        guard let rightViewButton = iconButton else { return }
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
        // for combine
        NotificationCenter.default.post(
            name:UITextField.textDidChangeNotification, object: textField)
    }

    private func toggleShowHidePasswordBtnTapped() {
        guard let rightViewButton = iconButton else { return }
        textField.togglePasswordVisibility()
        rightViewButton.updateIcon(
            newIcon: textField.isSecureTextEntry ? "eye.slash" : "eye",
            newColor: .theme.tintColor ?? .label,
            newWeight: .regular
        )
    }

    @objc private func handleDateChanged() {
        updateDate()
    }

    private func updateDate() {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        textField.text = formatter.string(from: datePicker.date)
        let age = Calendar.current.dateComponents([.year], from: datePicker.date, to: Date())
        floatingLabel.text = "Date of birth (\(age.year ?? 0) year old)"
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
            textField.inputView = datePicker
            textField.transform = .init(translationX: 0, y: 7.5)
            floatingLabel.font = .systemFont(ofSize: 13, weight: .regular)
            floatingLabel.transform = .init(translationX: 0, y: -(textField.intrinsicContentSize.height * 0.45))
        default:
            break
        }

        // defualt
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.delegate = self

        // custom
        textField.keyboardType = viewModel.type.keyboard
        textField.returnKeyType = viewModel.returnKey
        textField.textContentType = viewModel.type.textContentTypes
        textField.autocapitalizationType = viewModel.type.autocapitalization

        floatingLabel.text = viewModel.placeholder
        floatingLabel.textColor = viewModel.type.floatingLabelColor

        textField.isSecureTextEntry = viewModel.type.isSecure
        textField.tintColor = viewModel.type.tintColor


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
        guard let iconBtnConf = viewModel.type.iconButton else { return }
        iconButton = .createIconButton(
              icon: iconBtnConf.icon
        )
        guard let iconBtn = iconButton else { return }
        iconBtn.isHidden = true
        iconBtn.addAction(for: .touchUpInside) { [weak self] _ in
            guard let self = self else { return }
            switch self.viewModel.type {
            case .Default:
                self.clearBtnTapped()
            case .Password:
                self.toggleShowHidePasswordBtnTapped()
            default: break
            }
        }

        addSubview(iconBtn)
        iconBtn.translatesAutoresizingMaskIntoConstraints = false
        iconBtn.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        iconBtn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        txtFieldRightAnchorConstraint.constant = -(30 + iconBtn.intrinsicContentSize.width)
        layoutIfNeeded()

    }
}

// MARK: - UITextFieldDelegate
extension AuthTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldDidBeginEditing(self)
        focusState = .active
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        focusState = .inactive
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard viewModel.type == .Date else { return true }
        if textField.tag == 1 {
            textField.text = ""
            return false
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard viewModel.type == .Date else { return true }
        if textField.tag == 1 {
            textField.text = ""
            return false
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldReturn(self) ?? true
    }
}





// MARK: - Test VC
final class TextfieldVC: UIViewController {
    let txtField = AuthTextField(
        viewModel: .init(
            placeholder: "Clear",
            returnKey: .default, type: .Default(.Email)))
    let txtField2 = AuthTextField(
        viewModel: .init(
            placeholder: "Password",
            returnKey: .default, type: .Password))
    let txtField3 = AuthTextField(
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


