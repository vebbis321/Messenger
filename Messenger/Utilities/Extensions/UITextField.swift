//
//  UITextField.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/14/23.
//

import Combine
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

// MARK: - Publishers
extension UITextField {
    func textBecameActivePublisher() -> AnyPublisher<Bool, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidBeginEditingNotification, object: self)
            .map { ($0.object as? UITextField)?.isEditing ?? false }
            .eraseToAnyPublisher()
    }

    func textBecameInActivePublisher() -> AnyPublisher<Bool, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidEndEditingNotification, object:  self)
            .map { ($0.object as? UITextField)?.isEditing ?? false }
            .eraseToAnyPublisher()
    }

    func textPublisher() -> AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object:  self)
            .compactMap { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }

    func textIsEmptyPublisher() -> AnyPublisher<Bool, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object:  self)
            .compactMap { ($0.object as? UITextField)?.text?.isEmpty ?? true }
            .eraseToAnyPublisher()
    }
}
