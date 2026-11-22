package de.mydietai.mydiet_ai

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/** Home screen widget: remaining calories of today. The app writes the texts (data/home_widget_sync.dart). */
class SattlyWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val today = SimpleDateFormat("yyyy-MM-dd", Locale.ROOT).format(Date())
        val current = widgetData.getString("day", null) == today
        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.sattly_widget).apply {
                setTextViewText(
                    R.id.widget_headline,
                    if (current) widgetData.getString("headline", "Sattly") else "Heute noch nichts eingetragen",
                )
                setTextViewText(
                    R.id.widget_detail,
                    if (current) widgetData.getString("detail", "") else "Tippen zum Eintragen",
                )
                setProgressBar(R.id.widget_progress, 100, if (current) widgetData.getInt("percent", 0) else 0, false)
                setTextViewText(R.id.widget_water_text, if (current) widgetData.getString("water", "") else "")
                setOnClickPendingIntent(
                    R.id.widget_root,
                    HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
                )
                // Opens the app, which adds the water (data/home_widget_sync.dart, waterFromWidgetLink).
                setOnClickPendingIntent(
                    R.id.widget_water,
                    HomeWidgetLaunchIntent.getActivity(
                        context,
                        MainActivity::class.java,
                        Uri.parse("sattly://water?ml=250"),
                    ),
                )
            }
            appWidgetManager.updateAppWidget(id, views)
        }
    }
}
