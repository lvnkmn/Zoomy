//
//  CollectionViewController.swift
//  Zoomy_Example
//
//  Created by menno lovink on 11/07/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Zoomy

private let reuseIdentifier = "CellID"

class SquaredImagesCollectionViewController: UICollectionViewController {

    let treeImages = Images.trees
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return treeImages.count * 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                            for: indexPath) as? CollectionViewCellWithImage else {
            return UICollectionViewCell()
        }
    
        cell.imageView.image = treeImages[indexPath.item % treeImages.count]
        cell.imageView.contentMode = .scaleAspectFill
        
        addZoombehavior(for: cell.imageView,
                        settings: Settings().with(actionOnTapOverlay: Action.dismissOverlay))
        
        return cell
    }
}

extension SquaredImagesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let twoImagesPerRowAmount = (view.frame.size.width / 2)
        return CGSize(width: twoImagesPerRowAmount,
                      height: twoImagesPerRowAmount)
    }
}

extension SquaredImagesCollectionViewController: Zoomy.Delegate {
    
    func didBeginPresentingOverlay(for imageView: UIImageView) {
        collectionView.isScrollEnabled = false
    }
    
    func didEndPresentingOverlay(for imageView: UIImageView) {
        collectionView.isScrollEnabled = true
    }
}
