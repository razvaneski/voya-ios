//
//  ImageDownloader.swift
//  TestApp
//

import UIKit

enum ImageDownloaderError: Error {
    case requestError
    case invalidUrl
    case invalidResponse
    case invalidImageData
}

protocol ImageDownloader {
    func downloadImage(from url: URL?) async throws -> UIImage
}

final class DefaultImageDownloader: ImageDownloader {
    static let shared = DefaultImageDownloader()
    
    @MainActor
    private let cache = DefaultImageCache()
    
    func downloadImage(from url: URL?) async throws -> UIImage {
        guard let url else {
            throw ImageDownloaderError.invalidUrl
        }
        
        if let cachedImage = await cache.getImage(forKey: url.absoluteString) {
            return cachedImage
        }
        
        let (data, response) = try await URLSession.testApp.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ImageDownloaderError.invalidResponse
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw ImageDownloaderError.requestError
        }
        
        guard let uiImage = UIImage(data: data) else {
            throw ImageDownloaderError.invalidImageData
        }
        
        await cache.setImage(uiImage, key: url.absoluteString)
        
        return uiImage
    }
}
