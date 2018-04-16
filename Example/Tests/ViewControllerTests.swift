import XCTest
@testable import Zoomy

class ViewControllerTests: XCTestCase {
    
    let sut = MockViewController()
    
    lazy var nonDefaultSettings = ZoomSettings.defaultSettings.with(zoomCancelingThreshold: 1.21231235)
    lazy var fakeZoomDelegate = FakeZoomDelegate()
    
    override func tearDown() {
        sut.imageZoomControllers = [UIImageView: ImageZoomController]()
        super.tearDown()
    }
    
    // MARK: Tests
    func testAddBehaviorForImageViewInViewContainerViewWithDelegateAndSettings() {
        //Act
        sut.addZoombehavior(for: sut.imageView, in: sut.otherView, delegate: fakeZoomDelegate, settings: nonDefaultSettings)
        
        //Assert
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.imageView === sut.imageView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.containerView === sut.otherView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.settings == nonDefaultSettings, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.delegate === fakeZoomDelegate, Message.expectedProvidedValue)
    }
    
    func testAddBehaviorForImageViewInViewContainerViewWithDelegate() {
        //Act
        sut.addZoombehavior(for: sut.imageView, in: sut.otherView, delegate: fakeZoomDelegate)
        
        //Assert
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.imageView === sut.imageView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.containerView === sut.otherView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.settings == .defaultSettings, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.delegate === fakeZoomDelegate, Message.expectedProvidedValue)
    }
    
    func testAddBehaviorForImageViewInViewContainerViewWithSettings() {
        //Act
        sut.addZoombehavior(for: sut.imageView, in: sut.otherView, settings: nonDefaultSettings)
        
        //Assert
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.imageView === sut.imageView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.containerView === sut.otherView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.settings == nonDefaultSettings, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.delegate == nil, Message.expectedDefaultValue)
    }
    
    func testAddBehaviorForImageViewInViewContainer() {
        //Act
        sut.addZoombehavior(for: sut.imageView, in: sut.otherView)
        
        //Assert
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.imageView === sut.imageView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.containerView === sut.otherView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.settings == .defaultSettings, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.delegate == nil, Message.expectedDefaultValue)
    }
    
    func testAddBehaviorForImageViewWithDelegateAndSettings() {
        //Act
        sut.addZoombehavior(for: sut.imageView, delegate: fakeZoomDelegate, settings: nonDefaultSettings)
        
        //Assert
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.imageView === sut.imageView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.containerView === sut.view, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.settings == nonDefaultSettings, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.delegate === fakeZoomDelegate, Message.expectedProvidedValue)
    }
    
    func testAddBehaviorForImageViewWithDelegate() {
        //Act
        sut.addZoombehavior(for: sut.imageView, delegate: fakeZoomDelegate)
        
        //Assert
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.imageView === sut.imageView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.containerView === sut.view, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.settings == ZoomSettings.defaultSettings, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.delegate === fakeZoomDelegate, Message.expectedProvidedValue)
    }
    
    func testAddBehaviorForImageViewWithSettings() {
        //Act
        sut.addZoombehavior(for: sut.imageView, settings: nonDefaultSettings)
        
        //Assert
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.imageView === sut.imageView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.containerView === sut.view, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.settings == nonDefaultSettings, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.delegate == nil, Message.expectedDefaultValue)
    }
    
    func testAddBehaviorForImageView() {
        //Act
        sut.addZoombehavior(for: sut.imageView)
        
        //Assert
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.imageView === sut.imageView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.containerView === sut.view, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.settings == ZoomSettings.defaultSettings, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.delegate == nil, Message.expectedDefaultValue)
    }
}
