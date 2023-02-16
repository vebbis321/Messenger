//
//  UIViewController.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/15/23.
//

import UIKit

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
