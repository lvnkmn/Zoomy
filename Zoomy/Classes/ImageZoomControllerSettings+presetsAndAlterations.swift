//
//  ImageZoomControllerSettings.swift
//  Pods-Zoomy_Example
//
//  Created by Menno on 09/04/2018.
//

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
        return self
    }
    
    func with(maximumZoomScale: ImageScale) -> ImageZoomControllerSettings {
        var settings = self
        settings.maximumZoomScale = maximumZoomScale
        return self
    }
    
    func with(isEnabled: Bool) -> ImageZoomControllerSettings {
        var settings = self
        settings.isEnabled = isEnabled
        return self
    }
    
    func with(shouldDisplayBackground: Bool) -> ImageZoomControllerSettings {
        var settings = self
        settings.shouldDisplayBackground = shouldDisplayBackground
        return self
    }
    
    func with(backgroundColorWhenContentIsSmallerThanViewItsDisplayedIn: UIColor) -> ImageZoomControllerSettings {
        var settings = self
        settings.backgroundColorWhenContentIsSmallerThanViewItsDisplayedIn = backgroundColorWhenContentIsSmallerThanViewItsDisplayedIn
        return self
    }
    
    func with(backgroundWhenContentFillsViewItsDisplayedIn: UIColor) -> ImageZoomControllerSettings {
        var settings = self
        settings.backgroundWhenContentFillsViewItsDisplayedIn = backgroundWhenContentFillsViewItsDisplayedIn
        return self
    }
}
