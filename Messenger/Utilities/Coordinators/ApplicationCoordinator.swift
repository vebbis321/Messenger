//
//  ApplicationCoordinator.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/13/23.
//

import UIKit

final class ApplicationCoordinator: Coordinator {
    var rootViewController: UINavigationController = UINavigationController()

    var childCoordinators: [Coordinator] = [Coordinator]()

    let window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let child = LogInCoordinator()
        child.parentCoordinator = self
        childCoordinators.removeAll()
        childCoordinators.append(child)
        child.start()
        window.rootViewController = child.rootViewController
    }

    

    deinit {
        print("✅ Deinit ApplicationCoordinator")
    }
}
