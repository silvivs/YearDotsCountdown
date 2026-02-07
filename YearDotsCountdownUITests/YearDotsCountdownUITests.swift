//
//  YearDotsCountdownUITests.swift
//  YearDotsCountdownUITests
//
//  Created by Jónatas Silva on 10/01/26.
//

import XCTest

final class YearDotsCountdownUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    @MainActor
    func testAddMilestoneFlow() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Step 1: Try to find and tap on Add button
        let addButton = app.buttons["plus.circle.fill"]
        XCTAssert(addButton.waitForExistence(timeout: 5), "The add button was not found")
        addButton.tap()
        
        // Step 2: Type a title in the form
        let titleTextField = app.textFields["Milestone Title"]
        XCTAssertTrue(titleTextField.waitForExistence(timeout: 5), "The text field was not found")
        titleTextField.tap()
        titleTextField.typeText("Study Swift")
        
        // Step 3: Click on Save
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists)
        saveButton.tap()
        
        // Step 4: Go back to main screen and verify if the app title is displayed
        XCTAssertTrue(app.staticTexts["Year Tracker"].waitForExistence(timeout: 2), "The app title was not displayed")
    }
}
