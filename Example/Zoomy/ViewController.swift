//
//  ViewController.swift
//  Zoomy
//
//  Created by Menno Lovink on 04/09/2018.
//  Copyright (c) 2018 Menno Lovink. All rights reserved.
//

import UIKit
import Zoomy

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    
    private var zoomControllers = [UIView: ImageZoomController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        zoomControllers[imageView1] = ImageZoomController(view: view, imageView: imageView1, delegate: self)
        zoomControllers[imageView2] = ImageZoomController(view: view, imageView: imageView2, delegate: self)
    }
}

extension ViewController: ImageZoomControllerDelegate {

    func didEndZoomedState(for imageView: UIImageView) {
        // Re initialize an ImageZoomController to continue being able to zoom:
        zoomControllers[imageView] = ImageZoomController(view: view, imageView: imageView, delegate: self)
    }
}
