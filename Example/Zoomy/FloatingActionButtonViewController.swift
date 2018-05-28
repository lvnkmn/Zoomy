//
//  FloatingActionButtonViewController.swift
//  Zoomy_Example
//
//  Created by Menno on 28/05/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Zoomy

class FloatingActionButtonViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dismissButton.alpha = 0
        
        addZoombehavior(for: imageView, below: dismissButton)
    }
    
    @IBAction func didPressDismissButton(_ sender: UIButton) {
        imageZoomControllers[imageView]?.dismissOverlay()
    }
}

extension FloatingActionButtonViewController: Zoomy.Delegate {
    
    func didBeginPresentingOverlay(for imageView: UIImageView) {
        UIView.animate(withDuration: 1) {
            self.dismissButton.alpha = 1
        }
    }
    
    func didEndPresentingOverlay(for imageView: UIImageView) {
        UIView.animate(withDuration: 0.5) {
            self.dismissButton.alpha = 0
        }
    }
}
