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
        
        zoomController = ImageZoomController(view: view, imageView: imageView)
    }
}
