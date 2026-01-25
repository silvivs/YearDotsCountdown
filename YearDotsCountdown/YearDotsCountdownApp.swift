//
//  YearDotsCountdownApp.swift
//  YearDotsCountdown
//
//  Created by Jónatas Silva on 10/01/26.
//

import SwiftUI
import SwiftData

@main
struct YearDotsCountdownApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Initializing the persistent container for LifeMilestone
        .modelContainer(for: LifeMilestone.self)
    }
}
