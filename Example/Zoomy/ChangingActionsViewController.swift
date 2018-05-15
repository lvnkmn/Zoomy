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

    @IBOutlet weak var tapImageViewSegmentedControl: UISegmentedControl!
    @IBOutlet weak var doubleTapImageViewSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tapOverlaySegmentedControl: UISegmentedControl!
    @IBOutlet weak var scrollBounceTopSegmentedControl: UISegmentedControl!
    @IBOutlet weak var scrollBounceLeftSegmentedControl: UISegmentedControl!
    @IBOutlet weak var scrollBounceRightSegmentedControl: UISegmentedControl!
    @IBOutlet weak var scrollBounceBottomSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var imageView: UIImageView!
    
    private let overlayActions = [Action.none, Action.dismissOverlay]
    private let imageViewActions = [Action.none, Action.zoomToFit]
    
    var settings: Settings {
        var settings: Settings = .backgroundEnabledSettings
        
        settings.actionOnTapImageView = action(for: tapImageViewSegmentedControl) as? Action & CanBeTriggeredByImageViewTap ?? Action.none
        settings.actionOnDoubleTapImageVIew = action(for: doubleTapImageViewSegmentedControl) as? Action & CanBeTriggeredByImageViewDoubleTap ?? Action.none
        settings.actionOnTapOverlay = action(for: tapOverlaySegmentedControl) as? Action & CanBeTriggeredByOverlayTap ?? Action.none
        settings.actionOnScrollBounceTop = action(for: scrollBounceTopSegmentedControl) as? Action & CanBeTriggeredByScrollBounceTop ?? Action.none
        settings.actionOnScrollBounceLeft = action(for: scrollBounceLeftSegmentedControl) as? Action & CanBeTriggeredByScrollBounceLeft ?? Action.none
        settings.actionOnScrollBounceRight = action(for: scrollBounceRightSegmentedControl) as? Action & CanBeTriggeredByScrollBounceRight ?? Action.none
        settings.actionOnScrollBounceBottom = action(for: scrollBounceBottomSegmentedControl) as? Action & CanBeTriggeredByScrollBounceBottom ?? Action.none
        
        settings.secundaryBackgroundColor = UIColor.black.withAlphaComponent(0.6)
        
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
        return actions(for: segmentedControl)[segmentedControl.selectedSegmentIndex]
    }
    
    func actions(for segmentedControl: UISegmentedControl) -> [Action] {
        if imageViewSegmentedControls.contains(segmentedControl) {
            return imageViewActions
        } else if overlaySegmentedControls.contains(segmentedControl) {
            return overlayActions
        } else {
            return []
        }
    }
    
    var imageViewSegmentedControls: [UISegmentedControl] {
        return [tapImageViewSegmentedControl, doubleTapImageViewSegmentedControl]
    }
    
    var overlaySegmentedControls: [UISegmentedControl] {
        return [tapOverlaySegmentedControl, scrollBounceTopSegmentedControl, scrollBounceLeftSegmentedControl, scrollBounceRightSegmentedControl, scrollBounceBottomSegmentedControl]
    }
}
