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
            .map { $0.isEmpty }
            .eraseToAnyPublisher()
    }

    func isToShort(with subject: CurrentValueSubject<String, Never>, count: Int) -> AnyPublisher<Bool, Never> {
        defaultTextPublisher(subject: subject)
            .map { !($0.count >= count) }
            .eraseToAnyPublisher()
    }

    func hasNumbers(with subject: CurrentValueSubject<String, Never>) -> AnyPublisher<Bool, Never> {
        defaultTextPublisher(subject: subject)
            .map { $0.hasNumbers() }
            .eraseToAnyPublisher()
    }

    func hasLetters(with subject: CurrentValueSubject<String, Never>) -> AnyPublisher<Bool, Never> {
        defaultTextPublisher(subject: subject)
            .map { $0.contains(where: { $0.isLetter }) }
            .eraseToAnyPublisher()
    }

    func hasSpecialChars(with subject: CurrentValueSubject<String, Never>) -> AnyPublisher<Bool, Never> {
        defaultTextPublisher(subject: subject)
            .map { $0.hasSpecialCharacters() }
            .eraseToAnyPublisher()
    }

    func isEmail(with subject: CurrentValueSubject<String, Never>) -> AnyPublisher<Bool, Never> {
       defaultTextPublisher(subject: subject)
            .map { $0.isValidEmail() }
            .eraseToAnyPublisher()
    }

    func isPhoneNumber(with subject: CurrentValueSubject<String, Never>) -> AnyPublisher<Bool, Never> {
        defaultTextPublisher(subject: subject)
            .map { $0.isPhoneNumValid() }
            .eraseToAnyPublisher()
    }
}

enum ValidatorType  {
    case email
    case phone
    case password
    case name
}

enum ValidationState: Equatable {
    case idle
    case error(ErrorState)
    case valid

    enum ErrorState {
        case empty
        case invalidEmail
        case invalidPhoneNum
        case toShortPassword
        case passwordNeedsNum
        case passwordNeedsLetters
        case nameCantHaveNumOrSpecialChars
        case toShortName

        var description: String {
            switch self {
            case .empty:
                return "Field is empty."
            case .invalidEmail:
                return "Invalid email."
            case .invalidPhoneNum:
                return "Invalid phone number."
            case .toShortPassword:
                return "Your password is to short."
            case .passwordNeedsNum:
                return "Your password doesn't contain any numbers."
            case .passwordNeedsLetters:
                return "Your password doesn't contain any letters."
            case .nameCantHaveNumOrSpecialChars:
                return "Name can't contain numbers or special characters."
            case .toShortName:
                return "Your name can't be less than two characters."
            }
        }
    }

}

struct EmailValidator: CustomValidation {

    func validate(
        subject: CurrentValueSubject<String, Never>
    ) -> AnyPublisher<ValidationState, Never>{
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
            isPhoneNumber(with: subject)
        )
        .removeDuplicates(by: { prev, curr in
            prev.0 == curr.0 && prev.1 == curr.1
        })
        .map { isEmpty, isPhoneNum in
            if isEmpty { return .error(.empty) }
            if !isPhoneNum { return .error(.invalidPhoneNum) }
            return .valid
        }
        .eraseToAnyPublisher()

    }
}

struct PasswordValidator: CustomValidation {
    func validate(
        subject: CurrentValueSubject<String, Never>
    ) -> AnyPublisher<ValidationState, Never> {
        Publishers.CombineLatest4(
            isEmpty(with: subject),
            isToShort(with: subject, count: 6),
            hasNumbers(with: subject),
            hasLetters(with: subject)
        )
        .removeDuplicates(by: { prev, curr in
            prev.0 == curr.0 && prev.1 == curr.1 && prev.2 == curr.2 && prev.3 == curr.3
        })
        .map { isEmpty, toShort, hasNumbers, hasLetters in
            if isEmpty { return .error(.empty) }
            if toShort { return .error(.toShortPassword) }
            if !hasNumbers { return .error(.passwordNeedsNum) }
            if !hasLetters { return .error(.passwordNeedsLetters) }
            return .valid
        }
        .eraseToAnyPublisher()
    }
}

struct NameValidator: CustomValidation {
    func validate(
        subject: CurrentValueSubject<String, Never>
    ) -> AnyPublisher<ValidationState, Never> {
        Publishers.CombineLatest4(
            isEmpty(with: subject),
            isToShort(with: subject, count: 2),
            hasNumbers(with: subject),
            hasSpecialChars(with: subject)
        )
        .removeDuplicates(by: { prev, curr in
            prev.0 == curr.0 && prev.1 == curr.1 && prev.2 == curr.2 && prev.3 == curr.3
        })
        .map { isEmpty, toShort, hasNumbers, hasSpecialChars in
            if isEmpty { return .error(.empty) }
            if toShort { return .error(.toShortName) }
            if hasNumbers || hasSpecialChars { return .error(.nameCantHaveNumOrSpecialChars) }
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
        case .password:
            return PasswordValidator()
        case .name:
            return NameValidator()
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
