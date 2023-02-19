//
//  UIViewController.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/15/23.
//

import UIKit
import Combine

// MARK: - hide keyboard on tap
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Publishers
extension UIViewController {
    func keyboardIsShownPublisher() -> AnyPublisher<Bool, Never> {
        NotificationCenter.default
            .publisher(for: UIViewController.keyboardWillShowNotification, object: self)
            .map { _ in true }
            .eraseToAnyPublisher()
    }
}
