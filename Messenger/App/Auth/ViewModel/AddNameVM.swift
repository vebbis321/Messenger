//
//  AddNameVM.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 3/1/23.
//

import Combine
import Foundation

// MARK: - Properties
final class AddNameVM {
    enum NameStatus {
        case empty
        case toShort
        case valid
    }

    typealias firstNameStatus = NameStatus
    typealias lastNameStatus = NameStatus

    var firstName = CurrentValueSubject<String, Never>("")
    var lastName = CurrentValueSubject<String, Never>("")
    var nameStatus = CurrentValueSubject<(firstNameStatus, lastNameStatus), Never>((.empty, .empty))

}

// MARK: - Predicates
private extension AddNameVM {
    private var isFirstNameEmpty: AnyPublisher<Bool, Never> {
        firstName
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { $0.isEmpty }
            .eraseToAnyPublisher()
    }
}


