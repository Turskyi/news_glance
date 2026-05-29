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
    func placeholder(in context: Context) -> SignalEntry {
        SignalEntry(
            date: Date(),
            level: "NEUTRAL",
            conclusion: "A concise summary of the most significant events happening around the world today.",
            probability: 0,
            category: "GENERAL",
            style: "insight",
            locale: "en"
        )
    }

    // Snapshot entry represents the current time and state
    func getSnapshot(in context: Context, completion: @escaping (SignalEntry) -> ()) {
        let entry: SignalEntry
        if context.isPreview {
            entry = placeholder(in: context)
        } else {
            // Get the data from the user defaults to display
            let userDefaults = UserDefaults(suiteName: appGroupIdentifier)
            let widgetStyle = userDefaults?.string(forKey: "widget_style") ?? "insight"
            let locale = userDefaults?.string(forKey: "locale") ?? "en"

            if widgetStyle == "conclusion" {
                // Legacy "conclusion" style uses headline_title / headline_description
                let desc = userDefaults?.string(forKey: "headline_description") ?? userDefaults?.string(forKey: "signal_conclusion") ?? "No insight available"
                entry = SignalEntry(
                    date: Date(),
                    level: "NEUTRAL",
                    conclusion: desc,
                    probability: 0,
                    category: "GENERAL",
                    style: "conclusion",
                    locale: locale
                )
            } else if widgetStyle == "summary" {
                let summary = userDefaults?.string(forKey: "signal_conclusion") ?? "No summary available"
                entry = SignalEntry(
                    date: Date(),
                    level: "NEUTRAL",
                    conclusion: summary,
                    probability: 0,
                    category: "GENERAL",
                    style: "summary",
                    locale: locale
                )
            } else {
                let level = userDefaults?.string(forKey: "signal_level") ?? "NEUTRAL"
                let conclusion = userDefaults?.string(forKey: "signal_conclusion") ?? "No insight available"
                let probability = userDefaults?.integer(forKey: "signal_probability") ?? 0
                let category = userDefaults?.string(forKey: "signal_category") ?? "GENERAL"
                entry = SignalEntry(
                    date: Date(),
                    level: level,
                    conclusion: conclusion,
                    probability: probability,
                    category: category,
                    style: "insight",
                    locale: locale
                )
            }
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

// MARK: - Signal Style
struct SignalStyle {
    let bgColor: Color
    let borderColor: Color
    let textColor: Color
    let lightColor: Color
    let icon: String
    let label: String
}

func getSignalStyle(_ level: String) -> SignalStyle {
    switch level.uppercased() {
    case "CRITICAL":
        return SignalStyle(
            bgColor: Color(red: 0.996, green: 0.949, blue: 0.949),
            borderColor: Color(red: 0.937, green: 0.267, blue: 0.267),
            textColor: Color(red: 0.6, green: 0.11, blue: 0.11),
            lightColor: Color(red: 0.937, green: 0.267, blue: 0.267),
            icon: "🚨",
            label: "CRITICAL ACTION"
        )
    case "WARNING":
        return SignalStyle(
            bgColor: Color(red: 1.0, green: 0.984, blue: 0.925),
            borderColor: Color(red: 0.961, green: 0.619, blue: 0.067),
            textColor: Color(red: 0.706, green: 0.329, blue: 0.035),
            lightColor: Color(red: 0.961, green: 0.619, blue: 0.067),
            icon: "⚠️",
            label: "WARNING"
        )
    case "ADVISORY":
        return SignalStyle(
            bgColor: Color(red: 0.938, green: 0.963, blue: 1.0),
            borderColor: Color(red: 0.231, green: 0.51, blue: 0.961),
            textColor: Color(red: 0.114, green: 0.306, blue: 0.851),
            lightColor: Color(red: 0.231, green: 0.51, blue: 0.961),
            icon: "ℹ️",
            label: "ADVISORY"
        )
    default:
        return SignalStyle(
            bgColor: Color(red: 0.925, green: 0.992, blue: 0.961),
            borderColor: Color(red: 0.063, green: 0.725, blue: 0.506),
            textColor: Color(red: 0.016, green: 0.459, blue: 0.341),
            lightColor: Color(red: 0.063, green: 0.725, blue: 0.506),
            icon: "✅",
            label: "ALL CLEAR"
        )
    }
}

// MARK: - Widget View
struct NewsWidgetsEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        // If the user selected the legacy "conclusion" style, render the legacy layout
        if entry.style == "conclusion" {
            ZStack {
                // Gradient background: blue to purple (matching Android)
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0, green: 0, blue: 1.0), // Blue
                        Color(red: 0.5, green: 0, blue: 0.5)     // Purple
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                VStack(alignment: .leading, spacing: 0) {
                    // Description fills most of the space
                    Text(entry.conclusion)
                        .font(.system(size: family == .systemSmall ? 11 : 14))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .padding(10)

                    Spacer(minLength: 0)

                    // Footer with timestamp at bottom
                    let dateFormatter: DateFormatter = {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "MMM d, h:mm a"
                        return formatter
                    }()
                    let formattedDate = dateFormatter.string(from: entry.date)

                    Text("News Glance\nfrom \(formattedDate)")
                        .font(.system(size: family == .systemSmall ? 8 : 9, weight: .medium))
                        .lineLimit(2)
                        .foregroundColor(.white)
                        .opacity(0.7)
                        .tracking(0.15)
                        .padding(8)
                }
            }
        } else if entry.style == "summary" {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.10, green: 0.10, blue: 0.12),
                        Color(red: 0.05, green: 0.05, blue: 0.06)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(entry.locale.hasPrefix("uk") ? "👋 Підсумок" : "👋 Summary")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(.white.opacity(0.6))
                            .tracking(1.2)
                            .textCase(.uppercase)
                        Spacer()
                    }

                    let (header, content) = parseMarkdown(entry.conclusion)

                    if let header = header {
                        Text(header)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                    }

                    Text(content)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)

                    Spacer(minLength: 4)

                    HStack {
                        let dateFormatter: DateFormatter = {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "HH:mm"
                            return formatter
                        }()
                        Text("News Glance • \(dateFormatter.string(from: entry.date))")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.white.opacity(0.35))
                        Spacer()
                    }
                }
                .padding(14)
            }
        } else {
            // Default (insight) style
            let style = getSignalStyle(entry.level)
            let isHighRisk = entry.level.uppercased() != "NEUTRAL" && entry.probability >= 80
            let isNeutral = entry.level.uppercased() == "NEUTRAL"
            let dateFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = family == .systemSmall ? "h:mm a" : "MMM d, h:mm a"
                return formatter
            }()
            let formattedDate = dateFormatter.string(from: entry.date)

            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(style.bgColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(style.borderColor, lineWidth: 1.5)
                    )

                VStack(alignment: .leading, spacing: family == .systemSmall ? 4 : 6) {
                    // Header with icon and signal label
                    HStack(spacing: family == .systemSmall ? 8 : 10) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(
                                    width: family == .systemSmall ? 32 : 40,
                                    height: family == .systemSmall ? 32 : 40
                                )

                            Text(style.icon)
                                .font(.system(size: family == .systemSmall ? 18 : 24))
                        }

                        VStack(alignment: .leading, spacing: 1) {
                            HStack(spacing: 3) {
                                Circle()
                                    .fill(style.lightColor)
                                    .frame(width: 4, height: 4)
                                    .shadow(color: style.lightColor.opacity(0.6), radius: 2, x: 0, y: 0)

                                Text(style.label)
                                    .font(.system(size: family == .systemSmall ? 10 : 11, weight: .bold))
                                    .tracking(0.3)
                                    .textCase(.uppercase)
                                    .foregroundColor(style.textColor)
                                    .lineLimit(1)
                            }

                            if !isNeutral {
                                Text("\(entry.category) • \(entry.probability)%")
                                    .font(.system(size: family == .systemSmall ? 8 : 9, weight: .semibold))
                                    .foregroundColor(
                                        isHighRisk ? Color(red: 0.88, green: 0.11, blue: 0.29)
                                            : style.textColor.opacity(0.7)
                                    )
                                    .lineLimit(1)
                            } else {
                                Text("All Clear")
                                    .font(.system(size: family == .systemSmall ? 8 : 9, weight: .medium))
                                    .foregroundColor(style.textColor.opacity(0.6))
                                    .lineLimit(1)
                            }
                        }

                        Spacer()
                    }

                    // Conclusion text with responsive sizing
                    Text(entry.conclusion)
                        .font(
                            .system(
                                size: family == .systemSmall ? 11 : (family == .systemMedium ? 12 : 13),
                                weight: .regular
                            )
                        )
                        .lineLimit(family == .systemSmall ? 2 : (family == .systemMedium ? 3 : 5))
                        .foregroundColor(style.textColor)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer(minLength: 0)

                    // Branding footer with timestamp
                    Text("News Glance\nfrom \(formattedDate)")
                        .font(.system(size: family == .systemSmall ? 8 : 9, weight: .medium))
                        .lineLimit(2)
                        .foregroundColor(style.textColor.opacity(0.5))
                        .tracking(0.15)
                }
                .padding(family == .systemSmall ? 8 : 10)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
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
        .description("Display the latest AI-driven insight in your Notification Center")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Preview
