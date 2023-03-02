//
//  CustomIconBtn.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/15/23.
//

import UIKit

final class CustomIconBtn: UIButton {

    var action: (()->())?

    private var icon: String
    private var weight: UIImage.SymbolWeight
    private var size: CGFloat

    private var height: NSLayoutConstraint!
    private var width: NSLayoutConstraint!

    required init(frame: CGRect = .zero, icon: String, weight: UIImage.SymbolWeight = .light, size: CGFloat = 20) {
        self.icon = icon
        self.weight = weight
        self.size = size
        super.init(frame: frame)

        setUpLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Increase tappable area
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -15, dy: -15).contains(point)
    }

    func updateIcon(
        newIcon: String,
        newColor: UIColor = .theme.tintColor ?? .label,
        newWeight: UIImage.SymbolWeight = .light,
        newSize: CGFloat = 20
    ) {
        let config = UIImage.SymbolConfiguration(weight: newWeight)
        let iconImage = UIImage(systemName: newIcon, withConfiguration: config)?.withTintColor(newColor, renderingMode: .alwaysOriginal)
        setImage(iconImage, for: .normal)

        height.constant = newSize
        layoutIfNeeded()
    }

}

// MARK: - Layout
private extension CustomIconBtn {
    private func setUpLayout() {
        // layout

        let config = UIImage.SymbolConfiguration(weight: weight)
        let iconImage = UIImage(systemName: icon, withConfiguration: config)?.withTintColor(.theme.tintColor!, renderingMode: .alwaysOriginal)
        setImage(iconImage, for: .normal)
        addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        contentVerticalAlignment = .fill
        contentHorizontalAlignment = .fill
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        // constraints
        translatesAutoresizingMaskIntoConstraints = false
        height = heightAnchor.constraint(equalToConstant: size)
        height.isActive = true

    }
}

// MARK: - btnTapped
private extension CustomIconBtn {
    @objc func btnTapped(sender: UIControl) {
        action?()
    }
}
