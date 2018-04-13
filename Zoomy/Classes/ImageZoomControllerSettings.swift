//
//  ImageZoomControllerSettings.swift
//  Pods-Zoomy_Example
//
//  Created by Menno on 09/04/2018.
//

import Foundation

public struct ImageZoomControllerSettings {
    
    public init() {}
    
    /// When scale of imageView is below this threshold when initial pinch gesture ends, the overlay will be dismissed
    public var zoomCancelingThreshold: ImageViewScale = 1.5
    
    /// The miximum zoomsScale at which an image will be displayed
    public var maximumZoomScale: ImageScale = 2
    
    /// Causes the behavior of the ImageZoomController to (temporarily) be disabled when needed
    public var isEnabled = true
    
    /// Whether or not a background view needs to be displayed behind the zoomed imageViews
    public var shouldDisplayBackground = true
    
    /// BackgroundView's color will animate to this value when content becomes smaller than the view it's displayed in
    /// This will only have effect when shouldDisplayBackground is set to true
    public var backgroundColorWhenContentIsSmallerThanViewItsDisplayedIn = UIColor.black.withAlphaComponent(0.5)
    /// BackgroundView's color will animate to this value when content becomes bigger than or equal to any dimension of the view it's displayed in
    /// This will only have effect when shouldDisplayBackground is set to true
    public var backgroundWhenContentFillsViewItsDisplayedIn = UIColor.black
}
