//
//  AuthService.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 3/1/23.
//

import Foundation
import Combine
import FirebaseAuth

protocol AuthServiceProtocol {
    func createAccounWith(email: String, password: String) async throws
    func observeAuthChanges() -> AnyPublisher<SessionState, Never>
}

enum SessionState {
    case idle
    case notAuth
    case notVerified
    case verified
    case error
}

// MARK: - Create account
final class AuthService: AuthServiceProtocol {
    func createAccounWith(email: String, password: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        try await result.user.sendEmailVerification()
    }
}

// MARK: - Observe
extension AuthService {
    func observeAuthChanges() -> AnyPublisher<SessionState, Never> {
        return Publishers.AuthPublisher().eraseToAnyPublisher()
    }
}
