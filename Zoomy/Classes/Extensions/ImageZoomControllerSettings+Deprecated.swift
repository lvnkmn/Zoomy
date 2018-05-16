import Foundation
import InjectableLoggers

public extension ImageZoomControllerSettings {

    @available(*, deprecated, message: "Use `primaryColor` instead")
    var backgroundColorWhenContentIsSmallerThanViewItsDisplayedIn: UIColor {
        get {
            return primaryBackgroundColor
        }
        
        set {
            primaryBackgroundColor = newValue
        }
    }
    
    @available(*, deprecated, message: "Use `secundaryColor` instead")
    var backgroundWhenContentFillsViewItsDisplayedIn: UIColor {
        get {
            return secundaryBackgroundColor
        }
        
        set {
            secundaryBackgroundColor = newValue
        }
    }
    
    @available(*, deprecated, message: "Use `actionOnDoubleTapImageView` instead")
    public var actionOnDoubleTapImageVIew: Action & CanBeTriggeredByImageViewDoubleTap {
        get {
            return actionOnDoubleTapImageView
        }
        set {
            actionOnDoubleTapImageView = actionOnDoubleTapImageVIew
        }
    }
    
    @available(*, deprecated, message: "Use `with(primaryBackgroundColor: UIColor)` instead")
    func with(backgroundColorWhenContentIsSmallerThanViewItsDisplayedIn: UIColor) -> ImageZoomControllerSettings {
        return self.with(primaryBackgroundColor: backgroundColorWhenContentIsSmallerThanViewItsDisplayedIn)
    }
    
    
    func with(backgroundWhenContentFillsViewItsDisplayedIn: UIColor) -> ImageZoomControllerSettings {
        return self.with(secundaryBackgroundColor: backgroundWhenContentFillsViewItsDisplayedIn)
    }
    
    @available(*, deprecated, message: "Logger injection is not supported anymore. Use `shouldLogWarningsAndErrors` instead")
    public var logger: CanLogMessageAtLevel {
        get {
            return SimpleLogger(settings: .warningSettings)
        }
        set {}
    }
    
    @available(*, deprecated, message: "Logger injection is not supported anymore. Use `shouldLogWarningsAndErrors` instead")
    func with(logger: CanLogMessageAtLevel) -> Settings {
        return self
    }
}
