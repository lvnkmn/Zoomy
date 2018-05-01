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
        XCTAssert((sut.animator(for: .overlayDismissal) as! FakeAnimator) === (sut.dismissalAnimator as! FakeAnimator), Message.expectedSameObject)
        XCTAssert((sut.animator(for: .backgroundColorChange) as! FakeAnimator) === (sut.backgroundColorAnimator as! FakeAnimator), Message.expectedSameObject)
        XCTAssert((sut.animator(for: .positionCorrection) as! FakeAnimator) === (sut.positionCorrectionAnimator as! FakeAnimator), Message.expectedSameObject)
    }
}
