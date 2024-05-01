//
//  ImageCollectionViewCell.swift
//  IOSAssessment
//
//  Created by Meet Mistry on 01/05/24.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: -
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: -
    // MARK: - Configure cell
    
    func configureCell(image: UIImage) {
        imageView.image = image
        imageView.contentMode = .center
    }
    
} // End of Class
