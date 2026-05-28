//
//  YearDotsCountdownTests.swift
//  YearDotsCountdownTests
//
//  Created by Jónatas Silva on 06/02/26.
//

import XCTest

@testable import YearDotsCountdown

final class YearDotsCountdownTests: XCTestCase {
    var contentView: ContentView!
    
    override func setUp() {
        super.setUp()
        contentView = ContentView()
    }
    
    override func tearDown() {
        contentView = nil
        super.tearDown()
    }
    
    // TEST 1: To verify if the counting of the days of the year make sense
    func testDaysInYear() {
        let days = contentView.daysInYear
        XCTAssertTrue(days == 365 || days == 366, "Error: The year should have either 365 or 366 days")
    }
    
    // TEST 2: To verify the logic of "Happened!" function
    func testTimeUntilPastEvent() {
        // Creating past date
        let pastDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let result = contentView.timeUntil(pastDate)
        
        XCTAssertEqual(result, "Happened!", "Error: The function should return 'Happened!' for a past date")
    }
    
    // TEST 3: To verify if the counter shows the string "left" for future events
    func testTimeUntilFutureEvent() {
        // Create a date set 2 days in the future.
        let futureDate = Calendar.current.date(byAdding: .day, value: 2, to: Date())!
        let result = contentView.timeUntil(futureDate)
        
        // Check if the resulting string ends with "left".
        XCTAssertTrue(result.contains("left"), "Erro: It should indicate the remaining time with 'left'")
    }
}
