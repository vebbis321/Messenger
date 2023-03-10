//
//  CustomValidation.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 3/10/23.
//

import UIKit
import Combine

protocol CustomValidation {
    func validate(subject: CurrentValueSubject<String, Never>) -> AnyPublisher<ValidationState, Never>
}

extension CustomValidation {
    // generic impl...  <S: Subject>(subject: S) -> AnyPublisher<String, Never> where S.Output == String, S.Failure == Never
    private func defaultTextPublisher(subject: CurrentValueSubject<String, Never>) -> AnyPublisher<String, Never> {
        subject
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func isEmpty(with subject: CurrentValueSubject<String, Never>) -> AnyPublisher<Bool, Never> {
        defaultTextPublisher(subject: subject)
            .map {
               return $0.isEmpty
            }
            .eraseToAnyPublisher()
    }

    func isToShort(with subject: CurrentValueSubject<String, Never>) -> AnyPublisher<Bool, Never> {
        defaultTextPublisher(subject: subject)
            .map { !($0.count >= 2) }
            .eraseToAnyPublisher()
    }

    func hasNumbers(with subject: CurrentValueSubject<String, Never>) -> AnyPublisher<Bool, Never> {
        defaultTextPublisher(subject: subject)
            .map { $0.hasNumbers() }
            .eraseToAnyPublisher()
    }

    func hasSpecialChars(with subject: CurrentValueSubject<String, Never>) -> AnyPublisher<Bool, Never> {
        defaultTextPublisher(subject: subject)
            .map { $0.hasSpecialCharacters() }
            .eraseToAnyPublisher()
    }

    func isEmail(with subject: CurrentValueSubject<String, Never>) -> AnyPublisher<Bool, Never> {
       defaultTextPublisher(subject: subject)
            .map {
                return $0.isValidEmail() }
            .eraseToAnyPublisher()
    }
}

enum ValidatorType  {
    case email
    case phone
}

enum ValidationState {
    case error(ErrorState)
    case valid

    enum ErrorState: String {
        case empty
        case invalidEmail
    }
}

struct EmailValidator: CustomValidation {

    func validate<S: Subject>(
        subject: S
    ) -> AnyPublisher<ValidationState, Never> where S.Output == String, S.Failure == Never {
        Publishers.CombineLatest(
            isEmpty(with: subject),
            isEmail(with: subject)
        )
        .removeDuplicates(by: { prev, curr in
            prev.0 == curr.0 && prev.1 == curr.1
        })
        .map { isEmpty, isEmail in
            if isEmpty { return .error(.empty) }
            if !isEmail { return .error(.invalidEmail) }
            return .valid
        }
        .eraseToAnyPublisher()

    }
}

struct PhoneValidator: CustomValidation {

    func validate(
        subject: CurrentValueSubject<String, Never>
    ) -> AnyPublisher<ValidationState, Never> {
        Publishers.CombineLatest(
            isEmpty(with: subject),
            isEmail(with: subject)
        )
        .removeDuplicates(by: { prev, curr in
            prev.0 == curr.0 && prev.1 == curr.1
        })
        .map { isEmpty, isEmail in
            if isEmpty { return .error(.empty) }
            if !isEmail { return .error(.invalidEmail) }
            return .valid
        }
        .eraseToAnyPublisher()

    }
}

enum ValidatorFactory {
    static func validateForType(type: ValidatorType) -> CustomValidation {
        switch type {
        case .email:
            return EmailValidator()
        case .phone:
            return PhoneValidator()
        }
    }
}

protocol Validator {
    func validateText(
        validationType: ValidatorType,
        subject: CurrentValueSubject<String, Never>
    ) -> AnyPublisher<ValidationState, Never>
}


extension UITextField: Validator {
    func validateText(
        validationType: ValidatorType,
        subject: CurrentValueSubject<String, Never>
    ) -> AnyPublisher<ValidationState, Never> {
        let validator = ValidatorFactory.validateForType(type: validationType)
        return validator.validate(subject: subject)
    }
}
