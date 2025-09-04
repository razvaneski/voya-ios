//
//  CharacterListViewModelTests.swift
//  TestAppTests
//

import Testing
@testable import TestApp

struct CharacterListViewModelTests {
    let apiClient = MockAPIClient()

    @Test("Initial state has no characters")
    func initialStateHasNoCharacters() {
        apiClient.shouldDelayResponse = true // Delay response to test initial state
        apiClient.shouldSucceed = true
        
        let viewModel = CharacterListViewModel(apiClient: apiClient)
        #expect(viewModel.characters.isEmpty)
    }

    @Test("Successfully successfully fetch characters on initialization")
    func successfullyFetchCharactersOnInitialization() async throws {
        apiClient.shouldDelayResponse = false
        apiClient.shouldSucceed = true
        
        let viewModel = CharacterListViewModel(apiClient: apiClient)
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1s
        
        #expect(viewModel.characters.count == 2)
        #expect(viewModel.characters.first?.name == "Morty Smith")
        #expect(viewModel.characters.last?.name == "Johnny Depp")
    }
    
    @Test("Handles errors from API calls")
    func successfullyHandlesErrors() async throws {
        apiClient.shouldSucceed = false
        apiClient.shouldDelayResponse = false
        
        let viewModel = CharacterListViewModel(apiClient: apiClient)
        var receivedError: Error? = nil
        let cancellable = viewModel.errorSubject
            .sink { error in
                receivedError = error
            }
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1s
        
        #expect(receivedError != nil)
        #expect(viewModel.characters.isEmpty)
        
        cancellable.cancel()
    }
}
