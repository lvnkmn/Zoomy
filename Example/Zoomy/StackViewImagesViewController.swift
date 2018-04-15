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
    
    var zoomControllers = [UIView: ImageZoomController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeStoryBoardImageView()
        
        Images.trees.forEach { (image) in
            let imageView = UIImageView(image: image)
            imageView.addImageAspectRatioContraint()
            self.stackView.addArrangedSubview(imageView)
            
            zoomControllers[imageView] = ImageZoomController(view: view, imageView: imageView, delegate: self, settings: .backgroundEnabledSettings)
        }
    }

    func removeStoryBoardImageView() {
        stackView.removeArrangedSubview(stackView.arrangedSubviews[0])
    }
}

extension StackViewImagesViewController: ImageZoomControllerDelegate {
    
    func didBeginPresentingOverlay(for imageView: UIImageView) {
        scrollView.isScrollEnabled = false
    }
    
    func didEndPresentingOverlay(for imageView: UIImageView) {
        scrollView.isScrollEnabled = true
    }
}
