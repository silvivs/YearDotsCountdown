import SwiftUI
import SwiftData

struct AddMilestoneView: View {
    // 1. Getting the model context from the environment
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var milestoneToEdit: LifeMilestone?
    
    @State private var title: String = ""
    @State private var date: Date = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Milestone Title", text: $title)
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            .navigationTitle(milestoneToEdit == nil ? "New Milestone" : "Edit Milestone")
            .onAppear {
                if let milestone = milestoneToEdit {
                    title = milestone.title
                    date = milestone.date
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    // AddMilestoneView.swift - Save Button logic
                    Button("Save") {
                        saveMilestone()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    func saveMilestone() {
        if let milestone = milestoneToEdit {
            // Update an existing object
            milestone.title = title
            milestone.date = date
            try? modelContext.save()
        } else {
            // Create a new milestone
            let newMilestone = LifeMilestone(date: date, title: title)
            modelContext.insert(newMilestone)
            scheduleNotification(for: newMilestone)
            try? modelContext.save()
        }
        dismiss()
    }
}

// MARK: - Notification Logic
func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        if success {
            print("✅ Permission granted!")
        } else if let error = error {
            print("❌ Error: \(error.localizedDescription)")
        }
    }
}

func scheduleNotification(for milestone: LifeMilestone) {
    let content = UNMutableNotificationContent()
    content.title = "Milestone Today!"
    content.body = "Today is the day: \(milestone.title)"
    content.sound = .default
    
    // Get the day, month and year of event
    let calendar = Calendar.current
    var dateComponents = calendar.dateComponents([.year, .month, .day], from: milestone.date)
    dateComponents.hour = 9 // Notification hour
    dateComponents.minute = 0
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    
    // Using the mark ID to track when an event is deleted to delete the notification as well
    let identifier = milestone.title + milestone.date.description
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("❌ Error scheduling notification: \(error.localizedDescription)")
        }
    }
}

func cancelNotification(for milestone: LifeMilestone) {
    // The same ID created on scheduling is used
    let identifier = milestone.title + milestone.date.description
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    print("Notification cancelled for: \(milestone.title)")
}
