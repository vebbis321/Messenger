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

    required init(frame: CGRect = .zero, icon: String) {
        self.icon = icon
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
        let config = UIImage.SymbolConfiguration(weight: .light)
        let iconImage = UIImage(systemName: newIcon, withConfiguration: config)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        setImage(iconImage, for: .normal)
    }

}

// MARK: - Layout
private extension CustomIconBtn {
    private func setUpLayout() {
        // layout

        let config = UIImage.SymbolConfiguration(weight: .light)
        let iconImage = UIImage(systemName: icon, withConfiguration: config)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        setImage(iconImage, for: .normal)
        addTarget(self, action: #selector(btnTapped), for: .touchUpInside)

        // constraints
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 30).isActive = true
        heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}

// MARK: - btnTapped
private extension CustomIconBtn {
    @objc func btnTapped(sender: UIControl) {
        action?()
    }
}