//
//  GameCollectionUITests.swift
//  GameCollectionUITests
//
//  Created by Cinq Technologies on 14/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import XCTest

class GameCollectionUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
//    func testSearch() {
//        XCUIDevice.shared.orientation = .portrait
//        
//        let app = XCUIApplication()
//        app.tabBars.buttons["Add games"].tap()
//        app.navigationBars["Add games"].searchFields["Search for a game..."].tap()
//        
//        let element = app.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 2)
//        element/*@START_MENU_TOKEN@*/.swipeLeft()/*[[".swipeUp()",".swipeLeft()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        element.tap()
//        element.tap()
//        element.tap()
//        app.otherElements["candidate"].children(matching: .other).element(boundBy: 1).children(matching: .key).element(boundBy: 1).tap()
//        element.tap()
//        element.tap()
//        
//    }
    
}
