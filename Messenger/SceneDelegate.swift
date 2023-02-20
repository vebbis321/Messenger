//
//  SceneDelegate.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/13/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var applicationCoordinator: ApplicationCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let applicationCoordinator = ApplicationCoordinator(window: window)
        applicationCoordinator.start()
        self.applicationCoordinator = applicationCoordinator

        window.makeKeyAndVisible()
    }


}

