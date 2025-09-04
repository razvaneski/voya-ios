//
//  MockAPIClient.swift
//  TestAppTests
//
//  Created by Razvan Dumitriu on 04.09.2025.
//

import Foundation
@testable import TestApp

class MockAPIClient: APIClientProtocol {
    var shouldSucceed = true
    var shouldDelayResponse = false
    var mockError: Error = APIClientError.httpCodeError(code: 500)
    
    var mockCharacter = TestApp.Character(
        id: 0,
        name: "Morty Smith",
        species: "Human",
        image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
        type: "",
        origin: .init(name: "Earth", url: "https://rickandmortyapi.com/api/location/1"),
        location: .init(name: "Earth", url: "https://rickandmortyapi.com/api/location/20")
    )
    
    var mockCharactersResponse = TestApp.CharacterResponse(
        info: .init(count: 826, pages: 42, next: "https://rickandmortyapi.com/api/character/?page=2", prev: nil),
        results: [
            TestApp.Character(
                id: 0,
                name: "Morty Smith",
                species: "Human",
                image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
                type: "",
                origin: .init(name: "Earth", url: "https://rickandmortyapi.com/api/location/1"),
                location: .init(name: "Earth", url: "https://rickandmortyapi.com/api/location/20")
            ),
            TestApp.Character(
                id: 1,
                name: "Johnny Depp",
                species: "Human",
                image: "https://rickandmortyapi.com/api/character/avatar/183.jpeg",
                type: "",
                origin: .init(name: "Earth", url: "https://rickandmortyapi.com/api/location/1"),
                location: .init(name: "Earth", url: "https://rickandmortyapi.com/api/location/20")
            )
        ]
    )
    
    func fetchCharacters() async throws -> TestApp.CharacterResponse {
        if shouldDelayResponse {
            try await Task.sleep(for: .seconds(3))
        }
        if shouldSucceed {
            return mockCharactersResponse
        } else {
            throw mockError
        }
    }
    
    func fetchCharacter(id: Int) async throws -> TestApp.Character {
        if shouldDelayResponse {
            try await Task.sleep(for: .seconds(3))
        }
        if shouldSucceed {
            return mockCharacter
        } else {
            throw mockError
        }
    }
}
