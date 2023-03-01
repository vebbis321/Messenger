//
//  StateManager.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 3/1/23.
//

import Foundation
import Combine

final class StateManager {

    var session = CurrentValueSubject<SessionState, Never>(.idle)
    private let authService: AuthServiceProtocol
    private var authSubscription: AnyCancellable?

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.listen()
        }
    }

    func listen() {
        authSubscription = authService.observeAuthChanges()
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] state in
                self?.session.send(state)
            }
    }
}
