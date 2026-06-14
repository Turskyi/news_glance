package com.turskyi.news_glance

import android.annotation.SuppressLint
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Color
import android.os.Build
import android.widget.RemoteViews
import androidx.annotation.RequiresApi
import androidx.core.graphics.toColorInt
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

// Keys for SharedPreferences
private const val KEY_WIDGET_STYLE = "widget_style"
private const val KEY_LOCALE = "locale"
private const val KEY_HEADLINE_DESCRIPTION = "headline_description"
private const val KEY_SIGNAL_CONCLUSION = "signal_conclusion"
private const val KEY_SIGNAL_LEVEL = "signal_level"
private const val KEY_SIGNAL_PROBABILITY = "signal_probability"
private const val KEY_SIGNAL_CATEGORY = "signal_category"

// Supported Locales
private const val LOCALE_EN = "en"
private const val LOCALE_UK = "uk"

// Widget Styles
private const val STYLE_INSIGHT = "insight"
private const val STYLE_CONCLUSION = "conclusion"
private const val STYLE_SUMMARY = "summary"

// Signal Levels
private const val LEVEL_CRITICAL = "CRITICAL"
private const val LEVEL_WARNING = "WARNING"
private const val LEVEL_ADVISORY = "ADVISORY"
private const val LEVEL_NEUTRAL = "NEUTRAL"

/**
 * Implementation of App Widget functionality.
 */
@SuppressLint("ObsoleteSdkInt")
@RequiresApi(Build.VERSION_CODES.CUPCAKE)
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
        LEVEL_CRITICAL -> SignalStyle(
            bgColor = "#FFF1F2".toColorInt(), // Lighter red
            borderColor = "#FDA4AF".toColorInt(),
            textColor = "#9F1239".toColorInt(), // Deeper red for text
            icon = "🚨",
            label = "CRITICAL ACTION"
        )

        LEVEL_WARNING -> SignalStyle(
            bgColor = "#FFFBEB".toColorInt(), // Light yellow
            borderColor = "#FDE68A".toColorInt(),
            textColor = "#92400E".toColorInt(), // Brownish orange for text
            icon = "⚠️",
            label = "WARNING"
        )

        LEVEL_ADVISORY -> SignalStyle(
            bgColor = "#F0F9FF".toColorInt(), // Very light blue
            borderColor = "#BAE6FD".toColorInt(),
            textColor = "#075985".toColorInt(), // Deep blue for text
            icon = "ℹ️",
            label = "ADVISORY"
        )

        else -> SignalStyle(
            bgColor = "#F0FDF4".toColorInt(), // Very light green
            borderColor = "#BBF7D0".toColorInt(),
            textColor = "#166534".toColorInt(), // Deep green for text
            icon = "✅",
            label = "ALL CLEAR"
        )
    }
}

