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
    var logger: MockLogger!
    
    override func setUp() {
        containerView = UIView()
        imageView = UIImageView()
        sut = ImageZoomController(container: containerView, imageView: imageView)
        delegate = StubZoomyDelegate()
        defaultAnimators = DefaultAnimators()
        settings = Settings()
        logger = MockLogger()
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
        if let defaultBackgroundColorAnimator = sut.animator(for: .BackgroundColorChange) as? Animator {
            XCTAssertEqual(defaultBackgroundColorAnimator.delay, 0, Message.expectedDefaultValue)
            XCTAssertEqual(defaultBackgroundColorAnimator.duration, 0.5, Message.expectedDefaultValue)
            XCTAssertEqual(defaultBackgroundColorAnimator.options, .curveLinear, Message.expectedDefaultValue)
        } else {
            XCTFail(Message.expectedDifferentType + " of animator")
        }
        
        if let defaultDismissalAnimator = sut.animator(for: .OverlayDismissal) as? Animator {
            XCTAssertEqual(defaultDismissalAnimator.delay, 0, Message.expectedDefaultValue)
            XCTAssertEqual(defaultDismissalAnimator.duration, 0.2, Message.expectedDefaultValue)
            XCTAssertEqual(defaultDismissalAnimator.options, .curveEaseInOut, Message.expectedDefaultValue)
        } else {
            XCTFail(Message.expectedDifferentType + " of animator")
        }
        
        if let defaultPositionCorrectionAnimator = sut.animator(for: .PositionCorrection) as? SpringAnimator {
            XCTAssertEqual(defaultPositionCorrectionAnimator.delay, 0, Message.expectedDefaultValue)
            XCTAssertEqual(defaultPositionCorrectionAnimator.duration, 0.5, Message.expectedDefaultValue)
            XCTAssertEqual(defaultPositionCorrectionAnimator.springDamping, 0.66, Message.expectedDefaultValue)
            XCTAssertEqual(defaultPositionCorrectionAnimator.initialSpringVelocity, 0.5, Message.expectedDefaultValue)
            XCTAssertEqual(defaultPositionCorrectionAnimator.options, .curveEaseInOut, Message.expectedDefaultValue)
        } else {
            XCTFail(Message.expectedDifferentType + " of animator")
        }
    }
    
    func testLogger() {
        if let logger = sut.settings.logger as? Logger {
            XCTAssertEqual(logger.settings.activeLogLevel, .warning, Message.expectedDefaultValue)
        } else {
            XCTFail(Message.expectedDifferentType + " of logger")
        }
    }
    
    func testSetupImage1() {
        //Arrange
        let stubImage = UIImage(color: UIColor.blue)
        imageView.image = stubImage
        settings.logger = logger
        sut.settings = settings
        
        //Act
        sut.setupImage()
        
        //Assert
        XCTAssert(sut.image === stubImage, Message.expectedSameObject)
        XCTAssertEqual(logger.loggedMessages(at: Loglevel.warning).count, 0)
    }
    
    func testSetupImage2() {
        //Arrange
        imageView.image = nil
        settings.logger = logger
        sut.settings = settings
        
        //Act
        sut.setupImage()
        
        //Assert
        XCTAssertNil(sut.image)
        XCTAssertEqual(logger.loggedMessages.last?.message as? String, "Provided imageView did not have an image at this time, this is likely to have effect on the zoom behavior.")
        XCTAssertEqual(logger.loggedMessages.last?.level, Loglevel.warning)
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
        settings.logger = logger
        
        //Act
        sut = ImageZoomController(container: containerView, imageView: imageView, delegate: nil, settings: settings)
        
        //Assert
        XCTAssertEqual(logger.loggedMessages(at: Loglevel.warning).count, 0)
    }
    
    func testRequiredInitializer3() {
        //Arrange
        settings.logger = logger
        
        //Act
        sut = ImageZoomController(container: containerView, imageView: imageView, delegate: nil, settings: settings)
        
        //Assert
        XCTAssertEqual(logger.loggedMessages.last?.message as? String, "Provided containerView is not an ansestor of provided imageView, this is likely to have effect on the zoom behavior.")
        XCTAssertEqual(logger.loggedMessages.last?.level, Loglevel.warning)
    }
}
