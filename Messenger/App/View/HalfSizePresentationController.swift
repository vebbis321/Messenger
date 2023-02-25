//
//  HalfSizePresentationController.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/25/23.
//

import UIKit

class HalfSizePresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let bounds = containerView?.bounds else { return .zero }
        return CGRect(x: 0, y: bounds.height * 0.25, width: bounds.width, height: bounds.height * 0.75)
    }
}
