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

extension StackViewImagesViewController: ZoomDelegate {
    
    func didBeginPresentingOverlay(for imageView: UIImageView) {
        scrollView.isScrollEnabled = false
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func didEndPresentingOverlay(for imageView: UIImageView) {
        scrollView.isScrollEnabled = true
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
