//
//  CharacterDetailView.swift
//  TestApp
//
//  Created by Razvan Dumitriu on 04.09.2025.
//

import SwiftUI

class CharacterDetailViewModel: ObservableObject {
    @Published private(set) var character: Character?
    
    private let apiClient = APIClient()
    
    func fetchCharacter(id: Int) async {
        do {
            let character = try await apiClient.fetchCharacter(id: id)
            await MainActor.run {
                self.character = character
            }
        } catch {
            // TODO: handle error
        }
    }
}

struct CharacterDetailView: View {
    @StateObject private var viewModel = CharacterDetailViewModel()
    let characterId: Int
    
    var body: some View {
        ZStack {
            if let character = viewModel.character {
                CharacterView(character: character)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .task {
            await viewModel.fetchCharacter(id: characterId)
        }
    }
}
