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
    @AppStorage("selectedTheme") private var selectedTheme: String = "System"
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    ThemeManager.applyTheme(selectedTheme)
                }
        }
        // Initializing the persistent container for LifeMilestone
        .modelContainer(for: LifeMilestone.self)
    }
}
