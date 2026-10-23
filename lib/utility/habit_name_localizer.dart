import 'package:flutter/widgets.dart';
import 'package:islamic_habits/l10n/generated/app_localizations.dart';

// The stored habit name is always the canonical English string (used to
// match notifications, exports, etc.); this only translates it for
// display, for the default habits created on first launch. Any other
// (user-created) habit name is shown as typed.
String localizedHabitName(BuildContext context, String name) =>
    localizedHabitNameFromL10n(AppLocalizations.of(context), name);

// The same translation, for callers (notification scheduling) that already
// hold an AppLocalizations instance but have no BuildContext.
String localizedHabitNameFromL10n(AppLocalizations l10n, String name) {
  switch (name) {
    case 'Al Fajir Prayer':
      return l10n.habitFajrPrayer;
    case 'Al Dhuhr Prayer':
      return l10n.habitDhuhrPrayer;
    case 'Al Asr Prayer':
      return l10n.habitAsrPrayer;
    case 'Al Magrib Prayer':
      return l10n.habitMaghribPrayer;
    case 'Al Isha Prayer':
      return l10n.habitIshaPrayer;
    case 'Reciting the Quran':
      return l10n.habitRecitingQuran;
    default:
      return name;
  }
}

// Same idea as localizedHabitName, for a NUMBER habit's unit: translates
// the canonical default ('pages') and leaves any custom, user-typed unit
// unchanged.
String localizedUnit(BuildContext context, String unit) {
  if (unit == 'pages') return AppLocalizations.of(context).unitPages;
  return unit;
}

// PrayerHelper.getNextPrayerName()/getLaterPrayerName() return the fixed
// English prayer/sunrise names below; this translates them for display.
String localizedPrayerDisplayName(BuildContext context, String name) {
  final l10n = AppLocalizations.of(context);
  switch (name) {
    case 'Fajr':
      return l10n.prayerFajr;
    case 'Dhuhr':
      return l10n.prayerDhuhr;
    case 'Asr':
      return l10n.prayerAsr;
    case 'Maghrib':
      return l10n.prayerMaghrib;
    case 'Isha':
      return l10n.prayerIsha;
    case 'Sunrise':
      return l10n.prayerSunrise;
    default:
      return name;
  }
}