#Preview(as: .systemMedium) {
    NewsWidgets()
} timeline: {
    SignalEntry(date: .now, level: "CRITICAL", conclusion: "Market volatility alert: Major indices showing sharp declines", probability: 92, category: "FINANCE", style: "insight", locale: "en")
    SignalEntry(date: .now, level: "WARNING", conclusion: "Flight delays reported at major airports due to weather", probability: 78, category: "TRAVEL", style: "insight", locale: "en")
    SignalEntry(date: .now, level: "ADVISORY", conclusion: "Tech sector showing recovery, consider taking positions", probability: 65, category: "FINANCE", style: "insight", locale: "en")
    SignalEntry(date: .now, level: "NEUTRAL", conclusion: "## The Vibe Check\nMarkets stable, no immediate action required today", probability: 0, category: "GENERAL", style: "summary", locale: "en")
}

// MARK: - Entry Model
struct SignalEntry: TimelineEntry {
    let date: Date
    let level: String
    let conclusion: String
    let probability: Int
    let category: String
    let style: String
    let locale: String
}

func parseMarkdown(_ markdown: String) -> (String?, String) {
    let lines = markdown.components(separatedBy: .newlines)
    var header: String?
    var contentLines: [String] = []

    for line in lines {
        if line.hasPrefix("## ") {
            header = line.replacingOccurrences(of: "## ", with: "")
        } else if !line.isEmpty || !contentLines.isEmpty {
            contentLines.append(line)
        }
    }

    return (header, contentLines.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines))
}

