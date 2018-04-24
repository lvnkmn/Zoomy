import XCTest
@testable import Zoomy

class CGPointTests: XCTestCase {
    
    var sut = CGPoint()
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testDominantDirection1() {
        //Arrange
        sut.x = 0
        sut.y = -0.01
        
        //Assert
        XCTAssertEqual(sut.dominantDirection, .top)
    }
    
    func testDominantDirection2() {
        //Arrange
        sut.x = 0.01
        sut.y = 0
        
        //Assert
        XCTAssertEqual(sut.dominantDirection, .right)
    }
    
    func testDominantDirection3() {
        //Arrange
        sut.x = 0
        sut.y = 0.01
        
        //Assert
        XCTAssertEqual(sut.dominantDirection, .bottom)
    }
    
    func testDominantDirection4() {
        //Arrange
        sut.x = -0.01
        sut.y = 0
        
        //Assert
        XCTAssertEqual(sut.dominantDirection, .left)
    }
}
