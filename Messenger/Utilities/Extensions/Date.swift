//
//  Date.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/28/23.
//

import Foundation

// MARK: - unix timestamp
extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(timeIntervalSince1970 * 1000)
    }
}

// MARK: - localizedDescription
extension Date {
    var localizedDescription: String {
        return description(with: .current)
    }
}
