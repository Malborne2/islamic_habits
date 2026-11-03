package dev.smoothchocolate.islamic_habits;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.widget.RemoteViews;

import androidx.annotation.NonNull;

import java.util.Collections;

import es.antonborri.home_widget.HomeWidgetProvider;
import es.antonborri.home_widget.HomeWidgetScheduler;

/**
 * Renders the "Prayer times" home screen widget (4x1, or 5x1 when the user
 * has resized it wide enough — see widget_prayer_times.xml /
 * widget_prayer_times_5x1.xml and {@link #pickLayout}).
 *
 * All prayer-time math happens once, in Dart, from the same PrayerHelper the
 * in-app Prayer Times screen uses (see WidgetService in lib/utility) — this
 * class only displays the already-computed, already-localized strings that
 * Flutter pushed into home_widget's SharedPreferences via HomeWidget.saveWidgetData.
 * That keeps the widget's numbers guaranteed consistent with the app and
 * keeps all i18n/RTL text formatting in one place (Dart's intl setup)
 * instead of duplicating it natively.
 *
 * The minute-by-minute countdown ticks without Flutter running: every time
 * this is invoked (initial placement, or a HomeWidgetScheduler alarm) it
 * re-arms a single HomeWidgetScheduler update one minute ahead, so the chain
 * keeps going on its own as long as a widget instance exists.
 *
 * Tapping anywhere on the widget opens the app. Transparency can be
 * re-adjusted after placement too: widget_prayer_times_info.xml declares
 * android:widgetFeatures="reconfigurable", which (on launchers that support
 * it, API 31+) adds an edit/gear entry to the widget's long-press menu that
 * reopens PrayerWidgetConfigureActivity — the same screen shown when the
 * widget is first placed.
 */
public class PrayerWidgetProvider extends HomeWidgetProvider {

    private static final int[] CELL_IDS = {
            R.id.widget_cell_0, R.id.widget_cell_1, R.id.widget_cell_2,
            R.id.widget_cell_3, R.id.widget_cell_4,
    };
    private static final int[] NAME_IDS = {
            R.id.widget_name_0, R.id.widget_name_1, R.id.widget_name_2,
            R.id.widget_name_3, R.id.widget_name_4,
    };
    private static final int[] TIME_IDS = {
            R.id.widget_time_0, R.id.widget_time_1, R.id.widget_time_2,
            R.id.widget_time_3, R.id.widget_time_4,
    };

    // Below this width the widget keeps its normal 4-cell layout; at or
    // above it, there's room for the 5-cell layout's extra breathing room.
    private static final int FIVE_CELL_MIN_WIDTH_DP = 360;

    @Override
    public void onUpdate(
            @NonNull Context context,
            @NonNull AppWidgetManager appWidgetManager,
            @NonNull int[] appWidgetIds,
            @NonNull SharedPreferences widgetData) {
        for (int appWidgetId : appWidgetIds) {
            int layoutResId = pickLayout(appWidgetManager, appWidgetId);
            RemoteViews views = buildViews(context, widgetData, layoutResId);
            appWidgetManager.updateAppWidget(appWidgetId, views);
        }

        // Keep the countdown/highlight fresh without the app running: chain
        // one more minute-ahead update every time this fires.
        HomeWidgetScheduler.INSTANCE.schedule(
                context,
                PrayerWidgetProvider.class.getName(),
                Collections.singletonList(System.currentTimeMillis() + 60_000L));
    }

    // Fires when the widget is resized (dragging its handles), separately
    // from onUpdate — this is what swaps the 4x1/5x1 layout as the user
    // drags, using whatever prayer data was last pushed.
    @Override
    public void onAppWidgetOptionsChanged(
            @NonNull Context context,
            @NonNull AppWidgetManager appWidgetManager,
            int appWidgetId,
            @NonNull Bundle newOptions) {
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions);
        int layoutResId = pickLayout(appWidgetManager, appWidgetId);
        RemoteViews views = buildViews(context, homeWidgetPreferences(context), layoutResId);
        appWidgetManager.updateAppWidget(appWidgetId, views);
    }

    private static SharedPreferences homeWidgetPreferences(Context context) {
        return context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE);
    }

    private static int pickLayout(AppWidgetManager appWidgetManager, int appWidgetId) {
        Bundle options = appWidgetManager.getAppWidgetOptions(appWidgetId);
        int widthDp = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH, 0);
        return widthDp >= FIVE_CELL_MIN_WIDTH_DP
                ? R.layout.widget_prayer_times_5x1
                : R.layout.widget_prayer_times;
    }

    private RemoteViews buildViews(Context context, SharedPreferences data, int layoutResId) {
        RemoteViews views = new RemoteViews(context.getPackageName(), layoutResId);

        boolean isRtl = data.getBoolean("widget_is_rtl", false);
        views.setInt(R.id.widget_root, "setLayoutDirection",
                isRtl ? View.LAYOUT_DIRECTION_RTL : View.LAYOUT_DIRECTION_LTR);

        int alpha = data.getInt("widget_bg_alpha", 230);
        views.setInt(R.id.widget_bg, "setImageAlpha", clampAlpha(alpha));

        views.setTextViewText(R.id.widget_date, nullToEmpty(data.getString("widget_date_label", "")));
        views.setTextViewText(R.id.widget_countdown, nullToEmpty(data.getString("widget_countdown", "")));
        views.setTextViewText(R.id.widget_sunrise, nullToEmpty(data.getString("widget_sunrise", "")));
        views.setContentDescription(R.id.widget_sunrise,
                nullToEmpty(data.getString("widget_sunrise_cd", "")));

        int nextIndex = data.getInt("widget_next_index", -1);
        String[] keys = {"fajr", "dhuhr", "asr", "maghrib", "isha"};
        for (int i = 0; i < keys.length; i++) {
            String name = nullToEmpty(data.getString("widget_name_" + keys[i], ""));
            String time = nullToEmpty(data.getString("widget_time_" + keys[i], ""));
            views.setTextViewText(NAME_IDS[i], name);
            views.setTextViewText(TIME_IDS[i], time);
            views.setInt(CELL_IDS[i], "setBackgroundResource",
                    i == nextIndex ? R.drawable.widget_cell_highlight : R.drawable.widget_cell_normal);
        }

        views.setOnClickPendingIntent(R.id.widget_root, buildLaunchAppIntent(context));
        return views;
    }

    private static PendingIntent buildLaunchAppIntent(Context context) {
        Intent launchIntent = context.getPackageManager()
                .getLaunchIntentForPackage(context.getPackageName());
        if (launchIntent == null) {
            launchIntent = new Intent(context, MainActivity.class);
        }
        launchIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
        int flags = PendingIntent.FLAG_UPDATE_CURRENT;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            flags |= PendingIntent.FLAG_IMMUTABLE;
        }
        return PendingIntent.getActivity(context, 0, launchIntent, flags);
    }

    private static int clampAlpha(int value) {
        if (value < 0) return 0;
        if (value > 255) return 255;
        return value;
    }

    private static String nullToEmpty(String value) {
        return value == null ? "" : value;
    }
}
