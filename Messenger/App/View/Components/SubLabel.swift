//
//  SubLabel.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/22/23.
//

import UIKit

final class SubLabel: UILabel {
    init(frame: CGRect = .zero, labelText: String) {
        super.init(frame: frame)
        font = .preferredFont(forTextStyle: .subheadline)
        text = labelText
        numberOfLines = 0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
