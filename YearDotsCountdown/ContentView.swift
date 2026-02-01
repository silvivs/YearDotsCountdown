//
//  ContentView.swift
//  YearDotsCountdown
//
//  Created by Philipe Silva on 10/01/2026.
//

import SwiftUI
import SwiftData
import Combine

struct ContentView: View {
    // MARK: - Persistence Properties
    @Environment(\.modelContext) private var modelContext
    @Query private var milestones: [LifeMilestone] // Fetches saved milestones
    
    // MARK: State Properties
    @State private var now = Date()
    @State private var isPulsing = false
    @State private var showingAddMilestone = false // Controls the sheet
    
    // MARK: - Interaction State
    // Keeps track of which milestone is currently selected by the user
    @State private var selectedMilestone: LifeMilestone?
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // 1. Automatic calculation of days in the year (includes leap years)
    var daysInYear: Int {
        let year = Calendar.current.component(.year, from: Date())
        let dateComponents = DateComponents(year: year)
        if let date = Calendar.current.date(from: dateComponents),
           let range = Calendar.current.range(of: .day, in: .year, for: date) {
            return range.count
        }
        return 365
    }
    
    // 2. Find out what today's date number is (1 to 366)
    var currentDayOfYear: Int {
        Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
    }
    
    // 3. The current year
    var currentYear: String {
        let year = Calendar.current.component(.year, from: Date())
        return String(year) // E.g.: This converts the number 2026 into text "2026"
    }
    
    // 3.1 Get the next year as a number (e.g., 2027)
    var nextYearValue: Int {
        let currentYearInt = Calendar.current.component(.year, from: now)
        return currentYearInt + 1
    }
    
    // 4. Variable to calculate how much time is left
        var timeRemaining: String {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: now)
            
            // Atempt to get the first second of January 1st of the next year
            guard let nextYearDate = calendar.date(from: DateComponents(year: year + 1)) else { return "" }
            
            let diff = calendar.dateComponents([.day, .hour, .minute, .second], from: now, to: nextYearDate)
            
            // Formatting the string with the target year
            return "\(diff.day ?? 0)d \(diff.hour ?? 0)h \(diff.minute ?? 0)m \(diff.second ?? 0)s to \(nextYearValue)"
        }
    
    // Function to calculate the time until an event
    func timeUntil(_ date: Date) -> String {
        let calendar = Calendar.current
        let diff = calendar.dateComponents([.day, .hour, .minute, .second], from: now, to: date)
        
        let d = diff.day ?? 0
        let h = diff.hour ?? 0
        let m = diff.minute ?? 0
        let s = diff.second ?? 0
        
        if d < 0 || h < 0 || m < 0 || s < 0 {
            return "Happened!"
        }
        
        return "\(d)d \(h)h \(m)m \(s)s left"
        
    }
    
    // Grid configuration (20 columns of points)
    let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 20)
    
    // MARK: Body
    var body: some View {
        NavigationStack {
            ScrollView {
                // alignment: .leading keeps everything to the left
                VStack(alignment: .leading, spacing: 20) {
                    
                    // TITLE SECTION
                    HStack(spacing: 6) {
                        Text("\(currentYear)")
                            .foregroundColor(.red)
                            .font(.system(size: 34, weight: .bold)) // Large title size
                        
                        Text("Year Tracker")
                            .font(.system(size: 34, weight: .bold))
                    }
                    .padding(.horizontal) // Aligns with the rest of your content
                    
                    headerView // This is "Today is 10" section
                    
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(1...daysInYear, id: \.self) { day in
                            dotView(for: day)
                        }
                    }
                    .id(milestones.count) // This forces a redraw whenever a new milestone is saved
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    if let milestone = selectedMilestone {
                        milestoneDetailCard(milestone)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .padding(.top) // Adds some space at the very top
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddMilestone = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddMilestone) {
                AddMilestoneView(milestoneToEdit: selectedMilestone)
            }
        }
    }
    
    // Header component
    var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                 Text("Today is \(currentDayOfYear) of \(daysInYear)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                   // .transition(.opacity)
                
                
                // Interactive counter
                Text(timeRemaining)
                    .font(.system(.title3, design: .monospaced))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .onReceive(timer) { input in
                            now = input // this updates the counter each second
                    }
                
                Text("Progress: \(Double(currentDayOfYear) / Double(daysInYear) * 100, specifier: "%.1f")%")
                    .font(.caption)
                    .bold()
            }
            Spacer()
        }
        .padding(.horizontal)
    }

    // Function that draw each dot
    
    @ViewBuilder
    func dotView(for day: Int) -> some View {
        // MARK: - Refine Milestone Search
        let dayMilestones = milestones.first { item in
            // Get the day number (1-366) for the saved date and the current dot
            let milestoneDay = Calendar.current.ordinality(of: .day, in: .year, for: item.date)
            let milestoneYear = Calendar.current.component(.year, from: item.date)
            let currentYearInt = Calendar.current.component(.year, from: Date())
            
            // Only show if it matches the day AND year
            return milestoneDay == day && milestoneYear == currentYearInt
        }
        
        if let milestone = dayMilestones {
            // MILESTONE: Special highlight with tap interaction
            Circle()
                .fill(Color.purple)
                .frame(width: 10, height: 10)
                .shadow(color: .purple.opacity(0.6), radius: 4)
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 1)
                )
            // Action when the user taps the milestone dot
                .onTapGesture {
                    triggerHaptics()
                    withAnimation(.spring()) {
                        selectedMilestone = milestone
                    }
                }
        } else if day == currentDayOfYear {
            // Today: Pulsing green dot
            Circle()
                .fill(Color.green)
                .frame(width: 10, height: 10)
                .scaleEffect(isPulsing ? 1.4 : 1.0)
                .shadow(color: .green, radius: isPulsing ? 6 : 2)
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isPulsing)
                .onAppear {
                    isPulsing = true
                }
        } else if day < currentDayOfYear {
            // PAST: static blue
            Circle()
                .fill(Color.blue.opacity(0.6))
                .frame(width: 8, height: 8)
        } else {
            // FUTURE: static gray
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 8, height: 8)
        }
    }
    
    // MARK: - Database Actions
    private func deleteMilestone(_ milestone: LifeMilestone) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        withAnimation {
            modelContext.delete(milestone)
            selectedMilestone = nil
        }
    }
    
    // MARK: - Haptics
    func triggerHaptics() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    // MARK: - Detail View Component
    @ViewBuilder
    private func milestoneDetailCard(_ milestone: LifeMilestone) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Selected Event")
                    .font(.caption2)
                    .textCase(.uppercase)
                    .foregroundColor(.secondary)

                Text(milestone.title)
                    .font(.headline)
                    .foregroundColor(.purple)
                
                // Specific counter until to selected event
                Text(timeUntil(milestone.date))
                    .font(.system(.caption, design: .monospaced))
                    .fontWeight(.semibold)
                    .foregroundColor(.purple.opacity(0.8))
            }

            Spacer()
            
            // Edit button
            Button {
                showingAddMilestone = true
            } label: {
                Image(systemName: "pencil.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title3)
            }
            .padding(.trailing, 4)
            
            // Delete button
            Button {
                deleteMilestone(milestone)
            } label: {
                Image(systemName: "trash.fill")
                    .foregroundColor(.red)
                    .padding(8)
                    .background(Color.red.opacity(0.1))
                    .clipShape(Circle())
            }
            
            // Close button
            Button {
                withAnimation { selectedMilestone = nil}
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .font(.title3)
            }
        }
        .padding()
        .background(Color.purple.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.purple.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal)
    }
    
}
#Preview {
    ContentView()
}
