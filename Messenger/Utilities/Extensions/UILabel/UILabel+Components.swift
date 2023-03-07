//
//  UILabel+Components.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 3/7/23.
//

import UIKit

public extension UILabel {
    static func createSubLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.text = text
        label.numberOfLines = 0
        return label
    }
}
