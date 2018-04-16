//
//  TextViewImagesViewController.swift
//  Zoomy_Example
//
//  Created by Menno on 15/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Zoomy

class NonCenteredImagesViewController: UIViewController {

    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addZoombehavior(for: imageView1)
        addZoombehavior(for: imageView2)
        
        setupNavigationBarTogglingBehavior()
    }
}

//MARK: - ZoomDelegate
extension NonCenteredImagesViewController: ZoomDelegate {
    
    func didBeginPresentingOverlay(for imageView: UIImageView) {
        print("did begin presenting overlay for imageView: \(imageView)")
        imageZoomControllers.values.filter{ $0.imageView !== imageView }.forEach{ $0.dismissOverlay() }
    }
    
    func didEndPresentingOverlay(for imageView: UIImageView) {
        print("did end presenting overlay for imageView: \(imageView)")
    }
    
    func contentStateDidChange(from fromState: ImageZoomControllerContentState, to toState: ImageZoomControllerContentState) {
        print("contentState did change from state: \(fromState) to state: \(toState)")
    }
}

// MARK: - Toggling the navigation bar
extension NonCenteredImagesViewController {
    
    func setupNavigationBarTogglingBehavior() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBackground(with:))))
    }
    
    @objc func didTapBackground(with recognizer: UITapGestureRecognizer) {
        guard let navigationController = navigationController else { return }
        
        if navigationController.isNavigationBarHidden {
            navigationController.setNavigationBarHidden(false, animated: true)
        } else {
            navigationController.setNavigationBarHidden(true, animated: true)
        }
    }
}
