package com.islamic.habits;

import android.app.Activity;
import android.appwidget.AppWidgetManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.SeekBar;
import android.widget.TextView;

/**
 * Opens when the "Prayer times" widget is first dragged onto the home
 * screen, or re-opened via the launcher's "Edit widget"/long-press entry
 * point. Lets the background transparency be set right there, as an
 * alternative to the same control in the app's own Settings screen.
 *
 * Both write the same key ("widget_bg_alpha") into home_widget's own
 * SharedPreferences file — see WidgetSettings in lib/utility — so neither
 * one can leave the other showing a stale value.
 */
public class PrayerWidgetConfigureActivity extends Activity {

    private static final String PREFS_NAME = "HomeWidgetPreferences";
    private static final String KEY_ALPHA = "widget_bg_alpha";
    private static final int DEFAULT_ALPHA = 230;

    private int appWidgetId = AppWidgetManager.INVALID_APPWIDGET_ID;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Per Android's widget-configure contract: if the user backs out
        // without pressing Done, the widget placement itself is cancelled.
        setResult(Activity.RESULT_CANCELED);

        Intent intent = getIntent();
        if (intent != null) {
            appWidgetId = intent.getIntExtra(
                    AppWidgetManager.EXTRA_APPWIDGET_ID, AppWidgetManager.INVALID_APPWIDGET_ID);
        }

        setContentView(R.layout.activity_widget_configure);

        SharedPreferences prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        int initialAlpha = prefs.getInt(KEY_ALPHA, DEFAULT_ALPHA);

        ImageView previewBg = findViewById(R.id.configure_preview_bg);
        TextView percentLabel = findViewById(R.id.configure_percent_label);
        SeekBar seekBar = findViewById(R.id.configure_seek_bar);
        Button doneButton = findViewById(R.id.configure_done_button);

        seekBar.setProgress(initialAlpha);
        applyPreview(previewBg, percentLabel, initialAlpha);

        seekBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                applyPreview(previewBg, percentLabel, progress);
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {
            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
            }
        });

        doneButton.setOnClickListener(v -> {
            prefs.edit().putInt(KEY_ALPHA, seekBar.getProgress()).apply();
            updateAllWidgetInstances();

            Intent result = new Intent();
            result.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId);
            setResult(Activity.RESULT_OK, result);
            finish();
        });
    }

    private void applyPreview(ImageView previewBg, TextView percentLabel, int alpha) {
        previewBg.setImageAlpha(alpha);
        int percent = Math.round(alpha / 255f * 100f);
        percentLabel.setText(percent + "%");
    }

    // The transparency setting is global (it's also the one shown in the
    // app's Settings screen), so saving it here refreshes every placed
    // instance of the widget, not just the one being configured.
    private void updateAllWidgetInstances() {
        AppWidgetManager manager = AppWidgetManager.getInstance(this);
        ComponentName provider = new ComponentName(this, PrayerWidgetProvider.class);
        int[] ids = manager.getAppWidgetIds(provider);
        if (ids.length == 0) return;
        Intent updateIntent = new Intent(this, PrayerWidgetProvider.class);
        updateIntent.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
        updateIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids);
        sendBroadcast(updateIntent);
    }
}
