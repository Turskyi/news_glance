//
//  NewsWidgets.swift
//  NewsWidgets
//
//  Created by Dmytro on 2024-05-23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let appGroupIdentifier = "group.dmytrowidget"
    private let updateFrequencyKey = "news_glance_widget_update_frequency"

    // Placeholder is used as a placeholder when the widget is first displayed
    func placeholder(in context: Context) -> NewsArticleEntry {
        NewsArticleEntry(
            date: Date(),
            title: "Major News Headline",
            description: "A concise summary of the most significant events happening around the world today."
        )
    }

    // Snapshot entry represents the current time and state
    func getSnapshot(in context: Context, completion: @escaping (NewsArticleEntry) -> ()) {
        let entry: NewsArticleEntry
        if context.isPreview {
            entry = placeholder(in: context)
        } else {
            // Get the data from the user defaults to display
            let userDefaults = UserDefaults(suiteName: appGroupIdentifier)
            let title = userDefaults?.string(forKey: "headline_title") ?? "No Title Set"
            let description = userDefaults?.string(forKey: "headline_description") ?? "No Description Set"
            entry = NewsArticleEntry(date: Date(), title: title, description: description)
        }
        completion(entry)
    }

    // getTimeline is called for the current and optionally future times to update the widget
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            let currentDate = Date()
            let nextUpdateDate = Calendar.current.date(
                byAdding: .minute,
                value: self.refreshIntervalMinutes(),
                to: currentDate
            ) ?? currentDate.addingTimeInterval(86400) // Fallback to 24 hours

            let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
            completion(timeline)
        }
    }

    // Returns the widget refresh interval in minutes, as configured by the user (via Flutter app)
    // Defaults to 1440 minutes (24 hours) if not set
    // Minimum enforced at 30 minutes as per macOS widget system limits
    private func refreshIntervalMinutes() -> Int {
        guard
            let userDefaults = UserDefaults(suiteName: appGroupIdentifier),
            let minutes = userDefaults.object(forKey: updateFrequencyKey) as? Int,
            minutes > 0
        else {
            return 1440 // Default to 24 hours
        }
        return max(30, minutes) // Enforce minimum 30 minutes
    }
}

// MARK: - Widget View
struct NewsWidgetsEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            // Create the gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 8) {
                Text(entry.title)
                    .font(.system(size: 18, weight: .semibold))
                    .lineLimit(family == .systemSmall ? 2 : 3)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(entry.description)
                    .font(.system(size: 14, weight: .regular))
                    .lineLimit(family == .systemSmall ? 3 : (family == .systemMedium ? 6 : 20))
                    .foregroundColor(.white)
                    .opacity(0.9)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

// MARK: - Widget Configuration
struct NewsWidgets: Widget {
    let kind: String = "NewsWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(macOS 14.0, *) {
                NewsWidgetsEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                NewsWidgetsEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("News Glance Widget")
        .description("Display the latest news headline in your Notification Center")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Preview
#Preview(as: .systemMedium) {
    NewsWidgets()
} timeline: {
    NewsArticleEntry(date: .now, title: "Latest Tech Trends", description: "Discover the latest innovations in AI and quantum computing.")
    NewsArticleEntry(date: .now, title: "Global Market Update", description: "Stock markets show resilience amidst economic shifts.")
}

// The date and any data you want to pass into your app must conform to TimelineEntry
struct NewsArticleEntry: TimelineEntry {
    let date: Date
    let title: String
    let description: String
}
