//
//  SettingsView.swift
//  YearDotsCountdown
//
//  Created by Jónatas Silva on 26/08/26.
//

import SwiftUI
import SwiftData
import UserNotifications

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var milestones: [LifeMilestone]
    
    // Preferences automatically saved to UserDefaults
    @AppStorage("selectedTheme") private var selectedTheme: String = "system"
    @AppStorage("hapticsEnabled") private var hapticsEnabled: Bool = true
    @AppStorage("defaultNotificationHour") private var notificationHour: Int = 9
    
    @State private var showingResetAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                // APPEARANCE SECTION
                Section("Appearance") {
                    Picker("Theme", selection: $selectedTheme) {
                        Text("Automatic").tag("system")
                        Text("Light").tag("light")
                        Text("Dark").tag("dark")
                    }
                    .pickerStyle(.segmented)
                    
                    Toggle("Haptic Feedback (Vibration)", isOn: $hapticsEnabled)
                }
                
                // NOTIFICATIONS SECTION
                Section("Notifications") {
                    Stepper("Reminder Time: \(notificationHour):00", value: $notificationHour, in: 6...22)
                }
                
                // DATA SECTION
                Section("Data and Storage") {
                    HStack {
                        Text("Total Milestones Saved")
                        Spacer()
                        Text("\(milestones.count)")
                            .foregroundColor(.secondary)
                    }
                    
                    Button(role: .destructive) {
                        showingResetAlert = true
                    } label: {
                        Label("Delete All Events", systemImage: "trash")
                    }
                }
                
                // ABOUT SECTION
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Adjustments")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Completed") {
                        dismiss()
                    }
                }
            }
            .alert("Delete all events?", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete All", role: .destructive) {
                    resetAllData()
                }
            } message: {
                Text("This action cannot be undone. All milestones and scheduled notifications will be deleted.")
            }
            .onChange(of: selectedTheme) { _, newValue in
                ThemeManager.applyTheme(newValue)
            }
        }
    }
    
    // Logic to clear everything
    private func resetAllData() {
        for milestone in milestones {
            cancelNotification(for: milestone)
            modelContext.delete(milestone)
        }
        try? modelContext.save()
    }
}
