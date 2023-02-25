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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SheetHandlerView {
    private func setUpLayout() {
        backgroundColor = .lightGray
        layer.cornerRadius = 20
        layer.masksToBounds = true

        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 15).isActive = true
        heightAnchor.constraint(equalToConstant: 5).isActive = true
    }
}
