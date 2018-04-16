//
//  MultipleImagesViewController.swift
//  Zoomy_Example
//
//  Created by Menno on 13/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Zoomy

class StackViewImagesViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeStoryBoardImageView()
        scrollView.delegate = self
        
        Images.trees.forEach { (image) in
            let imageView = UIImageView(image: image)
            imageView.addImageAspectRatioContraint()
            self.stackView.addArrangedSubview(imageView)
            
            addZoombehavior(for: imageView, settings: .backgroundEnabledSettings)
        }
    }

    func removeStoryBoardImageView() {
        stackView.removeArrangedSubview(stackView.arrangedSubviews[0])
    }
}

//MARK: - ZoomDelegate
extension StackViewImagesViewController: ZoomDelegate {
    
    func didBeginPresentingOverlay(for imageView: UIImageView) {
        print("did begin presenting overlay for imageView: \(imageView)")
        scrollView.isScrollEnabled = false
    }
    
    func didEndPresentingOverlay(for imageView: UIImageView) {
        print("did end presenting overlay for imageView: \(imageView)")
        scrollView.isScrollEnabled = true
    }
    
    func contentStateDidChange(from fromState: ImageZoomControllerContentState, to toState: ImageZoomControllerContentState) {
        print("contentState did change from state: \(fromState) to state: \(toState)")
    }
}

// MARK: - Toggling the navigation bar
extension StackViewImagesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let navigationController = navigationController else { return }
        if scrollView.contentOffset.y > 0 {
            if !navigationController.isNavigationBarHidden {
                navigationController.setNavigationBarHidden(true, animated: true)
            }
        } else {
            if navigationController.isNavigationBarHidden {
                navigationController.setNavigationBarHidden(false, animated: true)
            }
        }
    }
}