@SuppressLint("ObsoleteSdkInt")
@RequiresApi(Build.VERSION_CODES.CUPCAKE)
internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    // Get reference to SharedPreferences
    val widgetData: SharedPreferences = HomeWidgetPlugin.getData(context)
    val widgetStyle: String? =
        widgetData.getString(KEY_WIDGET_STYLE, STYLE_INSIGHT)
    val localeString: String =
        widgetData.getString(KEY_LOCALE, LOCALE_EN) ?: LOCALE_EN
    val locale: Locale = Locale.forLanguageTag(
        localeString.replace('_', '-'),
    )
    val isUkrainian: Boolean = localeString.startsWith(LOCALE_UK)
    val fromLabel: String = if (isUkrainian) "від" else "from"

    val layoutRes = when (widgetStyle) {
        STYLE_CONCLUSION -> R.layout.news_widget_conclusion
        STYLE_SUMMARY -> R.layout.news_widget_summary
        else -> R.layout.news_widget
    }

    val views: RemoteViews = RemoteViews(
        context.packageName,
        layoutRes,
    ).apply {
        // Open App on Widget Click
        val pendingIntent: PendingIntent =
            HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java
            )
        setOnClickPendingIntent(R.id.widget_container, pendingIntent)

        when (widgetStyle) {
            STYLE_CONCLUSION -> {
                // Derive title for conclusion layout as a date-based headline
                val description: String? = widgetData.getString(
                    KEY_HEADLINE_DESCRIPTION, null,
                )

                // Use a compact date (YYYY-MM-DD) for the headline title to
                // match legacy style.
                val dateFormatTitle =
                    SimpleDateFormat("yyyy-MM-dd", locale)
                val formattedDateTitle = dateFormatTitle.format(Date())
                val titleToShow = "News Glance $fromLabel $formattedDateTitle"

                // Map conclusion style into headline views (white text for
                // dark bg)
                setTextViewText(R.id.headline_title, titleToShow)
                setViewVisibility(
                    R.id.headline_title,
                    android.view.View.VISIBLE
                )
                setTextColor(R.id.headline_title, Color.WHITE)

                val noInsightText =
                    if (isUkrainian) "Дані відсутні" else "No insight available"
                setTextViewText(
                    R.id.headline_description,
                    description ?: noInsightText
                )
                setTextColor(R.id.headline_description, Color.WHITE)

                // branding footer (conclusion layout)
                val dateFormatConclusion =
                    SimpleDateFormat("MMM d, h:mm a", locale)
                val formattedDateConclusion =
                    dateFormatConclusion.format(Date())
                val timestampTextConclusion =
                    "News Glance\n$fromLabel $formattedDateConclusion"
                setTextViewText(
                    R.id.widget_timestamp,
                    timestampTextConclusion,
                )
                setTextColor(R.id.widget_timestamp, Color.WHITE)

            }

            STYLE_SUMMARY -> {
                val summary: String? =
                    widgetData.getString(KEY_SIGNAL_CONCLUSION, null)

                // Localize Summary header
                val headerText =
                    if (isUkrainian) "👋 ПІДСУМОК" else "👋 SUMMARY"
                setTextViewText(R.id.summary_header, headerText)

                if (summary != null) {
                    val lines = summary.split("\n")
                    var title: String? = null
                    val bodyLines = mutableListOf<String>()

                    for (line in lines) {
                        val trimmedLine = line.trim()
                        if (trimmedLine.startsWith("#")) {
                            val headerText = trimmedLine
                                .replace(
                                    "^#+\\s*".toRegex(),
                                    "",
                                )
                                .replace("**", "")
                                .trim()
                            if (title == null) {
                                title = headerText
                            } else {
                                bodyLines.add(headerText)
                            }
                        } else if (line.isNotBlank() || bodyLines.isNotEmpty()) {
                            bodyLines.add(
                                line.replace(
                                    "**",
                                    "",
                                ).trim(),
                            )
                        }
                    }

                    if (title != null) {
                        setTextViewText(
                            R.id.headline_title,
                            title,
                        )
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
                    val noSummaryText = if (isUkrainian)
                        "Підсумок відсутній"
                    else "No summary available"
                    setTextViewText(
                        R.id.headline_description,
                        noSummaryText
                    )
                    setViewVisibility(
                        R.id.headline_title,
                        android.view.View.GONE
                    )
                }

                // branding footer (summary layout)
                val dateFormat =
                    SimpleDateFormat("HH:mm", locale)
                val formattedDate = dateFormat.format(Date())
                val timestampText = "News Glance • $formattedDate"
                setTextViewText(R.id.widget_timestamp, timestampText)

            }

            else -> {
                val signalLevel: String? =
                    widgetData.getString(KEY_SIGNAL_LEVEL, null)
                val conclusion: String? =
                    widgetData.getString(KEY_SIGNAL_CONCLUSION, null)
                val probability: Int =
                    widgetData.getInt(KEY_SIGNAL_PROBABILITY, 0)
                val category: String? =
                    widgetData.getString(KEY_SIGNAL_CATEGORY, null)

                val style = getSignalStyle(signalLevel)

                // Set background colour
                setInt(
                    R.id.widget_container,
                    "setBackgroundColor",
                    style.bgColor
                )

                // Set icon
                setTextViewText(R.id.signal_icon, style.icon)
                setTextColor(R.id.signal_icon, style.textColor)

                // Set signal label and level
                setTextViewText(R.id.headline_title, style.label)
                setTextColor(R.id.headline_title, style.textColor)

                // Set conclusion
                val noInsightText =
                    if (isUkrainian) "Дані відсутні" else "No insight available"
                val conclusionText = conclusion ?: noInsightText
                setTextViewText(
                    R.id.headline_description,
                    conclusionText,
                )
                setTextColor(
                    R.id.headline_description,
                    style.textColor,
                )

                // Set category and probability (only if not NEUTRAL)
                if (signalLevel?.uppercase() != LEVEL_NEUTRAL && category != null) {
                    val probabilityLabel =
                        if (isUkrainian) "ймовірність" else "Probability"
                    val metadata =
                        "$category • ${probability}% $probabilityLabel"
                    setTextViewText(
                        R.id.signal_metadata,
                        metadata,
                    )
                    setTextColor(R.id.signal_metadata, style.textColor)
                    setViewVisibility(
                        R.id.signal_metadata,
                        android.view.View.VISIBLE
                    )
                } else {
                    setViewVisibility(
                        R.id.signal_metadata,
                        android.view.View.GONE
                    )
                }

                // Set branding footer with timestamp
                val dateFormat =
                    SimpleDateFormat("MMM d, h:mm a", locale)
                val formattedDate = dateFormat.format(Date())
                val timestampText = "News Glance\n$fromLabel $formattedDate"
                setTextViewText(R.id.widget_timestamp, timestampText)
                setTextColor(R.id.widget_timestamp, style.textColor)
            }
        }
    }

    appWidgetManager.updateAppWidget(appWidgetId, views)
}