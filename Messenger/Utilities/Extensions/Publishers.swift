//
//  Publishers.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 3/1/23.
//

import Foundation
import Combine

extension Publishers {
    func isSubjectEmpty<T: CurrentValueSubject<String, Never>>() {
            T
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { $0.isEmpty }
            .eraseToAnyPublisher()
    }
}
