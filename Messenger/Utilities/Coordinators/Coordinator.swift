//
//  Coordinator.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/13/23.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var rootViewController: UINavigationController { get set }
    
    func start()
}
