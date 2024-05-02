//
//  ViewController.swift
//  IOSAssessment
//
//  Created by Meet Mistry on 01/05/24.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: -
    // MARK: - Outlets
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    // MARK: -
    // MARK: - Variable Declaration
    
    fileprivate let minimumInterItemSpacing = 4.0
    fileprivate let minimumLineSpacing = 8.0
    fileprivate let viewModel = ViewControllerViewModel()
    fileprivate var listOfImages: [ImageModel] = []

    // MARK: -
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getImagesFromServer() { [weak self] images in
            guard let self else { return }
            listOfImages = images
            DispatchQueue.main.async {
                self.imageCollectionView.reloadData()
            }
        }
    }

    // MARK: -
    // MARK: - Setup
    
    fileprivate func setup() {
        imageCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = minimumLineSpacing
        layout.minimumInteritemSpacing = minimumInterItemSpacing
        
        imageCollectionView.setCollectionViewLayout(layout, animated: true)
    }

} // End of Class

// MARK: -
// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        let thumbnail = listOfImages[indexPath.item].thumbnail
        let imageUrl = thumbnail.domain + "/" + thumbnail.basePath + "/0/" + thumbnail.key
        cell.configureCell(imageUrl: imageUrl)
        return cell
    }
    
} // End of Extension

// MARK: -
// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width / 3 - CGFloat(minimumInterItemSpacing)
        return CGSize(width: availableWidth, height: availableWidth)
    }
    
} // End of Extension
