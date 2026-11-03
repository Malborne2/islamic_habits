import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:home_widget/home_widget.dart';
// intl exports its own TextDirection class (LTR/RTL/UNKNOWN, no .rtl
// getter), which otherwise wins over Flutter's dart:ui TextDirection
// (re-exported by material.dart) for the bare `TextDirection.rtl` below.
import 'package:intl/intl.dart' hide TextDirection;
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/utility/numeral_settings.dart';
import 'package:islamic_habits/utility/prayer_helper.dart';
import 'package:islamic_habits/utility/widget_settings.dart';

/// Pushes the home screen "Prayer times" widget's content.
///
/// Every value here is computed the exact same way the Prayer Times screen
/// (lib/screens/prayers_screen.dart) and the Home countdown badge
/// (lib/screens/main_screen.dart) compute theirs — same [PrayerHelper],
/// same `AppLocalizations` strings, same [localizeDigits] — so the widget
/// can never drift from what the app itself shows. The native Android side
/// (PrayerWidgetProvider) only displays these already-formatted strings; it
/// does no prayer-time math and no localization of its own.
class WidgetService {
  static const String _androidProviderName = 'PrayerWidgetProvider';

  static const List<String> _prayerKeys = [
    'fajr',
    'dhuhr',
    'asr',
    'maghrib',
    'isha',
  ];

  /// Recomputes today's prayer times/next-prayer countdown and pushes them
  /// to the widget. Call this whenever something the widget shows could
  /// have changed: app startup, prayer location/method/adjustment changes,
  /// language changes, and the widget-transparency setting changing.
  static Future<void> update(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final now = DateTime.now();
    final prayerHelper = PrayerHelper.fromSettings(dateTime: now);

    String nextName = prayerHelper.getNextPrayerName();
    DateTime nextTime = prayerHelper.getNextPrayerTime();
    // "Sunrise" isn't a prayer; when it's up next, the widget should
    // highlight the prayer that follows it instead (same reasoning
    // getLaterPrayerName()/getLaterPrayerTime() already encode).
    if (nextName == 'Sunrise') {
      nextName = prayerHelper.getLaterPrayerName();
      nextTime = prayerHelper.getLaterPrayerTime();
    }
    final nextIndex = _prayerKeys.indexOf(nextName.toLowerCase());

    final remaining = nextTime.difference(now);
    final clamped = remaining.isNegative ? Duration.zero : remaining;
    final hours = clamped.inHours;
    final minutes = clamped.inMinutes % 60;
    // Same hours+minutes vs. minutes-only split as the in-app countdown
    // badge (lib/screens/main_screen.dart's _CountdownBadge).
    final countdownText = localizeDigits(
        context,
        hours > 0
            ? l10n.nextPrayerCountdownHm(hours, minutes)
            : l10n.nextPrayerCountdownM(minutes));

    HijriCalendar.setLocal(locale == 'ar' ? 'ar' : 'en');
    final hijri = HijriCalendar.fromDate(now);
    final dateLabel = localizeDigits(
        context,
        '${hijri.toFormat("d MMMM")} • '
        '${DateFormat('MMM d', locale).format(now)}');

    final times = <String, DateTime>{
      'fajr': prayerHelper.getFajr(),
      'dhuhr': prayerHelper.getDhuhr(),
      'asr': prayerHelper.getAsr(),
      'maghrib': prayerHelper.getMaghrib(),
      'isha': prayerHelper.getIsha(),
    };
    final names = <String, String>{
      'fajr': l10n.prayerFajr,
      'dhuhr': l10n.prayerDhuhr,
      'asr': l10n.prayerAsr,
      'maghrib': l10n.prayerMaghrib,
      'isha': l10n.prayerIsha,
    };

    // "↑" reads as sunrise in any language without needing its own
    // translation; the full localized word still goes out as an
    // accessibility content description (see PrayerWidgetProvider).
    final sunriseTimeText =
        localizeDigits(context, DateFormat.jm(locale).format(prayerHelper.getSunrise()));
    final sunriseText = '↑ $sunriseTimeText';
    final sunriseContentDescription = '${l10n.prayerSunrise} $sunriseTimeText';

    await HomeWidget.saveWidgetData<bool>('widget_is_rtl', isRtl);
    await HomeWidget.saveWidgetData<int>(
        'widget_bg_alpha', WidgetSettings.backgroundAlpha);
    await HomeWidget.saveWidgetData<String>('widget_date_label', dateLabel);
    await HomeWidget.saveWidgetData<String>('widget_countdown', countdownText);
    await HomeWidget.saveWidgetData<int>('widget_next_index', nextIndex);
    await HomeWidget.saveWidgetData<String>('widget_sunrise', sunriseText);
    await HomeWidget.saveWidgetData<String>(
        'widget_sunrise_cd', sunriseContentDescription);
    for (final key in _prayerKeys) {
      await HomeWidget.saveWidgetData<String>('widget_name_$key', names[key]);
      await HomeWidget.saveWidgetData<String>(
          'widget_time_$key',
          localizeDigits(
              context, DateFormat.jm(locale).format(times[key]!)));
    }

    await HomeWidget.updateWidget(
      name: _androidProviderName,
      androidName: _androidProviderName,
    );
  }
}
