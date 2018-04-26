//
//  ChangeableActionsViewController.swift
//  Zoomy_Example
//
//  Created by Menno on 25/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Zoomy

class ChangingActionsViewController: UIViewController {

    @IBOutlet weak var tapOverlaySegmentedControl: UISegmentedControl!
    @IBOutlet weak var scrollBounceTopSegmentedControl: UISegmentedControl!
    @IBOutlet weak var scrollBounceLeftSegmentedControl: UISegmentedControl!
    @IBOutlet weak var scrollBounceRightSegmentedControl: UISegmentedControl!
    @IBOutlet weak var scrollBounceBottomSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var settings: Settings {
        var settings: Settings = .backgroundEnabledSettings
        
        settings.actionOnTapOverlay = action(for: tapOverlaySegmentedControl) as? Action & CanBeTriggeredByOverlayTap ?? Action.none
        settings.actionOnScrollBounceTop = action(for: scrollBounceTopSegmentedControl) as? Action & CanBeTriggeredByScrollBounceTop ?? Action.none
        settings.actionOnScrollBounceLeft = action(for: scrollBounceLeftSegmentedControl) as? Action & CanBeTriggeredByScrollBounceLeft ?? Action.none
        settings.actionOnScrollBounceRight = action(for: scrollBounceRightSegmentedControl) as? Action & CanBeTriggeredByScrollBounceRight ?? Action.none
        settings.actionOnScrollBounceBottom = action(for: scrollBounceBottomSegmentedControl) as? Action & CanBeTriggeredByScrollBounceBottom ?? Action.none
        
        return settings
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addZoombehavior(for: imageView, settings: settings)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        imageZoomControllers.values.forEach{ $0.dismissOverlay() }
    }
    
    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        imageZoomControllers[imageView]?.settings = settings
    }
}

private extension ChangingActionsViewController {
    
    func action(for segmentedControl: UISegmentedControl) -> Action {
        let actions = [Action.none, Action.dismissOverlay]
        return actions[segmentedControl.selectedSegmentIndex]
    }
}
