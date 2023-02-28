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

    required init(frame: CGRect = .zero, icon: String, weight: UIImage.SymbolWeight = .light, size: CGFloat = 17) {
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

    func updateIcon(for newIcon: String) {
        let config = UIImage.SymbolConfiguration(weight: weight)
        let iconImage = UIImage(systemName: newIcon, withConfiguration: config)?.withTintColor(.theme.tintColor!, renderingMode: .alwaysOriginal)
        setImage(iconImage, for: .normal)
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
        heightAnchor.constraint(equalToConstant: size).isActive = true
    }
}

// MARK: - btnTapped
private extension CustomIconBtn {
    @objc func btnTapped(sender: UIControl) {
        action?()
    }
}
