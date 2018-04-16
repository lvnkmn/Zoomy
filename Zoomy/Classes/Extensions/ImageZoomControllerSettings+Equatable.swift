//  Created by Menno on 09/04/2018.
//

import Foundation

extension ImageZoomControllerSettings: Equatable {
    
    public static func ==(lhs: ImageZoomControllerSettings, rhs: ImageZoomControllerSettings) -> Bool {
        return  lhs.zoomCancelingThreshold == rhs.zoomCancelingThreshold &&
                lhs.maximumZoomScale == rhs.maximumZoomScale &&
                lhs.isEnabled == rhs.isEnabled &&
                lhs.shouldDisplayBackground == rhs.shouldDisplayBackground &&
                lhs.backgroundColorWhenContentIsSmallerThanViewItsDisplayedIn == rhs.backgroundColorWhenContentIsSmallerThanViewItsDisplayedIn &&
                lhs.backgroundWhenContentFillsViewItsDisplayedIn == rhs.backgroundWhenContentFillsViewItsDisplayedIn
    }
}
