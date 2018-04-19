//  Created by Menno on 09/04/2018.
//

import Foundation

private let duration: TimeInterval = 0.5

internal func animate(_ animations:@escaping ()->()) {
    UIView.animate(withDuration: duration, animations: animations)
}

internal func animateSpring(withAnimations animations:@escaping ()->(), completion:((Bool)->())? = nil) {
    UIView.animate(withDuration: duration,
                   delay: 0,
                   usingSpringWithDamping: 0.66,
                   initialSpringVelocity: 0.5,
                   animations: animations,
                   completion: completion)
}
