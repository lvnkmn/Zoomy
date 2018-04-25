import XCTest
@testable import Zoomy

class BounceOffsetsTests: XCTestCase {
    
    var sut = BounceOffsets()
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testComputedProperties() {
        //Arrange
        sut.top = 1111
        sut.left = 2222
        sut.right = 3333
        sut.bottom = 4444

        //Assert
        XCTAssertEqual(sut.top, 1111)
        XCTAssertEqual(sut.left, 2222)
        XCTAssertEqual(sut.right, 3333)
        XCTAssertEqual(sut.bottom, 4444)
    }
    
    func testBouncingSides1() {
        //Arrange
        sut.top = 0
        sut.left = 0
        sut.right = 0
        sut.bottom = 0
        
        //Act
        let result = sut.bouncingSides()
        
        //Assert
        XCTAssertEqual(result.count, 0)
    }
    
    func testBouncingSides2() {
        //Arrange
        sut.top = 4
        sut.left = 3
        sut.right = 2
        sut.bottom = 1
        
        //Act
        let result = sut.bouncingSides()
        
        //Assert
        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(result.index(of: .top), 0)
        XCTAssertEqual(result.index(of: .left), 1)
        XCTAssertEqual(result.index(of: .right), 2)
        XCTAssertEqual(result.index(of: .bottom), 3)
    }
    
    func testBouncingSides3() {
        //Arrange
        sut.top = 1
        sut.left = 2
        sut.right = 3
        sut.bottom = 4
        
        //Act
        let result = sut.bouncingSides()
        
        //Assert
        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(result.index(of: .top), 3)
        XCTAssertEqual(result.index(of: .left), 2)
        XCTAssertEqual(result.index(of: .right), 1)
        XCTAssertEqual(result.index(of: .bottom), 0)
    }
    
    func testBouncingSides4() {
        //Arrange
        sut.top = 0
        sut.left = 1
        sut.right = 2
        sut.bottom = 3
        
        //Act
        let result = sut.bouncingSides()
        
        //Assert
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result.index(of: .top), nil)
        XCTAssertEqual(result.index(of: .left), 2)
        XCTAssertEqual(result.index(of: .right), 1)
        XCTAssertEqual(result.index(of: .bottom), 0)
    }
    
    func testIsBouncing1() {
        //Arrange
        sut.top = 0
        sut.left = 0
        sut.right = 0
        sut.bottom = 0
        
        //Assert
        XCTAssertFalse(sut.isBouncing)
    }
    
    func testIsBouncing2() {
        //Arrange
        sut.top = 0.01
        sut.left = 0
        sut.right = 0
        sut.bottom = 0
        
        //Assert
        XCTAssertTrue(sut.isBouncing)
    }
    
    func testIsBouncing3() {
        //Arrange
        sut.top = 0
        sut.left = 0.001
        sut.right = 0
        sut.bottom = 0
        
        //Assert
        XCTAssertTrue(sut.isBouncing)
    }
    
    func testIsBouncing4() {
        //Arrange
        sut.top = 0
        sut.left = 0
        sut.right = 0.001
        sut.bottom = 0
        
        //Assert
        XCTAssertTrue(sut.isBouncing)
    }
    
    func testIsBouncing5() {
        //Arrange
        sut.top = 0
        sut.left = 0
        sut.right = 0
        sut.bottom = 0.001
        
        //Assert
        XCTAssertTrue(sut.isBouncing)
    }
    
    func testIsBouncingSide1() {
        //Arrange
        sut.top = 0
        sut.left = 0
        sut.right = 0
        sut.bottom = 0
        
        //Assert
        XCTAssertEqual(sut.isBouncing(side: .top), false)
        XCTAssertEqual(sut.isBouncing(side: .left), false)
        XCTAssertEqual(sut.isBouncing(side: .right), false)
        XCTAssertEqual(sut.isBouncing(side: .bottom), false)
    }
    
    func testIsBouncingSide2() {
        //Arrange
        sut.top = 0.001
        sut.left = 0
        sut.right = 0
        sut.bottom = 0
        
        //Assert
        XCTAssertEqual(sut.isBouncing(side: .top), true)
        XCTAssertEqual(sut.isBouncing(side: .left), false)
        XCTAssertEqual(sut.isBouncing(side: .right), false)
        XCTAssertEqual(sut.isBouncing(side: .bottom), false)
    }
    
    func testIsBouncingSide3() {
        //Arrange
        sut.top = 0
        sut.left = 0.001
        sut.right = 0
        sut.bottom = 0
        
        //Assert
        XCTAssertEqual(sut.isBouncing(side: .top), false)
        XCTAssertEqual(sut.isBouncing(side: .left), true)
        XCTAssertEqual(sut.isBouncing(side: .right), false)
        XCTAssertEqual(sut.isBouncing(side: .bottom), false)
    }
    
    func testIsBouncingSide4() {
        //Arrange
        sut.top = 0
        sut.left = 0
        sut.right = 0.001
        sut.bottom = 0
        
        //Assert
        XCTAssertEqual(sut.isBouncing(side: .top), false)
        XCTAssertEqual(sut.isBouncing(side: .left), false)
        XCTAssertEqual(sut.isBouncing(side: .right), true)
        XCTAssertEqual(sut.isBouncing(side: .bottom), false)
    }
    
    func testIsBouncingSide5() {
        //Arrange
        sut.top = 0
        sut.left = 0
        sut.right = 0
        sut.bottom = 0.001
        
        //Assert
        XCTAssertEqual(sut.isBouncing(side: .top), false)
        XCTAssertEqual(sut.isBouncing(side: .left), false)
        XCTAssertEqual(sut.isBouncing(side: .right), false)
        XCTAssertEqual(sut.isBouncing(side: .bottom), true)
    }
}
