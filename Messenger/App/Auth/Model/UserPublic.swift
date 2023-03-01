//
//  UserPublic.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/28/23.
//

import UIKit
import FirebaseFirestoreSwift

struct UserPublic: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    let firstName: String
    let surName: String
}
