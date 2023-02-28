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

    func pinSides(to superView: UIView, padding: CGFloat = 0) {
        leftAnchor.constraint(equalTo: superView.leftAnchor, constant: padding).isActive = true
        rightAnchor.constraint(equalTo: superView.rightAnchor, constant: -padding).isActive = true
    }
}

// MARK: - Animations
extension UIView {
    func defaultAnimation(_ action: @escaping ()->()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            action()
        }
    }

    func spring(_ completionBlock: @escaping ()->()) {
        guard transform.isIdentity else { return }
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) { [weak self] in
            self?.transform = .init(scaleX: 0.95, y: 0.95)
        } completion: { done in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) { [weak self] in
                self?.transform = .init(scaleX: 1, y: 1)
            } completion: { _ in
                completionBlock()
            }
        }

    }
}

// MARK: - Round corners
extension UIView {
  func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
      let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                              cornerRadii: CGSize(width: radius, height: radius))
      let mask = CAShapeLayer()
      mask.path = path.cgPath
      layer.mask = mask
  }
}
