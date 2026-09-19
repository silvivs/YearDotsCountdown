//
//  MainScreenPage.swift
//  YearDotsCountdown
//
//  Created by Jónatas Silva on 16/09/26.
//

import XCTest

// MARK: - Summary

/// This Page contains elements, actions and validations from Main screen.

final class MainScreenPage: BasePage {
    
    // MARK: - Elements
    
    var dragButton: XCUIElement {
        app.buttons["line.3.horizontal"]
    } // Drag button
    
    var plusCircle: XCUIElement {
        app.buttons["plus.circle.fill"]
    } // Add button
    
    var goLeftButton: XCUIElement {
        app.buttons["chevron.left.circle.fill"]
    } // Go left button: this button changes the year to a year prior to the selected year
    
    var goRightButton: XCUIElement {
        app.buttons["chevron.right.circle.fill"]
    } // Go right button: this button changes the year to the next year to the current selected
    
    var screenTitle: XCUIElement {
            app.staticTexts["Year Tracker"]
        } // The app title: Year Tracker is a immutable text

    // MARK: - Actions
    
    func tapDragButton() {
        waitForElement(dragButton, timeout: 10)
        dragButton.tap()
    }
    
    func tapPlusCircle() {
        waitForElement(plusCircle, timeout: 10)
        plusCircle.tap()
    }
    
    func tapGoLeftButton() {
        waitForElement(goLeftButton, timeout: 10)
        goLeftButton.tap()
    }
    
    func tapGoRightButton() {
        waitForElement(goRightButton, timeout: 10)
        goRightButton.tap()
    }
    
    // MARK: - Validations
    @discardableResult
        func verifyIsOnMainScreen(timeout: TimeInterval = 5, file: StaticString = #filePath, line: UInt = #line) -> MainScreenPage {
            let exists = screenTitle.waitForExistence(timeout: timeout)
            XCTAssertTrue(
                exists,
                "Failed to verify Year Tracker screen: Title element 'Year Tracker' not found.",
                file: file,
                line: line
            )
            return self
        }
    
}
