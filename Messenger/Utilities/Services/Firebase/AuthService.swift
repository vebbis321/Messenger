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
    func createAccounWith(email: String, password: String) async throws -> String
    func observeAuthChanges() -> AnyPublisher<SessionState, Never>
}

enum SessionState: Equatable {
    case idle
    case notAuth(showVerifyVC: Bool)
    case verified
    case error
}

// MARK: - Create account
final actor AuthService: AuthServiceProtocol {
    func createAccounWith(email: String, password: String) async throws -> String {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        try await result.user.sendEmailVerification()
        return result.user.uid
    }
}

// MARK: - Observe
extension AuthService {
    nonisolated func observeAuthChanges() -> AnyPublisher<SessionState, Never> {
        return Publishers.AuthPublisher().eraseToAnyPublisher()
    }
}
