//
//  AgreeAndCreateAccountVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/28/23.
//

import UIKit
import Combine

final class AgreeAndCreateAccountVC: DefaultCreateAccountVC {

    let viewModel = AgreeAndCreateAccountVM(
        authService: AuthService(),
        firestoreService: FirestoreService()
    )
    let subLabel = UILabel.createSubLabel(with: "Create a password with at least 6 letters and numbers. It should be something that others can't guess.")
    let tappableTextFields: [TappableTextView] = Array(0..<4).map { _ in .init() }
    let vStack = UIStackView(frame: .zero)
    let iAggreBtn = AuthButton(title: "I Agree")

    private var stateSubscription: AnyCancellable?

    init(titleStr: String, password: String) {
        super.init(titleStr: titleStr)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setUpViews()
        setUpConstraints()

        stateSubscription = viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentState in
                switch currentState {
                case .idle:
                    break
                case .loading:
                    self?.iAggreBtn.isLoading = true
                case .success:
                    self?.iAggreBtn.isLoading = false
                case .error(_):
                    self?.iAggreBtn.isLoading = false
                }
            }
    }
}

private extension AgreeAndCreateAccountVC {
    private func setUpViews() {

        // tappableTextFields
        for (index, textField) in tappableTextFields.enumerated() {
            textField.text = viewModel.textItemVms[index].text
            textField.addTappableTexts(viewModel.textItemVms[index].tappableTextAndUrlString)
            vStack.addArrangedSubview(textField)
        }

        // vStack
        vStack.axis = .vertical
        vStack.spacing = 20

        // iAggreBtn
        iAggreBtn.addAction(for: .touchUpInside) { _ in
            Task { [weak self] in
                guard let self = self,
                      let password = self.coordinator?.password,
                      let user = self.coordinator?.user else { return }
                await self.viewModel.createAccout(userPrivate: user, password: password)
            }
        }

        // content
        contentView.addSubview(subLabel)
        contentView.addSubview(vStack)
        contentView.addSubview(iAggreBtn)
    }
}

private extension AgreeAndCreateAccountVC {
    private func setUpConstraints() {
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        subLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        subLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 20).isActive = true
        vStack.pinSides(to: contentView)

        iAggreBtn.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 20).isActive = true
        iAggreBtn.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        iAggreBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

    }
}




