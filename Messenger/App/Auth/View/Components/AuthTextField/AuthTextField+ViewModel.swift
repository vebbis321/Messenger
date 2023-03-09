//
//  AuthTextFieldView+ViewModel.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 3/9/23.
//

import UIKit

extension AuthTextField {
    // MARK: - ViewModel
    struct ViewModel {
        enum TextFieldType {
            case Default
            case Password
            case Date

            var isSecure: Bool {
                self == .Password ? true : false
            }

            var textFieldType: UITextField {
                switch self {
                case .Date:
                    return DisabledTextField()
                default:
                    return UITextField()
                }
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

            var tintColor: UIColor {
                switch self {
                case .Date:
                    return .clear
                default:
                    return .theme.tintColor ?? .label
                }
            }

            var iconButton: IconButton? {
                switch self {
                case .Default:
                    return .init(icon: "xmark", size: 17)
                case .Password:
                    return .init(icon: "eye.slash", size: 17)
                case .Date:
                    return nil
                }
            }

        }

        struct IconButton {
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
