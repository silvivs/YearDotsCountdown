//
//  LifeMilestone.swift
//  YearDotsCountdown
//
//  Created by Jónatas Silva on 24/01/26.
//

import Foundation
import SwiftData

// MARK: - Database Model
// The @Model macro enables SwiftData to save this class to the device's storage
@Model
final class LifeMilestone {
    var id: UUID = UUID()
    var date: Date
    var title: String
    
    // Default initializer for creating new entries
    init(date: Date, title: String) {
        self.date = date
        self.title = title
    }
}
