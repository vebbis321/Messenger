//
//  ApplicationCoordinator.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/13/23.
//

import UIKit
import Combine

final class ApplicationCoordinator: Coordinator {
    var rootViewController: UINavigationController = UINavigationController()

    var childCoordinators: [Coordinator] = [Coordinator]()

    private let stateManager = StateManager()
    private var stateSubscription: AnyCancellable?

    let window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        stateSubscription = stateManager.session
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .idle:
                    let vc = LaunchVC()
                    self?.window.rootViewController = vc

                case .notAuth(let showVerifyVC):
                    print("NOT auth, showVerify: \(showVerifyVC)")

                    let child = LogInCoordinator()
                    child.parentCoordinator = self
                    self?.childCoordinators.removeAll()
                    self?.childCoordinators.append(child)
                    child.start()
                    
                    if showVerifyVC {
                        child.showVerifyEmail()
                    }


                case .verified:
                    break

                case .error:
                    break
                }
            }
    }

    

    deinit {
        print("✅ Deinit ApplicationCoordinator")
    }
}
