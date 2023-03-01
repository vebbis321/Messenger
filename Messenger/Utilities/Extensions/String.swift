//
//  String.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 3/1/23.
//

import Foundation

// MARK: - Predicates
extension String {
    func hasUppecaseCharacters() -> Bool {
        return stringFulfillsRegex(regex:  ".*[A-Z]+.*")
    }

    func hasLowercaseCharacters() -> Bool {
        return stringFulfillsRegex(regex: ".*[a-z].*")
    }

    func hasNumbers() -> Bool {
        return stringFulfillsRegex(regex: ".*[0-9].*")
    }

    func hasSpecialCharacters() -> Bool {
        return stringFulfillsRegex(regex: ".*[^A-Za-z0-9].*")
    }


    private func stringFulfillsRegex(regex: String) -> Bool {
        let texttest = NSPredicate(format: "SELF MATCHES %@", regex)
        guard texttest.evaluate(with: self) else {
            return false
        }
        return true
    }
}
