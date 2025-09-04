//
//  APIClient.swift
//  TestApp
//

import Foundation

enum APIClientError: Error {
    case httpCodeError(code: Int)
    case invalidResponse
    case decodingError
}


protocol APIClientProtocol: AnyObject {
    func fetchCharacters() async throws -> CharacterResponse
    func fetchCharacter(id: Int) async throws -> Character
}

final class APIClient: APIClientProtocol {
    private let baseURL = URL(string: "https://rickandmortyapi.com/api")!
    
    private var charactersEndpointURL: URL {
        return baseURL.appendingPathComponent("character")
    }

    /// Retrieves a list of characters from https://rickandmortyapi.com/api/character
    func fetchCharacters(completion: @escaping (Result<CharacterResponse, Error>) -> Void) {
        let task = URLSession.testApp.dataTask(with: charactersEndpointURL) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let data else { return }
                let decoder = JSONDecoder()
                let characters = try? decoder.decode(CharacterResponse.self, from: data)
                completion(.success(characters ?? .init(info: .init(count: 0, pages: 0, next: nil, prev: nil), results: [])))
            }
        }
        task.resume()
    }
    
    func fetchCharacters() async throws -> CharacterResponse {
        let (data, response) = try await URLSession.testApp.data(from: charactersEndpointURL)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIClientError.invalidResponse
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw APIClientError.httpCodeError(code: httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        guard let characterResponse = try? decoder.decode(CharacterResponse.self, from: data) else {
            throw APIClientError.decodingError
        }
        
        return characterResponse
    }
    
    func fetchCharacter(id: Int) async throws -> Character {
        let characterUrl = baseURL.appendingPathComponent("character/\(id)")
        let (data, response) = try await URLSession.testApp.data(from: characterUrl)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIClientError.invalidResponse
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw APIClientError.httpCodeError(code: httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        guard let character = try? decoder.decode(Character.self, from: data) else {
            throw APIClientError.decodingError
        }
        
        return character
    }
}
