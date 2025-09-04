//
//  CharacterViewUITests.swift
//  TestAppTests
//
//  Created by Razvan Dumitriu on 04.09.2025.
//

import SnapshotTesting
import SwiftUI
import Testing
@testable import TestApp

@MainActor
struct CharacterViewUITests {
    let character = Character(
        id: 0,
        name: "Morty Smith",
        species: "Human",
        image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
        type: "",
        origin: .init(name: "Earth", url: "https://rickandmortyapi.com/api/location/1"),
        location: .init(name: "Earth", url: "https://rickandmortyapi.com/api/location/20")
    )
    
    @Test
    func characterViewSnapshot() async throws {
        let characterView = CharacterView(character: character)
        let view: UIView = UIHostingController(rootView: characterView).view
        try await Task.sleep(for: .seconds(3))
        assertSnapshot(of: view, as: .image(size: view.intrinsicContentSize))
    }
}
