//
//  FakeAnimator.swift
//  Zoomy_Example
//
//  Created by Menno on 30/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Zoomy

class StubZoomyDelegate {
    
    var backgroundColorAnimator: CanAnimate?
    
    var dismissalAnimator: CanAnimate?
    
    var positionCorrectionAnimator: CanAnimate?
}

extension StubZoomyDelegate: Zoomy.Delegate {
    
    public func animator(for event: AnimationEvent) -> CanAnimate? {
        switch event {
        case .BackgroundColorChange:
            return backgroundColorAnimator
        case .OverlayDismissal:
            return dismissalAnimator
        case .PositionCorrection:
            return positionCorrectionAnimator
        }
    }
}
