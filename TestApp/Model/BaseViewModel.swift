//
//  BaseViewModel.swift
//  TestApp
//
//  Created by Razvan Dumitriu on 04.09.2025.
//

import Foundation
import Combine

class BaseViewModel<Event: Any>: ObservableObject {
    @Published var errorSubject = PassthroughSubject<Error, Never>()
    @Published var eventSubject = PassthroughSubject<Event, Never>()
}
