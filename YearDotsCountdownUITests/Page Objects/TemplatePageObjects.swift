//
//  TemplatePageObjects.swift
//  YearDotsCountdown
//
//  Created by Jónatas Silva on 16/09/26.
//

final class SampleScreenPageObject: BasePage {

    // =========================================================================
    // MARK: - 1. ELEMENTS (Inspector-Based Mapping)
    // =========================================================================
    
    // Pattern 1: By Identifier (Recommended - Uses the 'Identifier' field from Accessibility Inspector)
    var dragButton: XCUIElement {
        app.buttons["line.3.horizontal"]
    }
    
    // Pattern 2: By Label (Fallback - Uses the 'Label' field when Identifier is unavailable)
    var titleText: XCUIElement {
        app.staticTexts["YearDots"]
    }
    
    // Pattern 3: Common SwiftUI UI Element types
    // app.buttons[...]       -> Navigation bar items, custom buttons
    // app.textFields[...]    -> Input fields
    // app.switches[...]      -> Toggle switches
    // app.images[...]        -> Icons or static images
    // app.cells[...]         -> List rows or LazyVStack items


    // =========================================================================
    // MARK: - 2. ACTIONS (User Interactions)
    // =========================================================================
    
    @discardableResult
    func tapDragButton() -> SampleScreenPageObject {
        dragButton.tap()
        return self // Enables Method Chaining / Fluent API
    }

    @discardableResult
    func enterEventName(_ name: String) -> SampleScreenPageObject {
        // Example action with user input
        // eventNameTextField.tap()
        // eventNameTextField.typeText(name)
        return self
    }


    // =========================================================================
    // MARK: - 3. VALIDATIONS (Assertions & State Checks)
    // =========================================================================
    
    @discardableResult
    func verifyDragButtonIsVisible(file: StaticString = #filePath, line: UInt = #line) -> SampleScreenPageObject {
        waitForElement(dragButton, file: file, line: line)
        return self
    }

    @discardableResult
    func verifyTitleIsCorrect(_ expectedTitle: String, file: StaticString = #filePath, line: UInt = #line) -> SampleScreenPageObject {
        XCTAssertEqual(titleText.label, expectedTitle, "Screen title does not match expected value.", file: file, line: line)
        return self
    }
}
