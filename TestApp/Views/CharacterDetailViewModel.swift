//
//  CharacterDetailViewModel.swift
//  TestApp
//
//  Created by Razvan Dumitriu on 04.09.2025.
//

import Foundation

class CharacterDetailViewModel: BaseViewModel<Any> {
    @Published private(set) var character: Character?
    private let apiClient: APIClientProtocol
    
    init(character: Character? = nil, apiClient: APIClientProtocol) {
        self.character = character
        self.apiClient = apiClient
    }
    
    func fetchCharacter(id: Int) async {
        do {
            let character = try await apiClient.fetchCharacter(id: id)
            await MainActor.run {
                self.character = character
            }
        } catch {
            await MainActor.run {
                self.errorSubject.send(error)
            }
        }
    }
}
