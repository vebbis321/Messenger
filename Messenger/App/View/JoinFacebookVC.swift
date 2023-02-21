//
//  JoinFacebookVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/20/23.
//

import SwiftUI

final class JoinFacebookVC: UIViewController {

    weak var coordinator: CreateAccountCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator?.rootViewController.navigationBar.topItem?.backBarButtonItem = .init(title: "", style: .plain, target: nil, action: nil)

        let childView = UIHostingController(rootView: JoinFacebookView(getStartedTapped: { [weak self] in
            self?.coordinator?.goToAddNameVC()
        }, vcPopped: { [weak self] in
            self?.coordinator?.rootViewController.popToRootViewController(animated: true)
        }))
        addChild(childView)
        childView.view.frame = view.bounds
        view.addSubview(childView.view)
        childView.didMove(toParent: self)
    }

}
