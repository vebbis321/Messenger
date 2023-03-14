//
//  AgreeAndCreateAccountVM.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/28/23.
//

import Foundation
import Combine

final class AgreeAndCreateAccountVM {
    enum State {
        case idle
        case loading
        case success
        case error(MessengerError)
    }

    var textItemVms: [AgreeAndCreateAccountItemVM]!
    var state = CurrentValueSubject<State, Never>(.idle)

    private var authService: AuthServiceProtocol
    private var firestoreService: FirestoreServiceProtocol

    init(authService: AuthServiceProtocol, firestoreService: FirestoreServiceProtocol) {
        self.authService = authService
        self.firestoreService = firestoreService

        createTextItemVms()
    }

    @MainActor
    func createAccout(userPrivate: UserPrivate, password: String) async {
        state.send(.loading)
        do {
            let uid = try await authService.createAccounWith(email: userPrivate.email, password: password)

            let user = UserPrivate(
                id: uid, firstName: userPrivate.firstName,
                surname: userPrivate.surname,
                email: userPrivate.email,
                dateOfBirth: userPrivate.dateOfBirth
            )

            try await firestoreService.createDoc(model: user, path: .userPrivate(uid: uid))
            state.send(.success)
        } catch {
            state.send(.error(.default(error)))
        }
    }
}

// MARK: - textItemVms
extension AgreeAndCreateAccountVM {
    struct AgreeAndCreateAccountItemVM {
        let text: String
        let tappableTextAndUrlString: [String: String]
    }

    private func createTextItemVms() {
        textItemVms = [
            .init(
                text: "People who use our service may have uploaded your contact information to Facebook. Learn more",
                tappableTextAndUrlString: ["Learn more" : "https://www.facebook.com/policies_center"]
            ),
            .init(
                text: "By tapping I agree, you agree to create an account and to Facebook's terms. Learn how we collect, use and share your data in our Privacy Policy and how we use cookies and similar technology in our Cookies Policy.",
                tappableTextAndUrlString: [
                    "terms.": "https://www.facebook.com/policies_center",
                    "Privacy Policy": "https://www.facebook.com/policies_center",
                    "Cookies Policy.": "https://www.facebook.com/policies_center"
                ]
            ),
            .init(
                text: "People who use our service may have uploaded your contact information to Facebook. Learn more",
                tappableTextAndUrlString: ["Privacy Policy" : "https://www.facebook.com/policies_center"]
            ),
            .init(
                text: "People who use our service may have uploaded your contact information to Facebook. Learn more",
                tappableTextAndUrlString: ["Learn more" : "https://www.facebook.com/policies_center"]
            )
        ]
    }

}
