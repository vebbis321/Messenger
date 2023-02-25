//
//  PresentationController.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/25/23.
//

import UIKit

class PresentationController: UIPresentationController {

    let darkView = UIView(frame: .zero)
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {

        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        darkView.backgroundColor = .black.withAlphaComponent(0.35)
        darkView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        darkView.isUserInteractionEnabled = true
        darkView.addGestureRecognizer(tapGestureRecognizer)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(
            origin: CGPoint(
                x: 0,
                y: containerView!.frame.height * 0.4),
            size: CGSize(
                width: containerView!.frame.width,
                height: containerView!.frame.height * 0.6)
        )
    }


    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.roundCorners([.topLeft, .topRight], radius: 22)
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    @objc func dismissController(){
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
