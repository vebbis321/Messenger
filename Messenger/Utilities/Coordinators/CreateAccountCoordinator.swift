//
//  CreateAccountCoordinator.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/21/23.
//

import UIKit

final class CreateAccountCoordinator: Coordinator {
    weak var parentCoordinator: LogInCoordinator?
    var childCoordinators: [Coordinator] = [Coordinator]()

    var rootViewController: UINavigationController

    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }

    func start() {
        let vc = JoinFacebookVC()
        vc.coordinator = self
        rootViewController.pushViewController(vc, animated: true)
    }

    func goToAddNameVC() {
        let vc = AddNameVC(titleStr: "What's your name?")
        vc.coordinator = self
        rootViewController.pushViewController(vc, animated: true)
    }

    deinit {
        print("✅ Deinit CreateAccountCoordinator")
    }
}
