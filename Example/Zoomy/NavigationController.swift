//
//  NavigationController.swift
//  Zoomy_Example
//
//  Created by Menno on 16/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let alertController = UIAlertController(title: "Shake to toggle navigationbar",
                                                message: "You can shake your device to toggle the navigationbar in order to see the examples with and without it.",
                                                preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
        becomeFirstResponder()
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        
        toggleNavigationBar()
    }
    
    func toggleNavigationBar() {
        if isNavigationBarHidden {
            setNavigationBarHidden(false, animated: true)
        } else {
            setNavigationBarHidden(true, animated: true)
        }
    }
}
