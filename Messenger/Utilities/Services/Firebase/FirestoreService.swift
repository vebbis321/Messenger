//
//  FirestoreService.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/28/23.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FirestoreService: FirestoreServiceProtocol {
    private let db = Firestore.firestore()
}

// MARK: - Create
extension FirestoreService {
    func createDoc<T: FirestoreDocumentProtocol>(model: T, path: FirestorePathToDoc) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            createDoc(model: model, path: path) { result in
                continuation.resume(with: result)
            }
        }
    }
}

// MARK: - Completion handlers
private extension FirestoreService {
    private func createDoc<T: FirestoreDocumentProtocol>(model: T, path: FirestorePathToDoc, completion: @escaping (Result<Void, MessengerError>)->Void) {
        let ref = db.document(path.description)
        do {
            try ref.setData(from: model)
            completion(.success(()))
        } catch {
            completion(.failure(.default(error)))
        }
    }
}
