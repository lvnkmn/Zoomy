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
    
    private let contentModeSelector = UISegmentedControl()
    private let supportedContentModes: [UIView.ContentMode] = [.scaleAspectFill, .scaleAspectFit, .scaleToFill]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
 
        addContentModeSelector()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return treeImages.count * 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                            for: indexPath) as? CollectionViewCellWithImage else {
            return UICollectionViewCell()
        }
    
        cell.imageView.image = treeImages[indexPath.item % treeImages.count]
        cell.imageView.contentMode = supportedContentModes[contentModeSelector.selectedSegmentIndex]
        
        addZoombehavior(for: cell.imageView,
                        settings: Settings.instaZoomSettings.with(actionOnTapOverlay: Action.dismissOverlay))
        
        return cell
    }
}

private extension SquaredImagesCollectionViewController {
    
    func addContentModeSelector() {
        supportedContentModes.forEach { (contentMode) in
            contentModeSelector.insertSegment(withTitle: String(describing: contentMode),
                                              at: contentModeSelector.numberOfSegments,
                                              animated: false)
        }
        
        view.addSubview(contentModeSelector)
        
        contentModeSelector.selectedSegmentIndex = 0
        contentModeSelector.addTarget(self, action: #selector(contentModeSelectorValueDidChange), for: .valueChanged)
        contentModeSelector.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.removeConstraints(collectionView.constraints)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentModeSelector.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            contentModeSelector.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 8),
            contentModeSelector.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.topAnchor.constraint(equalTo: contentModeSelector.bottomAnchor, constant: 8),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        
    }
    
    @objc func contentModeSelectorValueDidChange() {
        collectionView.reloadData()
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
    
    func didBeginPresentingOverlay(for imageView: Zoomable) {
        collectionView.isScrollEnabled = false
    }
    
    func didEndPresentingOverlay(for imageView: Zoomable) {
        collectionView.isScrollEnabled = true
    }
}
