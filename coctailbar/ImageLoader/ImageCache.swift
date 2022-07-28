//
//  ImageCache.swift
//  coctailbar
//
//  Created by Szymon Tamborski on 27/07/2022.
//

import Foundation
import UIKit

protocol ImageCacheProtocol {
    /// Access the walue associated with the given key for reading and writing
    subscript(_ url: URL) -> UIImage? { get set }
    /// Returns image associated with a given url
    func image(for url: URL) -> UIImage?
    /// Inserts the image of the specified url in the cache
    func insertImage(_ image: UIImage?, for url: URL)
    /// Remove the image of the specified url in the cache
    func removeImage(for url: URL)
    /// Remove all images from cache
    func removeAllImages()
}

final class ImageCache {
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = CacheConfig.countLimit
        return cache
    }()
    
    private lazy var decodedImageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = CacheConfig.memoryLimit
        return cache
    }()
}

extension ImageCache: ImageCacheProtocol {
    subscript(_ key: URL) -> UIImage? {
        get {
            return image(for: key)
        }
        set {
            insertImage(newValue, for: key)
        }
    }
    
    func image(for url: URL) -> UIImage? {
        if let decodedImage = decodedImageCache.object(forKey: url as AnyObject) as? UIImage {
            return decodedImage
        }
        
        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
            let decodedImage = image.decodedImage()
            decodedImageCache.setObject(decodedImage as AnyObject, forKey: url as AnyObject, cost: decodedImage.diskSize)
            imageCache.setObject(image, forKey: url as AnyObject)
            return image
        }
        
        return nil
    }
    
    func insertImage(_ image: UIImage?, for url: URL) {
        guard let image = image else { return removeImage(for: url) }
        let decompressedImage = image.decodedImage()
        
        imageCache.setObject(image, forKey: url as AnyObject, cost: 1)
        decodedImageCache.setObject(decompressedImage as AnyObject, forKey: url as AnyObject, cost: decompressedImage.diskSize)
    }
    
    func removeImage(for url: URL) {
        imageCache.removeObject(forKey: url as AnyObject)
        decodedImageCache.removeObject(forKey: url as AnyObject)
    }
    
    func removeAllImages() {
        imageCache.removeAllObjects()
        decodedImageCache.removeAllObjects()
    }
}

fileprivate extension UIImage {
    
    /// Returns decompressed and rendered image. Makes the availability to predecode and prerender the image before assigning it to image frame.
    func decodedImage() -> UIImage {
        guard let cgImage = cgImage else { return self }
        let size = CGSize(width: cgImage.width, height: cgImage.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: cgImage.bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
        guard let decodedImage = context?.makeImage() else { return self }
        return UIImage(cgImage: decodedImage, scale: self.scale, orientation: self.imageOrientation)
    }
    
    var diskSize: Int {
        guard let cgImage = cgImage else { return 0 }
        return cgImage.bytesPerRow * cgImage.height
    }
}
