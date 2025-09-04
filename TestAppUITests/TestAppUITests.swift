//
//  TestAppUITests.swift
//  TestAppUITests
//

import XCTest

final class TestAppUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    @MainActor
    func testAppLaunch() throws {
        app.launch()
        XCTAssertTrue(app.state == .runningForeground)
    }
    
    @MainActor
    func testCharacterListExists() throws {
        app.launch()
        
        let characterList = app.scrollViews.firstMatch
        XCTAssertTrue(characterList.waitForExistence(timeout: 10), "Character list non-existent")
    }
    
    @MainActor
    func testTapFirstCharacter() throws {
        app.launch()
        
        let characterList = app.scrollViews.firstMatch
        XCTAssertTrue(characterList.waitForExistence(timeout: 10), "Character list non-existent")
        
        let firstCharacterView = characterList.buttons.firstMatch
        XCTAssertTrue(firstCharacterView.exists, "Character list is empty")
        
        let firstStaticTextBeforeTap = firstCharacterView.staticTexts.firstMatch
        XCTAssertTrue(firstStaticTextBeforeTap.exists, "First static text should exist in character view")
        let textBeforeTap = firstStaticTextBeforeTap.label
        
        firstCharacterView.tap()
        
        let firstStaticTextAfterTap = app.staticTexts.firstMatch
        XCTAssertTrue(firstStaticTextAfterTap.waitForExistence(timeout: 10), "First static text should exist in detail view")
        let textAfterTap = firstStaticTextAfterTap.label
        
        XCTAssertEqual(textBeforeTap, textAfterTap, "The first static text should be the same before and after tap")
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            app.launch()
            app.terminate()
        }
    }
}
