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
        
        addZoombehavior(for: imageView1, settings: .backgroundEnabledSettings)
        addZoombehavior(for: imageView2, settings: .backgroundEnabledSettings)
    }
}

extension NonCenteredImagesViewController: ZoomDelegate {
 
    func didBeginPresentingOverlay(for imageView: UIImageView) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func didEndPresentingOverlay(for imageView: UIImageView) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
