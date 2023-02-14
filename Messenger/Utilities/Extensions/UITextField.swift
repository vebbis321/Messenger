//
//  UITextField.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/14/23.
//

import UIKit

// MARK: - Edit placeHolder font
extension UITextField {
    func changePlaceholderText(placeholderText: String, font: UIFont, color: UIColor = .theme.placeholder ?? .gray) {
        self.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.font: font
            ]
        )
    }
}
