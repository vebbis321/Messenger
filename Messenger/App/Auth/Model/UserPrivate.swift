//
//  UserPrivate.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/28/23.
//

import Foundation
import FirebaseFirestoreSwift

struct UserPrivate: FirestoreDocumentProtocol {
    @DocumentID var id: String? = UUID().uuidString
    var firstName: String
    var surname: String
    var email: String
    var dateOfBirth: Int64
}
