//
//  ContentView.swift
//  YearDotsCountdown
//
//  Created by Philipe Silva on 10/01/2026.
//

import SwiftUI
internal import Combine

struct ContentView: View {
    @State private var now = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var isPulsing = false
    
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
    
    // 4. Variable to calculate how much time is left until midnight on December 31st
    
    var timeRemaining: String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: now)
        guard let nextYear = calendar.date(from: DateComponents(year: year + 1)) else {return ""}
        
        let diff = calendar.dateComponents([.day, .hour, .minute, .second], from: now, to: nextYear)
        
        return "\(diff.day ?? 0)d \(diff.hour ?? 0)h \(diff.minute ?? 0)m \(diff.second ?? 0)s"
    }
    
    // Grid configuration (20 columns of points)
    let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 20)
    
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
                    
                    headerView // This is your "Today is 10" section
                    
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(1...daysInYear, id: \.self) { day in
                            dotView(for: day)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
                .padding(.top) // Adds some space at the very top
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
        if day == currentDayOfYear {
            // TODAY: The only day that must pulse
            Circle()
                .fill(Color.green)
                .frame(width: 10, height: 10)
                // 1. The scaleEffect only affects this circle
                .scaleEffect(isPulsing ? 1.4 : 1.0)
                .shadow(color: .green, radius: isPulsing ? 6 : 2)
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 1)
                )
                // 2. The modifier .animation linked to a specif value (Value: isPulsing)
                // This grant that the animation stay stucked only on this element
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isPulsing)
                .onAppear {
                    isPulsing = true
                }
        } else if day < currentDayOfYear {
            // PAST: static
            Circle()
                .fill(Color.blue.opacity(0.6))
                .frame(width: 8, height: 8)
        } else {
            // FUTURE: static
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 8, height :8)
        }
    }
    
}
#Preview {
    ContentView()
}
