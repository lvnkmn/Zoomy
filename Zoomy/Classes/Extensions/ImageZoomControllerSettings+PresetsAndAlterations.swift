import Foundation

// MARK: Presets
public extension ImageZoomControllerSettings {
    static var defaultSettings: ImageZoomControllerSettings {
        return ImageZoomControllerSettings()
    }
    
    static var backgroundEnabledSettings: ImageZoomControllerSettings {
        return defaultSettings.with(shouldDisplayBackground: true)
    }
    
    static var noZoomCancellingSettings: ImageZoomControllerSettings {
        return defaultSettings.with(zoomCancelingThreshold: 1)
    }
}

//MARK: - Alterations
public extension ImageZoomControllerSettings {
    
    func with(zoomCancelingThreshold: ImageViewScale) -> ImageZoomControllerSettings {
        var settings = self
        settings.zoomCancelingThreshold = zoomCancelingThreshold
        return settings
    }
    
    func with(maximumZoomScale: ImageScale) -> ImageZoomControllerSettings {
        var settings = self
        settings.maximumZoomScale = maximumZoomScale
        return settings
    }
    
    func with(isEnabled: Bool) -> ImageZoomControllerSettings {
        var settings = self
        settings.isEnabled = isEnabled
        return settings
    }
    
    func with(shouldDisplayBackground: Bool) -> ImageZoomControllerSettings {
        var settings = self
        settings.shouldDisplayBackground = shouldDisplayBackground
        return settings
    }
    
    func with(primaryBackgroundColor: UIColor) -> ImageZoomControllerSettings {
        var settings = self
        settings.primaryBackgroundColor = primaryBackgroundColor
        return settings
    }
    
    func with(secundaryBackgroundColor: UIColor) -> ImageZoomControllerSettings {
        var settings = self
        settings.secundaryBackgroundColor = secundaryBackgroundColor
        return settings
    }
    
    func with(neededTranslationToDismissOverlayOnScrollBounce: CGFloat) -> ImageZoomControllerSettings {
        var settings = self
        settings.neededTranslationToDismissOverlayOnScrollBounce = neededTranslationToDismissOverlayOnScrollBounce
        return settings
    }
}
