//
//  LogInCoordinator.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/20/23.
//

import UIKit

final class AuthCoordinator: Coordinator {
    weak var parentCoordinator: ApplicationCoordinator?

    var childCoordinators: [Coordinator] = [Coordinator]()

    var rootViewController: UINavigationController

    init() {
        rootViewController = .init()
        rootViewController.navigationBar.tintColor = .theme.textButton
    }

    func start() {
        let vc = LogInVC()
        vc.coordinator = self
        rootViewController.pushViewController(vc, animated: false)
    }

    func goToCreateAccount() {
        let vc = JoinFacebookVC()
        vc.coordinator = self
        rootViewController.pushViewController(vc, animated: true)
    }
}
