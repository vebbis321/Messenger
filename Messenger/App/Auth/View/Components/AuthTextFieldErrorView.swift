//
//  AuthTextFieldErrorView.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 3/2/23.
//

import UIKit
import Combine

final class AuthTextFieldErrorView: AuthTextFieldClearView {

    private var subscriptions = Set<AnyCancellable>()
    var isError: Bool = false

    override init(frame: CGRect = .zero, placeholder: String, keyboard: UIKeyboardType = .default, returnKey: UIReturnKeyType) {
        super.init(placeholder: placeholder, keyboard: keyboard, returnKey: returnKey)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setUpBindings() {
        Publishers.Merge(textField.textBecameActivePublisher(), textField.textBecameInActivePublisher())
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isActive in
                guard let self = self else { return }
                if self.isError {

                } else {
                    isActive ? self.handleTextFieldBecameActive() : self.handleTextFieldBecameInactive()
                }
            }.store(in: &subscriptions)

        textField.textIsEmptyPublisher()
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isTextEmpty in
                guard let self = self else { return }
                if self.isError {

                } else {
                    isTextEmpty ? self.handleTextFieldBecameEmpty() : self.handleTextFieldBecameNonEmpty()
                }
            }.store(in: &subscriptions)
    }

}


// MARK: - Functions
private extension AuthTextFieldErrorView {


}

