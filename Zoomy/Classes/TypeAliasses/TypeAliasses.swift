//
//  TypeAliasses.swift
//  Pods-Zoomy_Example
//
//  Created by Menno on 09/04/2018.
//

import UIKit

//MARK: Public Types

/// The scale transformation that is applied on an imageView.
/// The value of 1 results in the original view size.
/// The value of 2 retults in twice the original view width and height.
/// The value of 0.5 results in half the original view width and height etc.
///
/// Note that ImageViewScale is different from the scale of the image, see ImageScale.
public typealias ImageViewScale = CGFloat

/// The scale transformation that is applied on an image.
/// The value of 1 results in the image size -> 1 pixel per point on screen.
/// The value of 2 retults in twice the original view width and height -> 2 pixels per point on screen.
/// The value of 0.5 results in half the original view width and height -> 0.5 pixels per point on screen etc.
///
/// Note that ImageScale is different from the scale of the imageView, see ImageViewScale.
public typealias ImageScale = CGFloat

public typealias Settings = ImageZoomControllerSettings
public typealias ContentState = ImageZoomControllerContentState
public typealias Action = ImageZoomControllerAction

//MARK: Internal Types
internal typealias State = ImageZoomControllerState
internal typealias IsNotPresentingOverlayState = ImageZoomControllerIsNotPresentingOverlayState
internal typealias IsPresentingScrollViewOverlayState = ImageZoomControllerIsPresentingScrollViewOverlayState
internal typealias IsPresentingImageViewOverlayState = ImageZoomControllerIsPresentingImageViewOverlayState
internal typealias IsHandlingScrollViewBounceTriggeredDismissalState = ImageZoomControllerIsHandlingScrollViewBounceTriggeredDismissalState


public struct Zoomy {
    public typealias Delegate = ImageZoomControllerDelegate
    public typealias Settings = ImageZoomControllerSettings
    public typealias ContentState = ImageZoomControllerContentState
    public typealias Action = ImageZoomControllerAction
}
