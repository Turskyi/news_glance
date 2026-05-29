//
//  NewsWidgets.swift
//  NewsWidgets
//
//  Created by Dmytro on 2024-02-19.
//

import WidgetKit
import SwiftUI
import MarkdownUI

struct Provider: TimelineProvider {
    // Placeholder is used as a placeholder when the widget is first displayed
    func placeholder(in context: Context) -> SignalEntry {
        SignalEntry(
            date: Date(),
            level: "NEUTRAL",
            conclusion: "Placeholder description",
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
            let userDefaults = UserDefaults(suiteName: "group.dmytrowidget")
            let widgetStyle = userDefaults?.string(forKey: "widget_style") ?? "insight"
            let locale = userDefaults?.string(forKey: "locale") ?? "en"

            if widgetStyle == "conclusion" {
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
    
    //    getTimeline is called for the current and optionally future times to update the widget
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

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

struct NewsWidgetsEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        // Legacy conclusion layout
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
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                        .padding(12)

                    Spacer(minLength: 0)

                    // Footer with timestamp at bottom
                    let dateFormatter: DateFormatter = {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "MMM d, h:mm a"
                        return formatter
                    }()
                    let formattedDate = dateFormatter.string(from: entry.date)

                    Text("News Glance\nfrom \(formattedDate)")
                        .font(.system(size: 10, weight: .medium))
                        .lineLimit(2)
                        .foregroundColor(.white)
                        .opacity(0.7)
                        .tracking(0.2)
                        .padding(10)
                }
            }
        } else if entry.style == "summary" {
            ZStack {
                // Background with a subtle gradient and a darker shade
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.10, green: 0.10, blue: 0.12),
                        Color(red: 0.05, green: 0.05, blue: 0.06)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(entry.locale.hasPrefix("uk") ? "👋 Підсумок" : "👋 Summary")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(.white.opacity(0.6))
                            .tracking(1.2)
                            .textCase(.uppercase)
                        Spacer()
                    }

                    Markdown(entry.conclusion)
                        .markdownTheme(.summaryTheme)

                    Spacer(minLength: 4)

                    HStack {
                        let dateFormatter: DateFormatter = {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "HH:mm"
                            return formatter
                        }()
                        Text("News Glance • \(dateFormatter.string(from: entry.date))")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.white.opacity(0.35))
                        Spacer()
                    }
                }
                .padding(14)
            }
        } else {
            // Insight style (existing)
            let style = getSignalStyle(entry.level)
            let isHighRisk = entry.level.uppercased() != "NEUTRAL" && entry.probability >= 80
            let isNeutral = entry.level.uppercased() == "NEUTRAL"
            let dateFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM d, h:mm a"
                return formatter
            }()
            let formattedDate = dateFormatter.string(from: entry.date)

            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(style.bgColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(style.borderColor, lineWidth: 2)
                    )

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 40, height: 40)

                            Text(style.icon)
                                .font(.system(size: 24))
                        }

                        VStack(alignment: .leading, spacing: 1) {
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(style.lightColor)
                                    .frame(width: 5, height: 5)
                                    .shadow(color: style.lightColor.opacity(0.6), radius: 2, x: 0, y: 0)

                                Text(style.label)
                                    .font(.system(size: 11, weight: .bold))
                                    .tracking(0.4)
                                    .textCase(.uppercase)
                                    .foregroundColor(style.textColor)
                            }

                            if !isNeutral {
                                Text("\(entry.category) • \(entry.probability)%")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(isHighRisk ? Color(red: 0.88, green: 0.11, blue: 0.29) : style.textColor.opacity(0.75))
                                    .lineLimit(1)
                            } else {
                                Text("All Clear")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(style.textColor.opacity(0.6))
                            }
                        }

                        Spacer()
                    }

                    Text(entry.conclusion)
                        .font(.system(size: 12, weight: .regular))
                        .lineLimit(4)
                        .foregroundColor(style.textColor)

                    Spacer(minLength: 0)

                    Text("News Glance\nfrom \(formattedDate)")
                        .font(.system(size: 9, weight: .medium))
                        .lineLimit(2)
                        .foregroundColor(style.textColor.opacity(0.5))
                        .tracking(0.2)
                }
                .padding(10)
            }
            .padding()
        }
    }
    
    init(entry: Provider.Entry){
        self.entry = entry
    }
}

struct NewsWidgets: Widget {
    let kind: String = "NewsWidgets"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                NewsWidgetsEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                NewsWidgetsEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    NewsWidgets()
} timeline: {
    SignalEntry(date: .now, level: "CRITICAL", conclusion: "Urgent: Market volatility alert", probability: 92, category: "FINANCE", style: "insight", locale: "en")
    SignalEntry(date: .now, level: "ADVISORY", conclusion: "Flight delays reported at major airports", probability: 75, category: "TRAVEL", style: "insight", locale: "en")
    SignalEntry(date: .now, level: "NEUTRAL", conclusion: "## The Vibe Check\nMarkets stable, no immediate action needed", probability: 0, category: "GENERAL", style: "summary", locale: "en")
}

// Signal entry with structured data
struct SignalEntry: TimelineEntry {
    let date: Date
    let level: String
    let conclusion: String
    let probability: Int
    let category: String
    let style: String
    let locale: String
}

extension Theme {
    static let summaryTheme = Theme()
    .text {
        ForegroundColor(.white.opacity(0.9))
        FontSize(13)
    }
    .heading2 { configuration in
        configuration.label
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.white)
            .padding(.top, 4)
            .padding(.bottom, 2)
    }
}
