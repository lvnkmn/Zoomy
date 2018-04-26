import Foundation
import InjectableLoggers

public struct ImageZoomControllerSettings {
    
    public init() {}
    
    /// When scale of imageView is below this threshold when initial pinch gesture ends, the overlay will be dismissed
    public var zoomCancelingThreshold: ImageViewScale = 1.5
    
    /// The miximum zoomsScale at which an image will be displayed
    public var maximumZoomScale: ImageScale = 2
    
    /// Causes the behavior of the ImageZoomController to (temporarily) be disabled when needed
    public var isEnabled = true
    
    /// Whether or not a background view needs to be displayed behind the zoomed imageViews
    public var shouldDisplayBackground = false

    /// The animators that will be used when Zoomy.Delegate doesn't provide an animator for needed events
    public var defaultAnimators: CanProvideAnimatorForEvent = DefaultAnimators()
    
    /// BackgroundView's color will animate to this value when content becomes smaller than the view it's displayed in
    /// This will only have effect when shouldDisplayBackground is set to true
    public var primaryBackgroundColor = UIColor.white.withAlphaComponent(0.8)
    
    /// BackgroundView's color will animate to this value when content becomes bigger than or equal to any dimension of the view it's displayed in
    /// This will only have effect when shouldDisplayBackground is set to true
    public var secundaryBackgroundColor = UIColor.white
    
    /// The logger to which all messages will be logged, will only print errors and warnings by default
    public var logger: CanLogMessageAtLevel = Logger(settings: .verboseSettings)
    
    /// The amount of point that have to be panned while scrollView is bouncing in order to dismiss the overlay
    /// Note: Settings this value alone doesn't have effect when dismissal by bounce is not enabled
    public var neededTranslationToDismissOverlayOnScrollBounce: CGFloat = 80
    
    /// The action that will be triggered when the overlay is tapped
    public var actionOnTapOverlay: Action = Action.none
    
    /// The action that will be triggered when scrollView is bouncing while scrolling towards the top
    public var actionOnScrollBounceTop: Action & CanBeTriggeredByScrollBounceTop = Action.none
    
    /// The action that will be triggered when scrollView is bouncing while scrolling towards the left
    public var actionOnScrollBounceLeft: Action & CanBeTriggeredByScrollBounceLeft = Action.none
    
    /// The action that will be triggered when scrollView is bouncing while scrolling towards the right
    public var actionOnScrollBounceRight: Action & CanBeTriggeredByScrollBounceRight = Action.none
    
    /// The action that will be triggered when scrollView is bouncing while scrolling towards the bottom
    public var actionOnScrollBounceBottom: Action & CanBeTriggeredByScrollBounceBottom = Action.none
}

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
    
    func with(logger: CanLogMessageAtLevel) -> Settings {
        var settings = self
        settings.logger = logger
        return settings
    }
    
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

