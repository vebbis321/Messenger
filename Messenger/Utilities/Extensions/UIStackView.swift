//
//  UIStackView.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/21/23.
//

import UIKit

// MARK: - customize
extension UIStackView {
    func customize(backgroundColor: UIColor = .clear, cornerRadius: CGFloat = 0) {
            let subView = UIView(frame: bounds)
            subView.backgroundColor = backgroundColor
            subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            insertSubview(subView, at: 0)

            subView.layer.cornerRadius = cornerRadius
            subView.layer.masksToBounds = true
            subView.clipsToBounds = true
        }
}
