//
//  YearDotsCountdownTests.swift
//  YearDotsCountdownTests
//
//  Created by Philipe Silva on 10/01/26.
//

import Testing
@testable import YearDotsCountdown

struct YearDotsCountdownTests {

    @Test func testDaysInYear() {
        let app = ContentView()
        #expect(app.daysInYear == 365)
    }

}
