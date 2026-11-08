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

  // How many days of prayer times are pushed to the widget. The native
  // provider can then keep recomputing the countdown/highlight and roll over
  // to the next day without the app running; a week is a comfortable buffer
  // for phones whose OEM battery manager delays the periodic widget update.
  static const int _kWidgetDayCount = 7;

  // Sentinels used to recover the localized countdown sentence as a template
  // (e.g. "in {hours}h {minutes}m") so the native widget can fill in new
  // numbers every minute without duplicating translations in Java.
  static const int _kHoursToken = 987654;
  static const int _kMinutesToken = 987655;

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
    final sunriseTimeText = localizeDigits(
        context, DateFormat.jm(locale).format(prayerHelper.getSunrise()));
    final sunriseText = '↑ $sunriseTimeText';
    final sunriseContentDescription = '${l10n.prayerSunrise} $sunriseTimeText';

    // The native provider recomputes the countdown every minute from epoch
    // timestamps, so it needs the localized sentence structure as a template
    // rather than one already-formatted string. Sentinels recover the
    // template without duplicating every translation in Java.
    final countdownHmTemplate = l10n
        .nextPrayerCountdownHm(_kHoursToken, _kMinutesToken)
        .replaceAll('$_kHoursToken', '{hours}')
        .replaceAll('$_kMinutesToken', '{minutes}');
    final countdownMTemplate = l10n
        .nextPrayerCountdownM(_kMinutesToken)
        .replaceAll('$_kMinutesToken', '{minutes}');
    final easternDigits =
        locale.startsWith('ar') && NumeralSettings.useEasternArabicNumerals;

    await HomeWidget.saveWidgetData<bool>('widget_is_rtl', isRtl);
    await HomeWidget.saveWidgetData<int>(
        'widget_bg_alpha', WidgetSettings.backgroundAlpha);
    await HomeWidget.saveWidgetData<bool>(
        'widget_eastern_digits', easternDigits);
    await HomeWidget.saveWidgetData<String>(
        'widget_countdown_hm_template', countdownHmTemplate);
    await HomeWidget.saveWidgetData<String>(
        'widget_countdown_m_template', countdownMTemplate);

    // Legacy/current-day keys: still useful as a fallback for an older
    // RemoteViews layout or if the native provider can't match today's date.
    await HomeWidget.saveWidgetData<String>('widget_date_label', dateLabel);
    await HomeWidget.saveWidgetData<String>('widget_countdown', countdownText);
    await HomeWidget.saveWidgetData<int>('widget_next_index', nextIndex);
    await HomeWidget.saveWidgetData<int>(
        'widget_next_epoch', nextTime.millisecondsSinceEpoch);
    await HomeWidget.saveWidgetData<String>('widget_sunrise', sunriseText);
    await HomeWidget.saveWidgetData<String>(
        'widget_sunrise_cd', sunriseContentDescription);
    for (final key in _prayerKeys) {
      await HomeWidget.saveWidgetData<String>('widget_name_$key', names[key]);
      await HomeWidget.saveWidgetData<String>('widget_time_$key',
          localizeDigits(context, DateFormat.jm(locale).format(times[key]!)));
    }

    // A week of already-computed days lets the widget roll over at midnight
    // and keep highlighting/counting down correctly without the app running.
    await HomeWidget.saveWidgetData<int>('widget_day_count', _kWidgetDayCount);
    for (var offset = 0; offset < _kWidgetDayCount; offset++) {
      final day = DateTime(now.year, now.month, now.day + offset, 12);
      final helper =
          offset == 0 ? prayerHelper : PrayerHelper.fromSettings(dateTime: day);
      HijriCalendar.setLocal(locale == 'ar' ? 'ar' : 'en');
      final hijriDay = HijriCalendar.fromDate(day);
      final dayLabel = localizeDigits(
          context,
          '${hijriDay.toFormat("d MMMM")} • '
          '${DateFormat('MMM d', locale).format(day)}');
      final daySunriseText = localizeDigits(
          context, DateFormat.jm(locale).format(helper.getSunrise()));
      final dayTimes = <String, DateTime>{
        'fajr': helper.getFajr(),
        'dhuhr': helper.getDhuhr(),
        'asr': helper.getAsr(),
        'maghrib': helper.getMaghrib(),
        'isha': helper.getIsha(),
      };

      await HomeWidget.saveWidgetData<String>(
          'widget_day_${offset}_date', _dayKey(day));
      await HomeWidget.saveWidgetData<String>(
          'widget_day_${offset}_label', dayLabel);
      await HomeWidget.saveWidgetData<String>(
          'widget_day_${offset}_sunrise', '↑ $daySunriseText');
      await HomeWidget.saveWidgetData<String>('widget_day_${offset}_sunrise_cd',
          '${l10n.prayerSunrise} $daySunriseText');
      for (final key in _prayerKeys) {
        final time = dayTimes[key]!;
        await HomeWidget.saveWidgetData<String>(
            'widget_day_${offset}_${key}_time',
            localizeDigits(context, DateFormat.jm(locale).format(time)));
        await HomeWidget.saveWidgetData<int>(
            'widget_day_${offset}_${key}_epoch', time.millisecondsSinceEpoch);
      }
    }

    await HomeWidget.updateWidget(
      name: _androidProviderName,
      androidName: _androidProviderName,
    );
  }

  // Stable, locale-independent yyyy-MM-dd key the native provider uses to
  // pick today's row out of the multi-day data.
  static String _dayKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
