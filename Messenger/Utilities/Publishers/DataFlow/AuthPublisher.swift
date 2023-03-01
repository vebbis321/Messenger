//
//  AuthPublisher.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 3/1/23.
//

import Combine
import FirebaseAuth

extension Publishers {
    struct AuthPublisher: Publisher {
        typealias Output = SessionState
        typealias Failure = Never

        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, SessionState == S.Input {
            let authSubscription = AuthSubscription(subscriber: subscriber)
            subscriber.receive(subscription: authSubscription)
        }
    }

    class AuthSubscription<S: Subscriber>: Subscription where S.Input == SessionState, S.Failure == Never {

        private var subscriber: S?
        private var handler: AuthStateDidChangeListenerHandle?

        init(subscriber: S) {
            self.subscriber = subscriber
            self.handler = Auth.auth().addStateDidChangeListener { auth, user in
                if let user = user {
                    _ = subscriber.receive(user.isEmailVerified ? .verified : .notVerified)
                } else {
                    _ = subscriber.receive(.notAuth)
                }
            }
        }

        func request(_ demand: Subscribers.Demand) { }
        func cancel() {
            subscriber = nil
            handler = nil
        }
    }
}
