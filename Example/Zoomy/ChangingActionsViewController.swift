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
    @IBOutlet weak var doubleTapOverlaySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tapBackgroundViewSegmentedControl: UISegmentedControl!
    @IBOutlet weak var doubleTapBackgroundViewSegmentedControl: UISegmentedControl!
    @IBOutlet weak var scrollBounceTopSegmentedControl: UISegmentedControl!
    @IBOutlet weak var scrollBounceLeftSegmentedControl: UISegmentedControl!
    @IBOutlet weak var scrollBounceRightSegmentedControl: UISegmentedControl!
    @IBOutlet weak var scrollBounceBottomSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var imageView: UIImageView!
    
    private lazy var actionsForSegmentedControl: [UISegmentedControl : [Action]] = [    tapImageViewSegmentedControl:               [.none, .zoomIn, .zoomToFit],
                                                                                        doubleTapImageViewSegmentedControl:         [.none, .zoomIn, .zoomToFit],
                                                                                        tapOverlaySegmentedControl:                 [.none, .zoomIn, .dismissOverlay],
                                                                                        doubleTapOverlaySegmentedControl:           [.none, .zoomIn, .dismissOverlay],
                                                                                        tapBackgroundViewSegmentedControl:          [.none, .dismissOverlay],
                                                                                        doubleTapBackgroundViewSegmentedControl:    [.none, .dismissOverlay],
                                                                                        scrollBounceTopSegmentedControl:            [.none, .dismissOverlay],
                                                                                        scrollBounceLeftSegmentedControl:           [.none, .dismissOverlay],
                                                                                        scrollBounceRightSegmentedControl:          [.none, .dismissOverlay],
                                                                                        scrollBounceBottomSegmentedControl:         [.none, .dismissOverlay]]
    
    var settings: Settings {
        var settings: Settings = .backgroundEnabledSettings
        
        settings.actionOnTapImageView = action(for: tapImageViewSegmentedControl) as? Action & CanBeTriggeredByImageViewTap ?? Action.none
        settings.actionOnDoubleTapImageView = action(for: doubleTapImageViewSegmentedControl) as? Action & CanBeTriggeredByImageViewDoubleTap ?? Action.none
        settings.actionOnTapOverlay = action(for: tapOverlaySegmentedControl) as? Action & CanBeTriggeredByOverlayTap ?? Action.none
        settings.actionOnDoubleTapOverlay = action(for: doubleTapOverlaySegmentedControl) as? Action & CanBeTriggeredByOverlayDoubleTap ?? Action.none
        settings.actionOnTapBackgroundView = action(for: tapBackgroundViewSegmentedControl) as? Action & CanBeTriggeredByBackgroundViewTap ?? Action.none
        settings.actionOnDoubleTapBackgroundView = action(for: doubleTapBackgroundViewSegmentedControl) as? Action & CanBeTriggeredByBackgroundDoubleTap ?? Action.none
        settings.actionOnScrollBounceTop = action(for: scrollBounceTopSegmentedControl) as? Action & CanBeTriggeredByScrollBounceTop ?? Action.none
        settings.actionOnScrollBounceLeft = action(for: scrollBounceLeftSegmentedControl) as? Action & CanBeTriggeredByScrollBounceLeft ?? Action.none
        settings.actionOnScrollBounceRight = action(for: scrollBounceRightSegmentedControl) as? Action & CanBeTriggeredByScrollBounceRight ?? Action.none
        settings.actionOnScrollBounceBottom = action(for: scrollBounceBottomSegmentedControl) as? Action & CanBeTriggeredByScrollBounceBottom ?? Action.none
        
        settings.secundaryBackgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        return settings
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControls()
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
        return actionsForSegmentedControl[segmentedControl]?[segmentedControl.selectedSegmentIndex] ?? .none
    }
    
    func setupSegmentedControls() {
        actionsForSegmentedControl.keys.forEach({ $0.removeAllSegments() })
        actionsForSegmentedControl.forEach { (arg) in
            let (segmentedControl, actions) = arg
            actions.enumerated().forEach({ (arg) in
                let (index, action) = arg
                segmentedControl.insertSegment(withTitle: String(describing: action), at: index, animated: false)
            })
        }
        actionsForSegmentedControl.keys.forEach({ $0.selectedSegmentIndex = 0; $0.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged) })
    }
}
