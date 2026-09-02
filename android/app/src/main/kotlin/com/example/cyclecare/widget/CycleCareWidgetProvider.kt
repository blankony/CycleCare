package com.example.cyclecare.widget

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import com.example.cyclecare.MainActivity
import com.example.cyclecare.R
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class CycleCareWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.cyclecare_widget).apply {
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)
                setTextViewText(R.id.widget_cycle_day, widgetData.getString("cycle_day", "—") ?: "—")
                setTextViewText(R.id.widget_phase, widgetData.getString("cycle_phase", "") ?: "")
                setTextViewText(R.id.widget_next_period, widgetData.getString("next_period", "") ?: "")
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
