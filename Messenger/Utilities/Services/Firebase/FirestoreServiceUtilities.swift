//
//  AuthService.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/28/23.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

// MARK: - Protocols
protocol FirestoreDocumentProtocol: Identifiable, Codable { }

protocol FirestoreServiceProtocol {

    // create
    func createDoc<T: FirestoreDocumentProtocol>(model: T, path: FirestorePathToDoc) async throws
}


// MARK: - Path
enum FirestorePathToDoc {
    case userPublic(uid: String)
    case userPrivate(uid: String)

    var description: String {
        switch self {
        // user
        case .userPublic(let uid):
            return "user_public/\(uid)"
        case .userPrivate(let uid):
            return "user_private/\(uid)"
        }
    }
}

enum FirestorePathToCollection {

    case userPublicMarketplaceListings(uid: String)

    var description: String {
        switch self {
            // user
        case .userPublicMarketplaceListings(uid: let uid):
            return "user_public/\(uid)/marketplace_listings"
        }
    }
}

struct FirestorePathsCollectionFilter {

    var field: String
    var isEqualTo: Any
}

