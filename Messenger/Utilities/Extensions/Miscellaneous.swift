//
//  Miscala.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/22/23.
//

import UIKit


// MARK: - addAction
extension UIControl {
    func addAction(for event: UIControl.Event, handler: @escaping UIActionHandler) {
        self.addAction(UIAction(handler:handler), for:event)
    }
}
