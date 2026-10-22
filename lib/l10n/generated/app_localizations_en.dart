// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Islamic Habits';

  @override
  String get navHome => 'Home';

  @override
  String get navPrayerTimes => 'Prayer times';

  @override
  String get navAllHabits => 'All habits';

  @override
  String get navFivePrayers => 'The five prayers';

  @override
  String get navAddHabit => 'Add new habit';

  @override
  String get editHabitTitle => 'Edit habit';

  @override
  String get editHabitAction => 'Edit habit';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsDarkMode => 'Dark mode';

  @override
  String get settingsStartOfWeek => 'Start of week';

  @override
  String get settingsPrayerTimeSettings => 'Prayer time settings';

  @override
  String get settingsPrayerTimeSettingsSubtitle =>
      'Location, calculation method, and prayer reminders';

  @override
  String get settingsBackupRestore => 'Backup & Restore';

  @override
  String get settingsBackupRestoreSubtitle =>
      'Export or restore your habit data';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'Phone language';

  @override
  String get todayHabits => 'Today\'s habits';

  @override
  String todayProgress(int completed, int total) {
    return 'Today: $completed / $total habits done';
  }

  @override
  String longestStreak(String daysText, String habitName) {
    return 'Longest streak: $daysText · $habitName';
  }

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get setValue => 'Set';

  @override
  String get exportBackup => 'Export backup';

  @override
  String get restoreFromBackup => 'Restore from backup';

  @override
  String get habitName => 'Habit name';

  @override
  String get successMetric => 'Success metric';

  @override
  String get yesNo => 'Yes / No';

  @override
  String get number => 'Number';

  @override
  String get streakTarget => 'Streak target';

  @override
  String get targetStreakDays => 'Target streak (days)';

  @override
  String get schedule => 'Schedule';

  @override
  String get everyDay => 'Every day';

  @override
  String get certainDaysOfWeek => 'Certain days of the week';

  @override
  String get timesPerWeek => 'A number of times per week';

  @override
  String get color => 'Color';

  @override
  String get saveHabit => 'Save habit';

  @override
  String get habitFajrPrayer => 'Al Fajir Prayer';

  @override
  String get habitDhuhrPrayer => 'Al Dhuhr Prayer';

  @override
  String get habitAsrPrayer => 'Al Asr Prayer';

  @override
  String get habitMaghribPrayer => 'Al Magrib Prayer';

  @override
  String get habitIshaPrayer => 'Al Isha Prayer';

  @override
  String get habitRecitingQuran => 'Reciting the Quran';

  @override
  String get todayLabel => 'Today';

  @override
  String get prayerFajr => 'Al Fajir';

  @override
  String get prayerDhuhr => 'Al Dhuhr';

  @override
  String get prayerAsr => 'Al Asr';

  @override
  String get prayerMaghrib => 'Al Magrib';

  @override
  String get prayerIsha => 'Al Isha';

  @override
  String get notifyMode => 'Notify';

  @override
  String get silentMode => 'Silent';

  @override
  String get adhanMode => 'Adhan';

  @override
  String get weekdayMonday => 'Monday';

  @override
  String get weekdayTuesday => 'Tuesday';

  @override
  String get weekdayWednesday => 'Wednesday';

  @override
  String get weekdayThursday => 'Thursday';

  @override
  String get weekdayFriday => 'Friday';

  @override
  String get weekdaySaturday => 'Saturday';

  @override
  String get weekdaySunday => 'Sunday';

  @override
  String get settingsNumerals => 'Numerals';

  @override
  String get numeralsWestern => 'Western (0, 1, 2…)';

  @override
  String get numeralsEastern => 'Eastern Arabic-Indic (٠, ١, ٢…)';

  @override
  String get unitPages => 'pages';

  @override
  String get deleteEntryTitle => 'Delete entry';

  @override
  String get deleteEntryConfirm =>
      'Are you sure you want to permanently delete this entry?';

  @override
  String get targetAmountLabel => 'Target amount';

  @override
  String get unitLabel => 'Unit';

  @override
  String get timesPerWeekLabel => 'Times per week';

  @override
  String get restoreBackupTitle => 'Restore backup';

  @override
  String get restoreBackupConfirm =>
      'This will replace all habits currently stored on this device with the ones from the selected backup. Continue?';

  @override
  String get restoreAction => 'Restore';

  @override
  String get notificationPermissionDenied =>
      'Notification permission was not granted';

  @override
  String get prayerRemindersLabel => 'Prayer reminders';

  @override
  String get prayerRemindersSubtitle =>
      '30 minutes after each prayer, ask whether you prayed';

  @override
  String get sendTestReminder => 'Send a test reminder now';

  @override
  String get batteryOptimizationHint =>
      'If reminders still don\'t arrive at the right time, your phone\'s battery optimization may be delaying or blocking them in the background.';

  @override
  String get batteryOptimizationButton =>
      'Exempt this app from battery optimization';

  @override
  String get adhanVoiceLabel => 'Adhan voice';

  @override
  String get adhanVoiceHint =>
      'Used for prayers set to the microphone (adhan) bell icon on the Prayer times screen.';

  @override
  String get takbeerOnly => 'Takbeer only';

  @override
  String get fullAdhan => 'Full Adhan';

  @override
  String get testAdhanVoice => 'Test this voice';

  @override
  String get adhanAudioMissing =>
      'No audio file bundled for this voice yet — add it under android/app/src/main/res/raw to hear it.';

  @override
  String get locationLabel => 'Location';

  @override
  String get cityLabel => 'City';

  @override
  String get latitudeLabel => 'Latitude';

  @override
  String get longitudeLabel => 'Longitude';

  @override
  String get citySearchHint => 'Search for a city';

  @override
  String get cityNotFoundPrompt => 'Can\'t find your city?';

  @override
  String get pickOnMap => 'Pick on map';

  @override
  String get noCitiesFound => 'No cities found';

  @override
  String get mapPickerTitle => 'Pick a location';

  @override
  String get mapPickerInstructions =>
      'Tap anywhere on the map to set your prayer-time location';

  @override
  String get useThisLocation => 'Use this location';

  @override
  String get customLocationLabel => 'Custom location';

  @override
  String get calculationMethodLabel => 'Calculation method';

  @override
  String get madhabLabel => 'Madhab (Asr calculation)';

  @override
  String get shafiLabel => 'Shafi';

  @override
  String get hanafiLabel => 'Hanafi';

  @override
  String get manualCorrectionLabel => 'Manual correction (minutes)';

  @override
  String get adjFajr => 'Fajr';

  @override
  String get adjDhuhr => 'Dhuhr';

  @override
  String get adjAsr => 'Asr';

  @override
  String get adjMaghrib => 'Maghrib';

  @override
  String get adjIsha => 'Isha';

  @override
  String get cityDoha => 'Doha';

  @override
  String get cityMecca => 'Mecca';

  @override
  String get cityMedina => 'Medina';

  @override
  String get cityCairo => 'Cairo';

  @override
  String get cityIstanbul => 'Istanbul';

  @override
  String get cityJakarta => 'Jakarta';

  @override
  String get cityKarachi => 'Karachi';

  @override
  String get cityLondon => 'London';

  @override
  String get cityNewYork => 'New York';

  @override
  String get cityCustom => 'Custom';

  @override
  String get notificationPrayerTimeTitle => 'Prayer time';

  @override
  String notificationPrayerTimeBody(String prayerName) {
    return 'It is time for $prayerName';
  }

  @override
  String get notificationReminderTitle => 'Prayer reminder';

  @override
  String notificationReminderBody(String prayerName) {
    return 'Did you pray $prayerName?';
  }

  @override
  String get notificationYes => 'Yes';

  @override
  String get notificationNo => 'No';

  @override
  String get weekdayMonShort => 'Mon';

  @override
  String get weekdayTueShort => 'Tue';

  @override
  String get weekdayWedShort => 'Wed';

  @override
  String get weekdayThuShort => 'Thu';

  @override
  String get weekdayFriShort => 'Fri';

  @override
  String get weekdaySatShort => 'Sat';

  @override
  String get weekdaySunShort => 'Sun';

  @override
  String get pickAtLeastOneDay => 'Pick at least one day of the week';

  @override
  String get setValueTitle => 'Set value';

  @override
  String setUnitTitle(String unit) {
    return 'Set $unit';
  }

  @override
  String get metricCurrentStreak => 'Current Streak';

  @override
  String get metricStreakTarget => 'Streak Target';

  @override
  String get metricMaximumStreak => 'Maximum Streak';

  @override
  String get metricSuccessPercentage => 'Success Percentage';

  @override
  String get metricWeeklyAverage => 'Weekly Average';

  @override
  String get metricMonthlyAverage => 'Monthly Average';

  @override
  String get backupDescription =>
      'All habit data is stored locally on this device. Export a backup file to keep a copy or move it to another device, for example by sharing it to a cloud drive or email.';

  @override
  String exportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String importFailed(String error) {
    return 'Import failed: $error';
  }

  @override
  String restoredCount(int count) {
    return 'Restored $count habit(s)';
  }

  @override
  String get shareBackupText => 'Islamic Habits backup';

  @override
  String get valueAddedSuccess => 'New value added successfully';

  @override
  String get prayerSunrise => 'Sunrise';

  @override
  String get methodMuslimWorldLeague => 'Muslim World League';

  @override
  String get methodEgyptian => 'Egyptian';

  @override
  String get methodKarachi => 'Karachi';

  @override
  String get methodUmmAlQura => 'Umm al-Qura';

  @override
  String get methodDubai => 'Dubai';

  @override
  String get methodMoonSightingCommittee => 'Moon Sighting Committee';

  @override
  String get methodNorthAmerica => 'North America';

  @override
  String get methodKuwait => 'Kuwait';

  @override
  String get methodQatar => 'Qatar';

  @override
  String get methodSingapore => 'Singapore';

  @override
  String get methodTurkey => 'Turkey';

  @override
  String get methodTehran => 'Tehran';

  @override
  String get methodOther => 'Other';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String nextPrayerCountdownHm(int hours, int minutes) {
    return 'in ${hours}h ${minutes}m';
  }

  @override
  String nextPrayerCountdownM(int minutes) {
    return 'in ${minutes}m';
  }
}
