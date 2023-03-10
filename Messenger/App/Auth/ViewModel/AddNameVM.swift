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
        case numbers
        case specialChars
        case valid
    }

    typealias firstNameStatus = NameStatus
    typealias lastNameStatus = NameStatus

    var firstName = CurrentValueSubject<String, Never>("")
    var lastName = CurrentValueSubject<String, Never>("")
    var nameStatus = CurrentValueSubject<(firstNameStatus, lastNameStatus), Never>((.empty, .empty))

    private var cancellables = Set<AnyCancellable>()


    init() {
        Publishers.CombineLatest(
            isNameValid(with: firstName),
            isNameValid(with: lastName)
        )
        .receive(on: RunLoop.main)
        .assign(to: \.nameStatus.value, on: self)
        .store(in: &cancellables)

    }

}

// MARK: - Publishers
private extension AddNameVM {

    private func defaultTextPublisher<S: Subject>(subject: S) -> AnyPublisher<String, Never> where S.Output == String, S.Failure == Never{
        subject
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    private func isEmpty(with subject: CurrentValueSubject<String, Never>) -> AnyPublisher<Bool, Never> {
        defaultTextPublisher(subject: subject)
            .map { $0.isEmpty }
            .eraseToAnyPublisher()
    }

    private func isToShort(with subject: CurrentValueSubject<String, Never>) -> AnyPublisher<Bool, Never> {
        defaultTextPublisher(subject: subject)
            .map { !($0.count >= 2) }
            .eraseToAnyPublisher()
    }

    private func hasNumbers(with subject: CurrentValueSubject<String, Never>) -> AnyPublisher<Bool, Never> {
        defaultTextPublisher(subject: subject)
            .map { $0.hasNumbers() }
            .eraseToAnyPublisher()
    }

    private func hasSpecialChars(with subject: CurrentValueSubject<String, Never>) -> AnyPublisher<Bool, Never> {
        defaultTextPublisher(subject: subject)
            .map { $0.hasSpecialCharacters() }
            .eraseToAnyPublisher()
    }

    private func isNameValid(with subject: CurrentValueSubject<String, Never>) -> AnyPublisher<NameStatus, Never> {
        Publishers.CombineLatest4(
            isEmpty(with: subject),
            isToShort(with: subject),
            hasNumbers(with: subject),
            hasSpecialChars(with: subject)
        )
        .map {
            if $0.0 { return NameStatus.empty  }
            if $0.1 { return NameStatus.toShort }
            if $0.2 { return NameStatus.numbers }
            if $0.3 { return NameStatus.specialChars }
            return NameStatus.valid
        }
        .eraseToAnyPublisher()
    }



}
