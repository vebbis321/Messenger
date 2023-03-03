//
//  CustomAuthTextFieldView.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 3/3/23.
//

import UIKit
import Combine

extension UITextField {
    static func creatAuthTextField() -> UITextField {
        let txtField = UITextField()
        txtField.font = .systemFont(ofSize: 17, weight: .regular)
        return txtField
    }
}

class CustomAuthTextFieldView<MyCustomTextField: UITextField>: UIView {

    struct ItemViewModel {

        enum State {
            case clear
            case date
            case errorWithClear

            var floatingLabelColor: UIColor? {
                switch self {
                case .clear:
                    return .theme.floatingLabel
                case .date:
                    return .theme.floatingLabel
                case .errorWithClear:
                    return .red
                }
            }

        }

        /// The placeholder text.
        let placeholder: String?
        var keyboard: UIKeyboardType
        var state: State

    }

    /// The properties that can be applied to the right view.
    struct RightView {

        /// The optional image for the right view.
        var icon: String?

        /// The tint color of the text and image.
        var tintColor: UIColor?
    }


    var viewModel: ItemViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }

            textField.keyboardType = viewModel.keyboard
            floatingLabel.text = viewModel.placeholder
            floatingLabel.textColor = viewModel.state.floatingLabelColor
        }
    }


    let textField: UITextField
    let floatingLabel = UILabel(frame: .zero)


    init(frame: CGRect = .zero, viewModel: ItemViewModel) {

        self.textField = MyCustomTextField()
        self.viewModel = viewModel

        // default impl

        super.init(frame: frame)

        defaultImpl()
        setUpConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Views
private extension CustomAuthTextFieldView {
    private func defaultImpl() {
        // self
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.theme.border?.cgColor
        layer.masksToBounds = true
        layer.cornerRadius = 3

        // textField
        textField.font = .systemFont(ofSize: 17, weight: .regular)

        // floatingLabel / placeholder
        floatingLabel.font = .systemFont(ofSize: 17, weight: .regular)

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
        floatingLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        floatingLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding).isActive = true

        // self
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: textField.topAnchor, constant: -20).isActive = true
        bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20).isActive = true

    }
}

