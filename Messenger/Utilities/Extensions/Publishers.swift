//
//  Publishers.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 3/1/23.
//

import Foundation
import Combine


extension Publisher where Output == String {
    func isStringEmpty() -> Publishers.Map<Self, Bool> {
        map { $0.isEmpty }
    }

    func stringHasNumbers() -> Publishers.Map<Self, Bool> {
        map { $0.hasNumbers() }
    }

    func stringHasSpecialChars() -> Publishers.Map<Self, Bool> {
        map { $0.hasSpecialCharacters() }
    }
}


extension Publisher {


}
