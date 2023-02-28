//
//  SheetHandlerView.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/23/23.
//

import UIKit

final class SheetHandlerView: UIView {

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        setUpLayout()
    }

    override func layoutSubviews() {
        roundCorners(.allCorners, radius: 10)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SheetHandlerView {
    private func setUpLayout() {
        backgroundColor = .lightGray.withAlphaComponent(0.65)
        layer.masksToBounds = true

        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 40).isActive = true
        heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
}
