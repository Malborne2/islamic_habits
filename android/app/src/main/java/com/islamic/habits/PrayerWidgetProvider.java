package com.islamic.habits;

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

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

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
 * re-arms a rolling window of the next 60 minute boundaries, so the chain
 * keeps going on its own as long as a widget instance exists — and a delayed
 * tick still has a backlog to advance through.
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
    private static final String[] PRAYER_KEYS = {
            "fajr", "dhuhr", "asr", "maghrib", "isha",
    };

    private static final class NextPrayer {
        final int index;
        final long epoch;

        NextPrayer(int index, long epoch) {
            this.index = index;
            this.epoch = epoch;
        }
    }

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

        // Keep the countdown/highlight fresh without the app running. The
        // data pushed by Dart includes epoch timestamps and a week of prayer
        // times, so each tick recomputes the remaining time natively instead
        // of redrawing a stale string.
        scheduleMinuteUpdates(context);
    }

    // Arms the next 60 minute boundaries. HomeWidgetScheduler stores the
    // list and only arms one alarm at a time, so a delayed/missed tick still
    // has a backlog to advance through; every onUpdate refreshes the window.
    private static void scheduleMinuteUpdates(Context context) {
        long now = System.currentTimeMillis();
        long first = now - (now % 60_000L) + 60_000L;
        List<Long> times = new ArrayList<>(60);
        for (int i = 0; i < 60; i++) {
            times.add(first + i * 60_000L);
        }
        HomeWidgetScheduler.INSTANCE.schedule(
                context,
                PrayerWidgetProvider.class.getName(),
                times);
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

        long now = System.currentTimeMillis();
        int dayCount = data.getInt("widget_day_count", 0);
        int todayOffset = findTodayOffset(data, dayCount, now);

        String dateLabel;
        String sunrise;
        String sunriseCd;
        NextPrayer next;

        if (dayCount > 0) {
            dateLabel = data.getString("widget_day_" + todayOffset + "_label", "");
            sunrise = data.getString("widget_day_" + todayOffset + "_sunrise", "");
            sunriseCd = data.getString("widget_day_" + todayOffset + "_sunrise_cd", "");
            next = findNextPrayer(data, todayOffset, dayCount, now);
        } else {
            // Data written by an older app version (single-day keys only).
            dateLabel = data.getString("widget_date_label", "");
            sunrise = data.getString("widget_sunrise", "");
            sunriseCd = data.getString("widget_sunrise_cd", "");
            next = new NextPrayer(
                    data.getInt("widget_next_index", -1),
                    data.getLong("widget_next_epoch", 0L));
        }

        views.setTextViewText(R.id.widget_date, nullToEmpty(dateLabel));
        views.setTextViewText(R.id.widget_sunrise, nullToEmpty(sunrise));
        views.setContentDescription(R.id.widget_sunrise, nullToEmpty(sunriseCd));

        for (int i = 0; i < PRAYER_KEYS.length; i++) {
            String name = nullToEmpty(data.getString("widget_name_" + PRAYER_KEYS[i], ""));
            String time = dayCount > 0
                    ? data.getString("widget_day_" + todayOffset + "_"
                            + PRAYER_KEYS[i] + "_time", "")
                    : data.getString("widget_time_" + PRAYER_KEYS[i], "");
            views.setTextViewText(NAME_IDS[i], name);
            views.setTextViewText(TIME_IDS[i], nullToEmpty(time));
            views.setInt(CELL_IDS[i], "setBackgroundResource",
                    i == next.index ? R.drawable.widget_cell_highlight : R.drawable.widget_cell_normal);
        }

        views.setTextViewText(R.id.widget_countdown,
                buildCountdown(data, next.epoch, now));
        views.setOnClickPendingIntent(R.id.widget_root, buildLaunchAppIntent(context));
        return views;
    }

    private static int findTodayOffset(SharedPreferences data, int dayCount, long now) {
        if (dayCount <= 0) return 0;
        String today = new SimpleDateFormat("yyyy-MM-dd", Locale.US).format(new Date(now));
        for (int i = 0; i < dayCount; i++) {
            if (today.equals(data.getString("widget_day_" + i + "_date", ""))) {
                return i;
            }
        }
        return 0;
    }

    // Scans the stored days in order and returns the first prayer whose epoch
    // is still in the future. Sunrise is intentionally not in this list: when
    // it's next, the widget highlights the prayer after it, matching the app's
    // own countdown badge.
    private static NextPrayer findNextPrayer(
            SharedPreferences data, int todayOffset, int dayCount, long now) {
        for (int day = todayOffset; day < dayCount; day++) {
            for (int i = 0; i < PRAYER_KEYS.length; i++) {
                long epoch = data.getLong(
                        "widget_day_" + day + "_" + PRAYER_KEYS[i] + "_epoch", 0L);
                if (epoch > now) return new NextPrayer(i, epoch);
            }
        }
        return new NextPrayer(-1, 0L);
    }

    private static String buildCountdown(SharedPreferences data, long nextEpoch, long now) {
        if (nextEpoch <= 0L) {
            return nullToEmpty(data.getString("widget_countdown", ""));
        }
        long remaining = Math.max(0L, nextEpoch - now);
        long totalMinutes = remaining / 60_000L;
        long hours = totalMinutes / 60L;
        long minutes = totalMinutes % 60L;
        String template = hours > 0
                ? data.getString("widget_countdown_hm_template", "in {hours}h {minutes}m")
                : data.getString("widget_countdown_m_template", "in {minutes}m");
        String countdown = nullToEmpty(template)
                .replace("{hours}", String.valueOf(hours))
                .replace("{minutes}", String.valueOf(minutes));
        if (data.getBoolean("widget_eastern_digits", false)) {
            countdown = toEasternArabicDigits(countdown);
        }
        return countdown;
    }

    // Matches NumeralSettings in Dart: Arabic locales default to Western
    // digits, with Eastern Arabic-Indic digits only when the user opted in.
    private static String toEasternArabicDigits(String text) {
        StringBuilder builder = new StringBuilder(text.length());
        for (int i = 0; i < text.length(); i++) {
            char c = text.charAt(i);
            if (c >= '0' && c <= '9') {
                builder.append((char) ('\u0660' + (c - '0')));
            } else {
                builder.append(c);
            }
        }
        return builder.toString();
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
