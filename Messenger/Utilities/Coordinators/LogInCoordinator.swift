//
//  LogInCoordinator.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/20/23.
//

import UIKit

final class LogInCoordinator: NSObject, Coordinator {
    weak var parentCoordinator: ApplicationCoordinator?

    var childCoordinators: [Coordinator] = [Coordinator]()

    var rootViewController: UINavigationController

    override init() {
        rootViewController = .init()
        rootViewController.navigationBar.tintColor = .theme.tintColor
       
    }

    func start() {
        let vc = LogInVC()
        vc.coordinator = self
        rootViewController.delegate = self
        rootViewController.pushViewController(vc, animated: false)
    }

    func startCreateAccountCoordinator() {
        let child = CreateAccountCoordinator(rootViewController: rootViewController)
        childCoordinators.append(child)
        child.parentCoordinator = self
        child.start()
    }

    deinit {
        print("✅ Deinit LogInCoordinator")
    }
}

// MARK: - NavVCDelegate
extension LogInCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Read the view controller we’re moving from.
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        // Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        // We’re still here – it means we’re popping the view controller, so we can check whether it’s a buy view controller
        if let joinFacebookVC = fromViewController as? JoinFacebookVC {
            // We're popping a buy view controller; end its coordinator
            childDidFinish(joinFacebookVC.coordinator)
        }
    }
}

// MARK: - chilDidFinish
extension LogInCoordinator {
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
