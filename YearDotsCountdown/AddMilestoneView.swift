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
            try? modelContext.save()
        }
        dismiss()
    }
}
