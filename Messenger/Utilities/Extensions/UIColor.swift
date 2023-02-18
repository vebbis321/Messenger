//
//  UIColor.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/13/23.
//

import UIKit

extension UIColor {
    static let theme = MessengerColorTheme()
}

struct MessengerColorTheme {

    let border = UIColor(named: "Border")
    let activeBorder = UIColor(named: "ActiveBorder")
    let background = UIColor(named: "Background")
    let button = UIColor(named: "Button")
    let buttonText = UIColor(named: "ButtonText")
    let placeholder = UIColor(named: "Placeholder")
    let floatingLabel = UIColor(named: "FloatingLabel")
}
