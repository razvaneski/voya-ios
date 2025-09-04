//
//  TestAppTests.swift
//  TestAppTests
//

import Testing
import UIKit
@testable import TestApp

struct ImageCacheTests {
    private func createTestImage(color: UIColor = .blue) -> UIImage {
        let size = CGSize(width: 2, height: 2)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
    
    
    @Test("Cache should start empty")
    func cacheStartsEmpty() async {
        let imageCache = await DefaultImageCache()
        
        let retrievedImage = await imageCache.getImage(forKey: "someKey")
        #expect(retrievedImage == nil)
    }

    @Test("Can store and retrieve image")
    func canStoreAndRetrieveImage() async {
        let imageCache = await DefaultImageCache()
        let testImage = createTestImage()
        let key = "someKey"
        
        await imageCache.setImage(testImage, key: key)
        let retrievedImage = await imageCache.getImage(forKey: key)
        
        #expect(retrievedImage != nil)
        #expect(retrievedImage == testImage)
    }
    
    @Test("Can overwrite existing image")
    func canOverwriteExistingImage() async {
        let imageCache = await DefaultImageCache()
        let firstImage = createTestImage(color: .blue)
        let secondImage = createTestImage(color: .red)
        let key = "someKey"
        
        await imageCache.setImage(firstImage, key: key)
        await imageCache.setImage(secondImage, key: key)
        let retrievedImage = await imageCache.getImage(forKey: key)
        
        #expect(retrievedImage != nil)
        #expect(retrievedImage == secondImage)
        #expect(retrievedImage != firstImage)
    }
    
    @Test("Can remove cache entry")
    func canRemoveCacheEntry() async {
        let imageCache = await DefaultImageCache()
        let testImage = createTestImage()
        let key = "someKey"
        
        await imageCache.setImage(testImage, key: key)
        await imageCache.setImage(nil, key: key)
        let retrievedImage = await imageCache.getImage(forKey: key)
        
        #expect(retrievedImage == nil)
    }
}

