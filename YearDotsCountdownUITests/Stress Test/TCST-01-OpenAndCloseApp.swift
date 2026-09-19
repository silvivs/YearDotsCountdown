//
//  AppLaunchStressTests.swift
//  YearDotsCountdownUITests
//
//  Created by Jónatas Silva on 16/09/26.
//

import XCTest

final class AppLaunchStressTests: BaseTest {

    /// Stress test executing 5 launch and termination cycles to verify app startup stability
    func testAppLaunchAndCloseStress() {
        let mainPage = MainScreenPage(app: app)
        let totalIterations = 5

        for iteration in 1...totalIterations {
            XCTContext.runActivity(named: "Iteration \(iteration): Verify launch and close lifecycle") { _ in
                // 1. Verify main screen components after app launch
                mainPage.verifyIsOnMainScreen()

                // 2. Terminate the application (Simulating user closing/killing the app)
                app.terminate()
                XCTAssertEqual(app.state, .notRunning, "App should be terminated at iteration \(iteration)")

                // 3. Re-launch the application for the next iteration (if not last)
                if iteration < totalIterations {
                    app.activate()
                }
            }
        }
    }
}
