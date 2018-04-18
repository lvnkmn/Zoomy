//  Created by Menno on 09/04/2018.
//

import Foundation

public extension ImageZoomControllerSettings {

    @available(*, deprecated, message: "Use primaryColor instead")
    var backgroundColorWhenContentIsSmallerThanViewItsDisplayedIn: UIColor {
        get {
            return primaryBackgroundColor
        }
        
        set {
            primaryBackgroundColor = newValue
        }
    }
    
    @available(*, deprecated, message: "Use secundaryColor instead")
    var backgroundWhenContentFillsViewItsDisplayedIn: UIColor {
        get {
            return secundaryBackgroundColor
        }
        
        set {
            secundaryBackgroundColor = newValue
        }
    }
    
    @available(*, deprecated, message: "Use with(primaryBackgroundColor: UIColor) instead")
    func with(backgroundColorWhenContentIsSmallerThanViewItsDisplayedIn: UIColor) -> ImageZoomControllerSettings {
        return self.with(primaryBackgroundColor: backgroundColorWhenContentIsSmallerThanViewItsDisplayedIn)
    }
    
    @available(*, deprecated, message: "Use with(secundaryBackgroundColor: UIColor) instead")
    func with(backgroundWhenContentFillsViewItsDisplayedIn: UIColor) -> ImageZoomControllerSettings {
        return self.with(secundaryBackgroundColor: backgroundWhenContentFillsViewItsDisplayedIn)
    }
}
