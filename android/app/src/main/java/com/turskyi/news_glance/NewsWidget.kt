package com.turskyi.news_glance

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import java.io.File

/**
 * Implementation of App Widget functionality.
 */
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

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    // Get reference to SharedPreferences
    val widgetData = HomeWidgetPlugin.getData(context)
    val views = RemoteViews(context.packageName, R.layout.news_widget).apply {

        val title = widgetData.getString("headline_title", null)
        setTextViewText(R.id.headline_title, title ?: "No title set")

        val description = widgetData.getString("headline_description", null)
        setTextViewText(R.id.headline_description, description ?: "No description set")
        // Get chart image and put it in the widget, if it exists
        val imageName = widgetData.getString("filename", null)
        val imageFile = imageName?.let { File(it) }
        val imageExists = imageFile?.exists()
        if (imageExists == true) {
            val myBitmap: Bitmap = BitmapFactory.decodeFile(imageFile.absolutePath)
            setImageViewBitmap(R.id.widget_image, myBitmap)
        } else {
            println("image not found!, looked @: $imageName")
        }
    }

    appWidgetManager.updateAppWidget(appWidgetId, views)
}