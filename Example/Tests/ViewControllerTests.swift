import XCTest
@testable import Zoomy


class ViewControllerTests: XCTestCase {
    
    let sut = MockViewController()
    
    lazy var nonDefaultSettings = Settings.defaultSettings.with(zoomCancelingThreshold: 1.21231235)
    lazy var fakeZoomDelegate = FakeZoomDelegate()
    
    override func tearDown() {
        sut.imageZoomControllers = [UIImageView: ImageZoomController]()
        super.tearDown()
    }
    
    // MARK: - Tests
    
    // MARK: Adding behavior
    func testAddBehaviorForImageViewInViewContainerViewBelowTopmostViewWithDelegateAndSettings() {
        //Act
        sut.addZoombehavior(for: sut.imageView, in: sut.otherView, below: sut.topMostView, delegate: fakeZoomDelegate, settings: nonDefaultSettings)
        
        //Assert
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.imageView === sut.imageView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.containerView === sut.otherView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.topmostView === sut.topMostView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.settings == nonDefaultSettings, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.delegate === fakeZoomDelegate, Message.expectedProvidedValue)
    }
    
    func testAddBehaviorForImageViewInViewContainerViewWithDelegate() {
        //Act
        sut.addZoombehavior(for: sut.imageView, in: sut.otherView, delegate: fakeZoomDelegate)
        
        //Assert
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.imageView === sut.imageView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.containerView === sut.otherView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.topmostView == nil, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.settings == .defaultSettings, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.delegate === fakeZoomDelegate, Message.expectedProvidedValue)
    }
    
    func testAddBehaviorForImageViewInViewContainerViewWithSettings() {
        //Act
        sut.addZoombehavior(for: sut.imageView, in: sut.otherView, settings: nonDefaultSettings)
        
        //Assert
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.imageView === sut.imageView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.containerView === sut.otherView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.topmostView == nil, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.settings == nonDefaultSettings, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.delegate == nil, Message.expectedDefaultValue)
    }
    
    func testAddBehaviorForImageViewInViewContainer() {
        //Act
        sut.addZoombehavior(for: sut.imageView, in: sut.otherView)
        
        //Assert
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.imageView === sut.imageView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.containerView === sut.otherView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.topmostView == nil, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.settings == .defaultSettings, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.delegate == nil, Message.expectedDefaultValue)
    }
    
    func testAddBehaviorForImageViewWithDelegateAndSettings() {
        //Act
        sut.addZoombehavior(for: sut.imageView, delegate: fakeZoomDelegate, settings: nonDefaultSettings)
        
        //Assert
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.imageView === sut.imageView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.containerView === sut.view, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.topmostView == nil, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.settings == nonDefaultSettings, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.delegate === fakeZoomDelegate, Message.expectedProvidedValue)
    }
    
    func testAddBehaviorForImageViewWithDelegate() {
        //Act
        sut.addZoombehavior(for: sut.imageView, delegate: fakeZoomDelegate)
        
        //Assert
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.imageView === sut.imageView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.containerView === sut.view, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.topmostView == nil, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.settings == Settings.defaultSettings, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.delegate === fakeZoomDelegate, Message.expectedProvidedValue)
    }
    
    func testAddBehaviorForImageViewWithSettings() {
        //Act
        sut.addZoombehavior(for: sut.imageView, settings: nonDefaultSettings)
        
        //Assert
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.imageView === sut.imageView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.containerView === sut.view, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.topmostView == nil, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.settings == nonDefaultSettings, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.delegate == nil, Message.expectedDefaultValue)
    }
    
    func testAddBehaviorForImageView() {
        //Act
        sut.addZoombehavior(for: sut.imageView)
        
        //Assert
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.imageView === sut.imageView, Message.expectedProvidedValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.containerView === sut.view, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.topmostView == nil, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.settings == Settings.defaultSettings, Message.expectedDefaultValue)
        XCTAssert(sut.imageZoomControllers[sut.imageView]?.delegate == nil, Message.expectedDefaultValue)
    }
    
    func testAddBehaviorTwice() {
        //Arrange
        sut.addZoombehavior(for: sut.imageView)
        let numberOfGestureRecognizersBeforeAddingSecondZoomBehavior = sut.imageView.gestureRecognizers?.count
        
        //Act
        sut.addZoombehavior(for: sut.imageView)
        
        //Assert
        XCTAssertEqual(numberOfGestureRecognizersBeforeAddingSecondZoomBehavior, sut.imageView.gestureRecognizers?.count)
    }
    
    // MARK: Removing behavior
    func testRemoveBehavior() {
        //Arrange
        let numberOfGestureRecognizersBeforeAddingZoomBehavior = sut.imageView.gestureRecognizers?.count ?? 0
        sut.addZoombehavior(for: sut.imageView)
        
        //Act
        sut.removeZoomBehavior(for: sut.imageView)
        
        //Assert
        XCTAssertEqual(numberOfGestureRecognizersBeforeAddingZoomBehavior, sut.imageView.gestureRecognizers?.count ?? 0)
    }
}
