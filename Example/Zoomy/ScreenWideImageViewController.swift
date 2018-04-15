//
//  ViewController.swift
//  Zoomy
//
//  Created by Menno Lovink on 04/09/2018.
//  Copyright (c) 2018 Menno Lovink. All rights reserved.
//

import UIKit
import Zoomy

class ScreenWideImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    private var zoomController: ImageZoomController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        zoomController = ImageZoomController(view: view, imageView: imageView, delegate: self)
    }
}

extension ScreenWideImageViewController: ImageZoomControllerDelegate {
    
    func didBeginPresentingOverlay(for imageView: UIImageView) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func didEndPresentingOverlay(for imageView: UIImageView) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
