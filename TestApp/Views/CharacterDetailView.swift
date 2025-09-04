//
//  CharacterDetailView.swift
//  TestApp
//
//  Created by Razvan Dumitriu on 04.09.2025.
//

import SwiftUI

struct CharacterDetailView: View {
    @StateObject private var viewModel = CharacterDetailViewModel(apiClient: APIClient())
    let characterId: Int
    
    var body: some View {
        ZStack {
            if let character = viewModel.character {
                CharacterView(character: character)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .task {
            await viewModel.fetchCharacter(id: characterId)
        }
        .accessibilityIdentifier("CharacterDetailView")
        .withErrorHandling(viewModel.errorSubject)
    }
}
