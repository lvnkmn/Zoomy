import XCTest
import InjectableLoggers
@testable import Zoomy

class ImageZoomControllerTests: XCTestCase {
    
    var containerView: UIView!
    var imageView: UIImageView!
    
    var sut: ImageZoomController!
    
    var delegate: StubZoomyDelegate!
    var defaultAnimators: DefaultAnimators!
    var settings:Settings!
    var mockLogger: MockLogger!
    
    override func setUp() {
        containerView = UIView()
        imageView = UIImageView()
        sut = ImageZoomController(container: containerView, imageView: imageView)
        delegate = StubZoomyDelegate()
        defaultAnimators = DefaultAnimators()
        settings = Settings()
        mockLogger = MockLogger()
    }
    
    // MARK: - Tests
    
    func testAnimatorForEvent1() {
        //Arrange
        delegate.positionCorrectionAnimator = nil
        delegate.dismissalAnimator = nil
        delegate.backgroundColorAnimator = nil
        
        settings.defaultAnimators = defaultAnimators
        sut.settings = settings
        sut.delegate = delegate
        
        //Assert
        for event in AnimationEvent.all {
            XCTAssert(sut.animator(for: event) as? FakeAnimator === sut.settings.defaultAnimators.animator(for: event) as? FakeAnimator, Message.expectedDefaultValue + " from settings")
        }
    }
    
    func testAnimatorForEvent2() {
        //Arrange
        delegate.backgroundColorAnimator = FakeAnimator()
        delegate.dismissalAnimator = FakeAnimator()
        delegate.positionCorrectionAnimator = FakeAnimator()
        
        settings.defaultAnimators = defaultAnimators
        sut.settings = settings
        sut.delegate = delegate
        
        //Assert
        for event in AnimationEvent.all {
            XCTAssert(sut.animator(for: event) as? FakeAnimator === sut.delegate?.animator(for: event) as? FakeAnimator, Message.expectedProvidedValue + " from delegate")
        }
    }
    
    func testAnimatorForEvent3() {
        //Arrange
        sut.delegate = nil
        
        //Assert
        if let defaultBackgroundColorAnimator = sut.animator(for: .backgroundColorChange) as? Animator {
            XCTAssertEqual(defaultBackgroundColorAnimator.delay, 0, Message.expectedDefaultValue)
            XCTAssertEqual(defaultBackgroundColorAnimator.duration, 0.5, Message.expectedDefaultValue)
            XCTAssertEqual(defaultBackgroundColorAnimator.options, .curveLinear, Message.expectedDefaultValue)
        } else {
            XCTFail(Message.expectedDifferentType + " of animator")
        }
        
        if let defaultDismissalAnimator = sut.animator(for: .overlayDismissal) as? Animator {
            XCTAssertEqual(defaultDismissalAnimator.delay, 0, Message.expectedDefaultValue)
            XCTAssertEqual(defaultDismissalAnimator.duration, 0.2, Message.expectedDefaultValue)
            XCTAssertEqual(defaultDismissalAnimator.options, .curveEaseInOut, Message.expectedDefaultValue)
        } else {
            XCTFail(Message.expectedDifferentType + " of animator")
        }
        
        if let defaultPositionCorrectionAnimator = sut.animator(for: .positionCorrection) as? SpringAnimator {
            XCTAssertEqual(defaultPositionCorrectionAnimator.delay, 0, Message.expectedDefaultValue)
            XCTAssertEqual(defaultPositionCorrectionAnimator.duration, 0.5, Message.expectedDefaultValue)
            XCTAssertEqual(defaultPositionCorrectionAnimator.springDamping, 0.66, Message.expectedDefaultValue)
            XCTAssertEqual(defaultPositionCorrectionAnimator.initialSpringVelocity, 0.5, Message.expectedDefaultValue)
            XCTAssertEqual(defaultPositionCorrectionAnimator.options, .curveEaseInOut, Message.expectedDefaultValue)
        } else {
            XCTFail(Message.expectedDifferentType + " of animator")
        }
    }
    
    func testSetupImage1() {
        //Arrange
        let stubImage = UIImage(color: UIColor.blue)
        imageView.image = stubImage
        logger.relay = mockLogger
        sut.settings = settings
        
        //Act
        sut.setupImage()
        
        //Assert
        XCTAssert(sut.image === stubImage, Message.expectedSameObject)
        XCTAssertEqual(mockLogger.loggedMessages(atLevel: Loglevel.warning).count, 0)
    }
    
    func testSetupImage2() {
        //Arrange
        imageView.image = nil
        logger.relay = mockLogger
        sut.settings = settings
        
        //Act
        sut.setupImage()
        
        //Assert
        XCTAssertNil(sut.image)
        XCTAssertEqual(mockLogger.loggedMessages.last?.message as? String, "Provided imageView did not have an image at this time, this is likely to have effect on the zoom behavior.")
        XCTAssertEqual(mockLogger.loggedMessages.last?.level, Loglevel.warning)
    }
    
    func testSetupImage3() {
        //Arrange
        imageView.image = nil
        logger.relay = mockLogger
        settings.shouldLogWarningsAndErrors = false
        sut.settings = settings
        
        //Act
        sut.setupImage()
        
        //Assert
        XCTAssertNil(sut.image)
        XCTAssertEqual(mockLogger.loggedMessages.count, 0)
    }
    
