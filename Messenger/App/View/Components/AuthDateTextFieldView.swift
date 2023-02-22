//
//  AuthDateTextFieldView.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/22/23.
//

import UIKit
import Combine

final class AuthDateTextFieldView: AuthTextFieldView<DateTextField> {

    private var subscriptions = Set<AnyCancellable>()

    init(frame: CGRect = .zero) {
        super.init(placeholder: "", returnKey: .default)

        updateLayout()
        setUpBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - updateLayout
private extension AuthDateTextFieldView {
    private func updateLayout() {
        floatingLabel.transform = .init(translationX: 0, y: -(textField.intrinsicContentSize.height * 0.45))
        floatingLabel.textColor = .theme.floatingLabel
        floatingLabel.font = .systemFont(ofSize: 13, weight: .regular)
        textField.transform = .init(translationX: 0, y: 7.5)
        textField.tintColor = .clear

    }
}

// MARK: - Bindings
private extension AuthDateTextFieldView {
    private func setUpBindings() {
        Publishers.Merge(textField.textBecameActivePublisher(), textField.textBecameInActivePublisher())
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isActive in
                self?.layer.borderColor = isActive == true ? UIColor.theme.activeBorder?.cgColor : UIColor.theme.border?.cgColor
            }.store(in: &subscriptions)

    }
}




