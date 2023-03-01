//
//  UserPrivate.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/28/23.
//

import Foundation
import FirebaseFirestoreSwift

struct UserPrivate: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    let firstName: String
    let surName: String
    let email: String
    let dateOfBirth: Int64
}
