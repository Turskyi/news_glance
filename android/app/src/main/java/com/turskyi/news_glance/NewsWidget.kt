package com.turskyi.news_glance

import android.annotation.SuppressLint
import android.annotation.TargetApi
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Color
import android.os.Build
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * Implementation of App Widget functionality.
 */
@SuppressLint("ObsoleteSdkInt")
@TargetApi(Build.VERSION_CODES.CUPCAKE)
class NewsWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}

data class SignalStyle(
    val bgColor: Int,
    val borderColor: Int,
    val textColor: Int,
    val icon: String,
    val label: String
)

internal fun getSignalStyle(level: String?): SignalStyle {
    return when (level?.uppercase()) {
        "CRITICAL" -> SignalStyle(
            bgColor = Color.parseColor("#FFF1F2"), // Lighter red
            borderColor = Color.parseColor("#FDA4AF"),
            textColor = Color.parseColor("#9F1239"), // Deeper red for text
            icon = "🚨",
            label = "CRITICAL ACTION"
        )

        "WARNING" -> SignalStyle(
            bgColor = Color.parseColor("#FFFBEB"), // Light yellow
            borderColor = Color.parseColor("#FDE68A"),
            textColor = Color.parseColor("#92400E"), // Brownish orange for text
            icon = "⚠️",
            label = "WARNING"
        )

        "ADVISORY" -> SignalStyle(
            bgColor = Color.parseColor("#F0F9FF"), // Very light blue
            borderColor = Color.parseColor("#BAE6FD"),
            textColor = Color.parseColor("#075985"), // Deep blue for text
            icon = "ℹ️",
            label = "ADVISORY"
        )

        else -> SignalStyle(
            bgColor = Color.parseColor("#F0FDF4"), // Very light green
            borderColor = Color.parseColor("#BBF7D0"),
            textColor = Color.parseColor("#166534"), // Deep green for text
            icon = "✅",
            label = "ALL CLEAR"
        )
    }
}

