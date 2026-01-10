import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Atualiza o widget a cada hora
        let timeline = Timeline(entries: [SimpleEntry(date: Date())], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct YearDotsWidgetEntryView : View {
    var entry: Provider.Entry

    // Simplified logic for widget
    var currentDay: Int {
        Calendar.current.ordinality(of: .day, in: .year, for: entry.date) ?? 0
    }
    
    var daysInYear: Int {
        let year = Calendar.current.component(.year, from: entry.date)
        return (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) ? 366 : 365
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Progress header
            HStack {
                Text("2026")
                    .font(.system(size: 14, weight: .black, design: .monospaced))
                Spacer()
                Text("\(String(format: "%.1f", (Double(currentDay)/Double(daysInYear))*100))%")
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            
            // Dot grade
            let columns = Array(repeating: GridItem(.flexible(), spacing: 3), count: 20)
            
            LazyVGrid(columns: columns, spacing: 3) {
                ForEach(1...daysInYear, id: \.self) { day in
                    Circle()
                        .fill(getColor(for: day))
                        .frame(width: 4, height: 4)
                }
            }
            
            Spacer(minLength: 0)
        }
        .padding(12)
    }

    // Function for colors
    func getColor(for day: Int) -> Color {
        if day == currentDay {
            return Color.orange // Highlight the current day
        } else if day < currentDay {
            return Color.green
        } else {
            return Color.gray.opacity(0.2)
        }
    }
}

struct YearDotsWidget: Widget {
    let kind: String = "YearDotsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            YearDotsWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Year Progress")
        .description("Track your year dots.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
