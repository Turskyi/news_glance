//
//  NewsWidgets.swift
//  NewsWidgets
//
//  Created by Dmytro on 2024-05-23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    // Placeholder is used as a placeholder when the widget is first displayed
    func placeholder(in context: Context) -> NewsArticleEntry {
        NewsArticleEntry(date: Date(), title: "Placeholder Title", description: "Placeholder description")
    }

    // Snapshot entry represents the current time and state
    func getSnapshot(in context: Context, completion: @escaping (NewsArticleEntry) -> ()) {
        let entry: NewsArticleEntry
        if context.isPreview {
            entry = placeholder(in: context)
        } else {
            // Get the data from the user defaults to display
            let userDefaults = UserDefaults(suiteName: "group.dmytrowidget")
            let title = userDefaults?.string(forKey: "headline_title") ?? "No Title Set"
            let description = userDefaults?.string(forKey: "headline_description") ?? "No Description Set"
            entry = NewsArticleEntry(date: Date(), title: title, description: description)
        }
        completion(entry)
    }

    // getTimeline is called for the current and optionally future times to update the widget
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // This just uses the snapshot function you defined earlier
        getSnapshot(in: context) { (entry) in
            // atEnd policy tells widgetkit to request a new entry after the date has passed
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

// MARK: - Widget View
struct NewsWidgetsEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            // Create the gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
                .ignoresSafeArea()

            VStack {
                Text(entry.title)
                    .font(.system(size: 18, weight: .semibold))
                    .lineLimit(2)
                    .foregroundColor(.white)

                Text(entry.description)
                    .font(.system(size: 14, weight: .regular))
                    .lineLimit(3)
                    .foregroundColor(.white)
                    .opacity(0.9)
            }
            .padding()
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
