//
//  CharacterView.swift
//  TestApp
//

import SwiftUI

struct CharacterView: View {
    @State private var image: UIImage?
    let character: Character
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 8) {
                Group {
                    Text(character.name)
                    Text(character.species)
                    Text("Origin: \(character.origin.name)")
                    Text("Location: \(character.location.name)")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.black)
            }
            
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
            }
        }
        .task {
            self.image = try? await DefaultImageDownloader.shared.downloadImage(from: URL(string: character.image))
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color.gray.opacity(0.3))
        .cornerRadius(20)
    }
}

#Preview {
    let character = Character(id: 0, name: "Name", species: "Species", image: "", type: "Type", origin: .init(name: "Test", url: ""), location: .init(name: "Test", url: "Test"))
    CharacterView(character: character)
}
