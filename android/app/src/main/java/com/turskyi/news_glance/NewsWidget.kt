package com.turskyi.news_glance

import android.annotation.SuppressLint
import android.annotation.TargetApi
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.os.Build
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin

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
        val title: String? = widgetData.getString("headline_title", null)
        setTextViewText(R.id.headline_title, title ?: "No title set")

        val description: String? = widgetData.getString("headline_description", null)
        setTextViewText(R.id.headline_description, description ?: "No description set")
    }

    appWidgetManager.updateAppWidget(appWidgetId, views)
}