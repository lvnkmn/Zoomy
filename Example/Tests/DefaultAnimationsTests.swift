import XCTest
@testable import Zoomy


class DefaultAnimatorsTests: XCTestCase {
    
    var sut = DefaultAnimators()
    
    override func tearDown() {

        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testAnimatorForEvent() {
        //Arrange
        sut.dismissalAnimator = FakeAnimator()
        sut.backgroundColorAnimator = FakeAnimator()
        sut.positionCorrectionAnimator = FakeAnimator()
        
        //Assert
        XCTAssert((sut.animator(for: .OverlayDismissal) as! FakeAnimator) === (sut.dismissalAnimator as! FakeAnimator), Message.expectedSameObject)
        XCTAssert((sut.animator(for: .BackgroundColorChange) as! FakeAnimator) === (sut.backgroundColorAnimator as! FakeAnimator), Message.expectedSameObject)
        XCTAssert((sut.animator(for: .PositionCorrection) as! FakeAnimator) === (sut.positionCorrectionAnimator as! FakeAnimator), Message.expectedSameObject)
    }
}
