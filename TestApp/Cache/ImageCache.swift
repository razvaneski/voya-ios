//
//  ImageCache.swift
//  TestApp
//

import UIKit

@MainActor
final class DefaultImageCache: ImageCache {
    
    private var cache: [String: UIImage] = [:]

    func setImage(_ image: UIImage?, key: String) {
        cache[key] = image
    }

    func getImage(forKey key: String) -> UIImage? {
        return cache[key]
    }
}

@MainActor
protocol ImageCache {
    func setImage(_ image: UIImage?, key: String)
    func getImage(forKey key: String) -> UIImage?
}
