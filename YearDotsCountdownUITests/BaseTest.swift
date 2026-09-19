//
//  BaseTest.swift
//  YearDotsCountdown
//
//  Created by Jónatas Silva on 16/09/26.
//

// MARK: - Summary

/// This file defines a base class for UI testing using Apple's XCTest framework. It handles the setup and teardown processes for the application before and after each test runs.

// MARK: - Scope

import XCTest

class BaseTest: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        app = XCUIApplication()
        
        // Force English locale during UI tests to keep assertions consistent
        app.launchArguments += ["AppleLanguages", "(en)", "-AppleLocale", "en-US"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }
}
