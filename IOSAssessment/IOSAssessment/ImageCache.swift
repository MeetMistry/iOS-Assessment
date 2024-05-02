//
//  ImageCache.swift
//  IOSAssessment
//
//  Created by Meet Mistry on 1/05/24.
//

import Foundation
import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        // Load cache from disk on initialization
        self.loadCacheFromDisk()
    }
    
    private func cacheImagePath(forKey key: String) -> URL {
        let cacheDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let iOSAssessmentDirectoryURL = cacheDirectory.appendingPathComponent("iOSAssessment", isDirectory: true)
        return iOSAssessmentDirectoryURL.appendingPathComponent(key)
    }
    
    private func loadCacheFromDisk() {
        let cacheDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let iOSAssessmentDirectoryURL = cacheDirectory.appendingPathComponent("iOSAssessment", isDirectory: true)
        do {
            let cachedFiles = try FileManager.default.contentsOfDirectory(at: iOSAssessmentDirectoryURL, includingPropertiesForKeys: nil, options: [])
            for file in cachedFiles {
                if let data = try? Data(contentsOf: file), let image = UIImage(data: data) {
                    let key = file.lastPathComponent as NSString
                    cache.setObject(image, forKey: key)
                }
            }
        } catch {
            print("Error loading cache from disk: \(error.localizedDescription)")
        }
    }
    
    private func saveImageToDisk(_ image: UIImage, forKey key: String) {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! // the Documents directory is guaranteed to exist.
        let iOSAssessmentDirectoryURL = documentDirectoryURL.appendingPathComponent("iOSAssessment", isDirectory: true)

        // Ensure the directory exists, or create it if not
        do {
            try FileManager.default.createDirectory(at: iOSAssessmentDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating directory: \(error.localizedDescription)")
            return
        }
        
        let imgURL = iOSAssessmentDirectoryURL.appendingPathComponent(key)
        
        if let data = image.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: imgURL)
            } catch {
                print("Error saving image to disk: \(error.localizedDescription)")
            }
        }
    }
    
    func image(forKey key: String) -> UIImage? {
        guard let lastPathComponent = URL(string: key.removeSlashes())?.lastPathComponent else {
            print("Error: Unable to extract last path component from the URL.")
            return nil
        }
        
        if let cachedImage = cache.object(forKey: lastPathComponent as NSString) {
            return cachedImage
        }
        
        let imagePath = cacheImagePath(forKey: key.removeSlashes())
        if let data = try? Data(contentsOf: imagePath), let image = UIImage(data: data) {
            // Cache the image in memory
            cache.setObject(image, forKey: key.removeSlashes() as NSString)
            return image
        }
        
        return nil
    }
    
    func setImage(_ image: UIImage, forKey key: NSString) {
        // Cache the image in memory
        cache.setObject(image, forKey: key.removeSlashes())
        
        // Save the image to disk
        saveImageToDisk(image, forKey: key.removeSlashes() as String)
    }
}

extension String {
    func removeSlashes() -> String {
        return self.replacingOccurrences(of: "/", with: "")
    }
}

extension NSString {
    func removeSlashes() -> NSString {
        return self.replacingOccurrences(of: "/", with: "") as NSString
    }
}
