import SwiftUI
import SwiftData

struct AddMilestoneView: View {
    // 1. Getting the model context from the environment
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var date: Date = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Milestone Title", text: $title)
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            .navigationTitle("New Milestone")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    // AddMilestoneView.swift - Save Button logic
                    Button("Save") {
                        let newMilestone = LifeMilestone(date: date, title: title)
                        
                        // Attempt to insert and save
                        modelContext.insert(newMilestone)
                        
                        do {
                            try modelContext.save()
                            print("✅ Success: Saved '\(title)' to database.")
                        } catch {
                            print("❌ Error: Failed to save milestone: \(error.localizedDescription)")
                        }
                        
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}
