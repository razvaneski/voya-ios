//
//  CharacterListView.swift
//  TestApp
//


import SwiftUI

struct CharacterListView: View {
    @StateObject private var viewModel = CharacterListViewModel(apiClient: APIClient())
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 16) {
                ForEach(viewModel.characters) { character in
                    NavigationLink {
                        CharacterDetailView(characterId: character.id)
                    } label: {
                        CharacterView(character: character)
                    }
                }
            }
            .padding(16)
        }
        .withErrorHandling(viewModel.errorSubject)
    }
}

#Preview {
    CharacterListView()
}
