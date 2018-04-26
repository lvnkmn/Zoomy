//
//  FakeAnimator.swift
//  Zoomy_Example
//
//  Created by Menno on 30/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Zoomy

class FakeAnimator {}

extension FakeAnimator: CanAnimate {
    
    func animate(_ animations:@escaping ()->(), completion:(()->())?) {
        completion?()
    }
}

extension CanAnimate {
    
    var asFakeAnimator: FakeAnimator? {
        return self as? FakeAnimator
    }
}