@SuppressLint("ObsoleteSdkInt")
@TargetApi(Build.VERSION_CODES.CUPCAKE)
internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    // Get reference to SharedPreferences
    val widgetData: SharedPreferences = HomeWidgetPlugin.getData(context)
    val widgetStyle: String? =
        widgetData.getString("widget_style", "insight")

    val layoutRes = when (widgetStyle) {
        "conclusion" -> R.layout.news_widget_conclusion
        "summary" -> R.layout.news_widget_summary
        else -> R.layout.news_widget
    }

    val views: RemoteViews = RemoteViews(context.packageName, layoutRes).apply {
        // Open App on Widget Click
        val pendingIntent: PendingIntent =
            HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java
            )
        setOnClickPendingIntent(R.id.widget_container, pendingIntent)

        if (widgetStyle == "conclusion") {
            // Derive title for conclusion layout as a date-based headline
            val description: String? =
                widgetData.getString("headline_description", null)

            // Use a compact date (YYYY-MM-DD) for the headline title to match legacy style
            val dateFormatTitle =
                SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
            val formattedDateTitle = dateFormatTitle.format(Date())
            val titleToShow = "News Glance from $formattedDateTitle"

            // Map conclusion style into headline views (white text for dark bg)
            setTextViewText(R.id.headline_title, titleToShow)
            setViewVisibility(R.id.headline_title, android.view.View.VISIBLE)
            setTextColor(R.id.headline_title, Color.WHITE)

            setTextViewText(
                R.id.headline_description,
                description ?: "No insight available"
            )
            setTextColor(R.id.headline_description, Color.WHITE)

            // branding footer (conclusion layout)
            val dateFormatConclusion =
                SimpleDateFormat("MMM d, h:mm a", Locale.getDefault())
            val formattedDateConclusion = dateFormatConclusion.format(Date())
            val timestampTextConclusion =
                "News Glance\nfrom $formattedDateConclusion"
            setTextViewText(R.id.widget_timestamp, timestampTextConclusion)
            setTextColor(R.id.widget_timestamp, Color.WHITE)

        } else if (widgetStyle == "summary") {
            val summary: String? =
                widgetData.getString("signal_conclusion", null)
            val locale = widgetData.getString("locale", "en") ?: "en"

            // Localize Summary header
            val headerText =
                if (locale.startsWith("uk")) "👋 ПІДСУМОК" else "👋 SUMMARY"
            setTextViewText(R.id.summary_header, headerText)

            if (summary != null) {
                val lines = summary.split("\n")
                var title: String? = null
                val bodyLines = mutableListOf<String>()

                for (line in lines) {
                    val trimmedLine = line.trim()
                    if (trimmedLine.startsWith("#")) {
                        val headerText = trimmedLine
                            .replace("^#+\\s*".toRegex(), "")
                            .replace("**", "")
                            .trim()
                        if (title == null) {
                            title = headerText
                        } else {
                            bodyLines.add(headerText)
                        }
                    } else if (line.isNotBlank() || bodyLines.isNotEmpty()) {
                        bodyLines.add(line.replace("**", "").trim())
                    }
                }

                if (title != null) {
                    setTextViewText(R.id.headline_title, title)
                    setViewVisibility(
                        R.id.headline_title,
                        android.view.View.VISIBLE
                    )
                } else {
                    setViewVisibility(
                        R.id.headline_title,
                        android.view.View.GONE
                    )
                }

                setTextViewText(
                    R.id.headline_description,
                    bodyLines.joinToString("\n").trim()
                )
            } else {
                setTextViewText(
                    R.id.headline_description,
                    "No summary available"
                )
                setViewVisibility(R.id.headline_title, android.view.View.GONE)
            }

            // branding footer (summary layout)
            val dateFormat =
                SimpleDateFormat("HH:mm", Locale.getDefault())
            val formattedDate = dateFormat.format(Date())
            val timestampText = "News Glance • $formattedDate"
            setTextViewText(R.id.widget_timestamp, timestampText)

        } else {
            val signalLevel: String? =
                widgetData.getString("signal_level", null)
            val conclusion: String? =
                widgetData.getString("signal_conclusion", null)
            val probability: Int = widgetData.getInt("signal_probability", 0)
            val category: String? =
                widgetData.getString("signal_category", null)

            val style = getSignalStyle(signalLevel)

            // Set background color
            setInt(R.id.widget_container, "setBackgroundColor", style.bgColor)

            // Set icon
            setTextViewText(R.id.signal_icon, style.icon)
            setTextColor(R.id.signal_icon, style.textColor)

            // Set signal label and level
            setTextViewText(R.id.headline_title, style.label)
            setTextColor(R.id.headline_title, style.textColor)

            // Set conclusion
            val conclusionText = conclusion ?: "No insight available"
            setTextViewText(R.id.headline_description, conclusionText)
            setTextColor(R.id.headline_description, style.textColor)

            // Set category and probability (only if not NEUTRAL)
            if (signalLevel?.uppercase() != "NEUTRAL" && category != null) {
                val metadata = "$category • ${probability}% Probability"
                setTextViewText(R.id.signal_metadata, metadata)
                setTextColor(R.id.signal_metadata, style.textColor)
                setViewVisibility(
                    R.id.signal_metadata,
                    android.view.View.VISIBLE
                )
            } else {
                setViewVisibility(R.id.signal_metadata, android.view.View.GONE)
            }

            // Set branding footer with timestamp
            val dateFormat =
                SimpleDateFormat("MMM d, h:mm a", Locale.getDefault())
            val formattedDate = dateFormat.format(Date())
            val timestampText = "News Glance\nfrom $formattedDate"
            setTextViewText(R.id.widget_timestamp, timestampText)
            setTextColor(R.id.widget_timestamp, style.textColor)
        }
    }

    appWidgetManager.updateAppWidget(appWidgetId, views)
}