import XCTest
@testable import Zoomy

class ViewControllerThatIsZoomDelegateTests: XCTestCase {
    
    let sut = MockViewControllerThatIsZoomDelegate()
    
    lazy var nonDefaultSettings = Settings.defaultSettings.with(zoomCancelingThreshold: 1.21231235)
    lazy var fakeZoomDelegate = FakeZoomDelegate()

    override func tearDown() {
        sut.imageZoomControllers = [UIImageView: ImageZoomController]()
        super.tearDown()
    }
    
    // MARK: Tests
    func testAddBehaviorForImageViewInViewContainerViewWithSettings() {
        //Act
        sut.addZoombehavior(for: sut.imageView, in: sut.otherView, settings: nonDefaultSettings)
        
        //Assert
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.imageView === sut.imageView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.containerView === sut.otherView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.settings == nonDefaultSettings, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.delegate === sut, Message.expectedDefaultValue)
    }
    
    func testAddBehaviorForImageViewInViewContainer() {
        //Act
        sut.addZoombehavior(for: sut.imageView, in: sut.otherView)
        
        //Assert
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.imageView === sut.imageView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.containerView === sut.otherView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.settings == .defaultSettings, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.delegate === sut, Message.expectedDefaultValue)
    }

    func testAddBehaviorForImageViewWithSettings() {
        //Act
        sut.addZoombehavior(for: sut.imageView, settings: nonDefaultSettings)
        
        //Assert
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.imageView === sut.imageView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.containerView === sut.view, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.settings == nonDefaultSettings, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.delegate === sut, Message.expectedDefaultValue)
    }
    
    func testAddBehaviorForImageView() {
        //Act
        sut.addZoombehavior(for: sut.imageView)
        
        //Assert
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.imageView === sut.imageView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.containerView === sut.view, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.settings == Settings.defaultSettings, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.delegate === sut, Message.expectedDefaultValue)
    }
}
