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
    val views: RemoteViews = RemoteViews(context.packageName, R.layout.news_widget).apply {
        // Open App on Widget Click
        val pendingIntent: PendingIntent =
            HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java
            )
        setOnClickPendingIntent(R.id.widget_container, pendingIntent)

        // Read signal data
        val signalLevel: String? = widgetData.getString("signal_level", null)
        val conclusion: String? =
            widgetData.getString("signal_conclusion", null)
        val probability: Int = widgetData.getInt("signal_probability", 0)
        val category: String? = widgetData.getString("signal_category", null)

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
            setViewVisibility(R.id.signal_metadata, android.view.View.VISIBLE)
        } else {
            setViewVisibility(R.id.signal_metadata, android.view.View.GONE)
        }

        // Set branding footer with timestamp
        val dateFormat = SimpleDateFormat("MMM d, h:mm a", Locale.getDefault())
        val formattedDate = dateFormat.format(Date())
        val timestampText = "News Glance\nfrom $formattedDate"
        setTextViewText(R.id.widget_timestamp, timestampText)
        setTextColor(R.id.widget_timestamp, style.textColor)
    }

    appWidgetManager.updateAppWidget(appWidgetId, views)
}