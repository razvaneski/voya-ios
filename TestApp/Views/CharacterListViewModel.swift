//
//  CharacterListViewModel.swift
//  TestApp
//

import Foundation
import Combine

final class CharacterListViewModel: BaseViewModel<Any> {
    @Published private(set) var characters: [Character] = []
    
    private let apiClient = APIClient()
    
    override init() {
        super.init()
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
            await MainActor.run {
                self.errorSubject.send(error)
            }
        }
    }
}
