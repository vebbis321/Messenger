//
//  UIView.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/20/23.
//

import UIKit

// MARK: - Pin to...
extension UIView {

    /// Left and right anchor
    func pin(to superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    }

    func pinWithSafeArea(to superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
