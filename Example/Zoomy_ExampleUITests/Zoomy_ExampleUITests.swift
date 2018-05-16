//
//  Zoomy_ExampleUITests.swift
//  Zoomy_ExampleUITests
//
//  Created by Menno on 15/05/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest

class Zoomy_ExampleUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app.launch()
        app.sheets["Shake to toggle navigationbar"].buttons["Ok"].tap()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testScreenWideImage() {
        app.tables.staticTexts["Screenwide Image"].tap()
        app/*@START_MENU_TOKEN@*/.images["Trees_0"]/*[[".scrollViews.images[\"Trees_0\"]",".images[\"Trees_0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.pinch(withScale: 2, velocity: 10)
        app/*@START_MENU_TOKEN@*/.images["Trees_0"]/*[[".scrollViews.images[\"Trees_0\"]",".images[\"Trees_0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
        app/*@START_MENU_TOKEN@*/.images["Trees_0"]/*[[".scrollViews.images[\"Trees_0\"]",".images[\"Trees_0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeRight()
        app/*@START_MENU_TOKEN@*/.images["Trees_0"]/*[[".scrollViews.images[\"Trees_0\"]",".images[\"Trees_0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        app/*@START_MENU_TOKEN@*/.images["Trees_0"]/*[[".scrollViews.images[\"Trees_0\"]",".images[\"Trees_0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeDown()
        app/*@START_MENU_TOKEN@*/.images["Trees_0"]/*[[".scrollViews.images[\"Trees_0\"]",".images[\"Trees_0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    func testNonCenteredImages() {
        app.tables.staticTexts["Non Centered Image"].tap()
        app.images["Trees_0"].pinch(withScale: 5, velocity: 10)
        app.images["Trees_0"].tap()
        app.images["Trees_5"].pinch(withScale: 5, velocity: 10)
        app.images["Trees_5"].swipeLeft()
        app.images["Trees_5"].swipeRight()
        app.images["Trees_5"].swipeUp()
        app.images["Trees_5"].swipeDown()
        app.images["Trees_5"].tap()
    }
    
    func testStackViewImages() {
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["StackView Images"]/*[[".cells.staticTexts[\"StackView Images\"]",".staticTexts[\"StackView Images\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        app.swipeUp()
        app.pinch(withScale: 2, velocity: 10)
        app.swipeDown()
        app.swipeUp()
        app.pinch(withScale: 2, velocity: 10)
        app.tap()
    }
    
    func testChangingActions() {
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Changing Actions"]/*[[".cells.staticTexts[\"Changing Actions\"]",".staticTexts[\"Changing Actions\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let image = app.images["Trees_3"]
        
        let stackView = app.otherElements.containing(.navigationBar, identifier:"Changing Actions").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element

        let tapImage = stackView.children(matching: .other).element(boundBy: 0)
        let doubleTapImage = stackView.children(matching: .other).element(boundBy: 1)
        let tapOverlay = stackView.children(matching: .other).element(boundBy: 2)
        let doubleTapOverlay = stackView.children(matching: .other).element(boundBy: 3)
        let bounceTop = stackView.children(matching: .other).element(boundBy: 4)
        let bounceLeft = stackView.children(matching: .other).element(boundBy: 5)
        let bounceRight = stackView.children(matching: .other).element(boundBy: 6)
        let bounceBottom = stackView.children(matching: .other).element(boundBy: 7)
        
        tapImage.buttons[Button.zoomIn].tap()
        tapOverlay.buttons[Button.dismiss].tap()
        
        image.tap()
        image.tap()
        
        tapImage.buttons[Button.zoomToFit].tap()
        bounceBottom.buttons[Button.dismiss].tap()
        
        image.tap()
        image.swipeDown()
        
        tapOverlay.buttons[Button.zoomIn].tap()
        
        image.tap()
        image.tap()
        
        /// Silence warnings
        _ = doubleTapImage
        _ = doubleTapOverlay
        _ = bounceTop
        _ = bounceLeft
        _ = bounceRight
        _ = bounceBottom
    }
    
    func testInstaZoom() {
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["InstaZoom"]/*[[".cells.staticTexts[\"InstaZoom\"]",".staticTexts[\"InstaZoom\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.images["Colorfull_2"].pinch(withScale: 2, velocity: 10)
        app.images["Colorfull_2"].pinch(withScale: 5, velocity: 10)
    }
}

private struct Button {
    static let none = "None"
    static let dismiss = "Dismiss"
    static let zoomIn = "ZoomIn"
    static let zoomToFit = "ZoomToFit"
}
