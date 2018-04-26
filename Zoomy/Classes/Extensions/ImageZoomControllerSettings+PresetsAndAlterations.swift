import Foundation

// MARK: Presets
public extension ImageZoomControllerSettings {
    static var defaultSettings: Settings {
        return Settings()
    }
    
    static var backgroundEnabledSettings: Settings {
        return defaultSettings.with(shouldDisplayBackground: true)
    }
    
    static var noZoomCancellingSettings: Settings {
        return defaultSettings.with(zoomCancelingThreshold: 1)
    }
}

//MARK: Alterations
public extension ImageZoomControllerSettings {
    
    func with(zoomCancelingThreshold: ImageViewScale) -> Settings {
        var settings = self
        settings.zoomCancelingThreshold = zoomCancelingThreshold
        return settings
    }
    
    func with(maximumZoomScale: ImageScale) -> Settings {
        var settings = self
        settings.maximumZoomScale = maximumZoomScale
        return settings
    }
    
    func with(isEnabled: Bool) -> Settings {
        var settings = self
        settings.isEnabled = isEnabled
        return settings
    }
    
    func with(shouldDisplayBackground: Bool) -> Settings {
        var settings = self
        settings.shouldDisplayBackground = shouldDisplayBackground
        return settings
    }
    
    func with(primaryBackgroundColor: UIColor) -> Settings {
        var settings = self
        settings.primaryBackgroundColor = primaryBackgroundColor
        return settings
    }
    
    func with(secundaryBackgroundColor: UIColor) -> Settings {
        var settings = self
        settings.secundaryBackgroundColor = secundaryBackgroundColor
        return settings
    }
    
    func with(neededTranslationToDismissOverlayOnScrollBounce: CGFloat) -> Settings {
        var settings = self
        settings.neededTranslationToDismissOverlayOnScrollBounce = neededTranslationToDismissOverlayOnScrollBounce
        return settings
    }
    
    func with(actionOnTapOverlay: Action & CanBeTriggeredByOverlayTap) -> Settings {
        var settings = self
        settings.actionOnTapOverlay = actionOnTapOverlay
        return settings
    }
    
    func with(actionOnScrollBounceTop: Action & CanBeTriggeredByScrollBounceTop) -> Settings {
        var settings = self
        settings.actionOnScrollBounceTop = actionOnScrollBounceTop
        return settings
    }
    
    func with(actionOnScrollBounceLeft: Action & CanBeTriggeredByScrollBounceLeft) -> Settings {
        var settings = self
        settings.actionOnScrollBounceLeft = actionOnScrollBounceLeft
        return settings
    }
    
    func with(actionOnScrollBounceRight: Action & CanBeTriggeredByScrollBounceRight) -> Settings {
        var settings = self
        settings.actionOnScrollBounceRight = actionOnScrollBounceRight
        return settings
    }
    
    func with(actionOnScrollBounceBottom: Action & CanBeTriggeredByScrollBounceBottom) -> Settings {
        var settings = self
        settings.actionOnScrollBounceBottom = actionOnScrollBounceBottom
        return settings
    }
}
