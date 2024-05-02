//
//  ImageCollectionViewCell.swift
//  IOSAssessment
//
//  Created by Meet Mistry on 01/05/24.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: -
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: -
    // MARK: - Configure cell
    
    func configureCell(imageUrl: String) {
        imageView.image = UIImage(named: "placeholder")
        imageView.loadImage(from: imageUrl as NSString)
        imageView.contentMode = .center
    }
    
} // End of Class

extension UIImageView {
    func loadImage(from url: NSString) {
        
        if let cachedImage = ImageCache.shared.image(forKey: "\(url)") {
            self.image = cachedImage
            return
        }
        
        guard let imageUrl = URL(string: url as String) else { return }
        
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            if let error = error {
                print("Error, \(error.localizedDescription)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Error with response, unexpected status code: \(String(describing: response))")
                return
            }
            
            if let data = data {
                if let downloadedImage = UIImage(data: data) {
                    ImageCache.shared.setImage(downloadedImage, forKey: url)
                    DispatchQueue.main.async {
                        self.image = downloadedImage
                    }
                }
            }
        }.resume()
    }
}
