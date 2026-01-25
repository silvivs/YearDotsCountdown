//
//  LifeMilestone.swift
//  YearDotsCountdown
//
//  Created by Jónatas Silva on 24/01/26.
//
import Foundation
import SwiftData

@Model
final class LifeMilestone {
    // Unique identifier for the entry
    var id: UUID = UUID()
    // The date when the event occurs
    var date: Date
    // The name of the milestone
    var title: String
    
    init(date: Date, title: String) {
        self.date = date
        self.title = title
    }
}
