//
//  CharacterListViewModel.swift
//  TestApp
//

import Foundation
import Combine

final class CharacterListViewModel: ObservableObject {
    @Published private(set) var characters: [Character] = []
    
    private let apiClient = APIClient()
    
    init() {
        Task {
            await self.fetchCharacters()
        }
    }
    
    private func fetchCharacters() async {
//        apiClient.fetchCharacters { [weak self] result in
//            switch result {
//            case .success(let characterResponse):
//                self?.characters = characterResponse.results
//            case .failure(let error):
//                // TODO: Handle error
//                break
//            }
//        }
        do {
            let characterResponse = try await apiClient.fetchCharacters()
            await MainActor.run {
                self.characters = characterResponse.results
            }
        } catch {
            // TODO: Handle error
        }
    }
}
