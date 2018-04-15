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
    
    var zoomControllers = [UIImageView: ImageZoomController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        zoomControllers[imageView1] = ImageZoomController(view: view, imageView: imageView1, delegate: self, settings: .backgroundEnabledSettings)
        zoomControllers[imageView2] = ImageZoomController(view: view, imageView: imageView2, delegate: self, settings: .backgroundEnabledSettings)
    }
}

extension NonCenteredImagesViewController: ImageZoomControllerDelegate {
 
    func didBeginPresentingOverlay(for imageView: UIImageView) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func didEndPresentingOverlay(for imageView: UIImageView) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
