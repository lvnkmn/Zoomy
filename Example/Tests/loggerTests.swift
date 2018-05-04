import XCTest
@testable import Zoomy


class loggerTests: XCTestCase {
    
    let sut = logger
    
    // MARK: - Tests
    
    func testActiveLogLevel() {
        XCTAssertEqual(sut.settings.activeLogLevel, Loglevel.warning)
    }
    
    func testWarningFormattingSettings() {
        let settings = sut.settings.formatSettings[.warning]!
        
        XCTAssertEqual(settings.shouldShowLevel, true)
        XCTAssertEqual(settings.shouldShowFile, false)
        XCTAssertEqual(settings.shouldShowFunction, false)
        XCTAssertEqual(settings.shouldShowLine, false)
    }
    
    func testErrorFormattingSettings() {
        let settings = sut.settings.formatSettings[.error]!
        
        XCTAssertEqual(settings.shouldShowLevel, true)
        XCTAssertEqual(settings.shouldShowFile, false)
        XCTAssertEqual(settings.shouldShowFunction, false)
        XCTAssertEqual(settings.shouldShowLine, false)
    }
}
