//
//  BasePage.swift
//  YearDotsCountdown
//
//  Created by Jónatas Silva on 16/09/26.
//

// MARK: - Summary

/// This code defines a BasePage class for UI testing using Apple's XCTest framework. It serves as a reusable foundation for the Page Object Model pattern. The class holds a reference to the app being tested and includes a helper function, waitForElement, which waits up to a specified timeout for a UI element to appear and automatically fails the test if it doesn't.

// MARK: - Scope

import XCTest

class BasePage {
    let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    // Reusable helper to wait for elements
    @discardableResult
    func waitForElement(_ element: XCUIElement, timeout: TimeInterval = 5, file: StaticString = #filePath, line: UInt = #line) -> Bool {
        let exists = element.waitForExistence(timeout: timeout)
        XCTAssertTrue(exists, "Element \(element) did not appear in \(timeout) seconds.", file: file, line: line)
        return exists
    }
    
    /// HOW TO USE IT
    /// You typically call this method within your UI test classes (or Page Objects) to ensure an element is ready before interacting with it.
    
    /// BASIC USAGE:
    /*
    
     let myButton = app.buttons["MyButton"]
     waitForElement(myButton)
     myButton.tap()
    
     */
    
    /// SPECIFYING A CUSTOM TIMEOUT:
    /// If you know an element might take longer to appear, such as after a network request, you can increase the timeout:
    /*
     
     let loadingSpinner = app.activityIndicators["Loading"]
     waitForElement(loadingSpinner, timeout: 10)
     
     */
    
    /// USING THE RETURN VALUE
    /// Because it is marked with @discardableResult, you can ignore the return value (as shown above) or use it to conditionally perform actions:
    /*
     
     if waitForElement(welcomeLabel, timeout: 2) {
         // Perform actions for a logged-in user
     } else {
         // Perform actions for a new user
     }
     
     */
    
}
