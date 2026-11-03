import 'package:home_widget/home_widget.dart';

/// Opacity of the home screen prayer-times widget's background, so it can be
/// tuned to blend with the device's wallpaper. Mirrors the pattern used by
/// [PrayerSettings]: a static in-memory value loaded once at startup.
///
/// This is stored in home_widget's own native SharedPreferences (via
/// [HomeWidget.getWidgetData]/[HomeWidget.saveWidgetData]) rather than the
/// app's regular `shared_preferences` store. That's deliberate: Android's
/// native widget-configure screen (PrayerWidgetConfigureActivity, opened
/// when the widget is first placed or edited from the home screen) writes
/// the same key directly to that same native storage, so it and this
/// in-app Settings control always agree on one value instead of each
/// keeping a separate copy that can drift out of sync.
class WidgetSettings {
  /// 0 (fully transparent) .. 255 (fully opaque).
  static int backgroundAlpha = 230;

  static const _kBackgroundAlpha = 'widget_bg_alpha';

  static Future<void> load() async {
    backgroundAlpha = await HomeWidget.getWidgetData<int>(_kBackgroundAlpha,
            defaultValue: backgroundAlpha) ??
        backgroundAlpha;
  }

  static Future<void> setBackgroundAlpha(int value) async {
    backgroundAlpha = value.clamp(0, 255);
    await HomeWidget.saveWidgetData<int>(_kBackgroundAlpha, backgroundAlpha);
  }
}