    func testRequiredInitializer1() {
        //Act
        sut = ImageZoomController(container: containerView, imageView: imageView, delegate: nil, settings: settings)
        
        //Assert
        XCTAssertNotNil(sut.state as? IsNotPresentingOverlayState, Message.expectedDifferentType)
    }
    
    func testRequiredInitializer2() {
        //Arrange
        containerView.addSubview(imageView)
        logger.relay = mockLogger
        
        //Act
        sut = ImageZoomController(container: containerView, imageView: imageView, delegate: nil, settings: settings)
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages(atLevel: Loglevel.warning).count, 0)
    }
    
    func testRequiredInitializer3() {
        //Arrange
        logger.relay = mockLogger
        settings.shouldLogWarningsAndErrors = false
        
        //Act
        sut = ImageZoomController(container: containerView, imageView: imageView, delegate: nil, settings: settings)
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.count, 0)
    }
    
    // MARK: UIGestureRecognizerDelegate
    func testGestureRecognizerShouldReceiveTouch1() {
        //Arrange
        let gestureRecognizer = sut.imageViewTapGestureRecognizer
        let actionsThatNeedTouch = Action.all.filter({ !($0 is Action.None)  }).filter({ $0 is CanBeTriggeredByImageViewTap })

        //Act
        sut.settings.actionOnTapImageView = Action.none
        
        //Assert
        XCTAssertEqual(sut.gestureRecognizer(gestureRecognizer, shouldReceive: UITouch()), false)
        XCTAssert(actionsThatNeedTouch.count > 0)
        for action in actionsThatNeedTouch {
            sut.settings.actionOnTapImageView = action as! Action & CanBeTriggeredByImageViewTap
            XCTAssertEqual(sut.gestureRecognizer(gestureRecognizer, shouldReceive: UITouch()), true)
        }
    }
    
    func testGestureRecognizerShouldReceiveTouch2() {
        //Arrange
        let gestureRecognizer = sut.imageViewDoubleTapGestureRecognizer
        let actionsThatNeedTouch = Action.all.filter({ !($0 is Action.None)  }).filter({ $0 is CanBeTriggeredByImageViewDoubleTap })
        
        //Act
        sut.settings.actionOnDoubleTapImageView = Action.none
        
        //Assert
        XCTAssertEqual(sut.gestureRecognizer(gestureRecognizer, shouldReceive: UITouch()), false)
        XCTAssert(actionsThatNeedTouch.count > 0)
        for action in actionsThatNeedTouch {
            sut.settings.actionOnDoubleTapImageView = action as! Action & CanBeTriggeredByImageViewDoubleTap
            XCTAssertEqual(sut.gestureRecognizer(gestureRecognizer, shouldReceive: UITouch()), true)
        }
    }
    
    func testGestureRecognizerShouldReceiveTouch3() {
        //Arrange
        let gestureRecognizer = sut.scrollableImageViewTapGestureRecognizer
        let actionsThatNeedTouch = Action.all.filter({ !($0 is Action.None)  }).filter({ $0 is CanBeTriggeredByOverlayTap })
        
        //Act
        sut.settings.actionOnTapOverlay = Action.none
        
        //Assert
        XCTAssertEqual(sut.gestureRecognizer(gestureRecognizer, shouldReceive: UITouch()), false)
        XCTAssert(actionsThatNeedTouch.count > 0)
        for action in actionsThatNeedTouch {
            sut.settings.actionOnTapOverlay = action as! Action & CanBeTriggeredByOverlayTap
            XCTAssertEqual(sut.gestureRecognizer(gestureRecognizer, shouldReceive: UITouch()), true)
        }
    }
    
    func testGestureRecognizerShouldReceiveTouch4() {
        //Arrange
        let gestureRecognizer = sut.scrollableImageViewDoubleTapGestureRecognizer
        let actionsThatNeedTouch = Action.all.filter({ !($0 is Action.None)  }).filter({ $0 is CanBeTriggeredByOverlayDoubleTap })
        
        //Act
        sut.settings.actionOnDoubleTapOverlay = Action.none

        //Assert
        XCTAssertEqual(sut.gestureRecognizer(gestureRecognizer, shouldReceive: UITouch()), false)
        XCTAssert(actionsThatNeedTouch.count > 0)
        for action in actionsThatNeedTouch {
            sut.settings.actionOnDoubleTapOverlay = action as! Action & CanBeTriggeredByOverlayDoubleTap
            XCTAssertEqual(sut.gestureRecognizer(gestureRecognizer, shouldReceive: UITouch()), true)
        }
    }
    
    func testGestureRecognizerShouldReceiveTouch5() {
        //Arrange
        let gestureRegocnizersThatAlwaysNeedTouch = [sut.imageViewPinchGestureRecognizer,
                                                     sut.imageViewPanGestureRecognizer,
                                                     sut.scrollableImageViewPanGestureRecognizer]

        //Assert
        for gestureRecognizer in gestureRegocnizersThatAlwaysNeedTouch {
            XCTAssertEqual(sut.gestureRecognizer(gestureRecognizer, shouldReceive: UITouch()), true)
        }
    }
}
