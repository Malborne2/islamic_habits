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
  String get unsavedChangesTitle => 'Unsaved changes';

  @override
  String get unsavedChangesMessage =>
      'Your prayer settings have unsaved changes. Do you want to save them before leaving?';

  @override
  String get discardChanges => 'Discard';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get archive => 'Archive';

  @override
  String get unarchive => 'Restore';

  @override
  String get archivedHabits => 'Archived habits';

  @override
  String get noArchivedHabits => 'No archived habits';

  @override
  String get archivedHabitsHint =>
      'Archived habits keep their history but are hidden from Home and statistics.';

  @override
  String get habitIcon => 'Icon';

  @override
  String get chooseIcon => 'Choose icon';

  @override
  String get removeIcon => 'Remove icon';

  @override
  String get deleteHabitTitle => 'Delete habit?';

  @override
  String deleteHabitMessage(String name) {
    return '\"$name\" and all of its history will be permanently deleted. This cannot be undone.';
  }

  @override
  String get habitDeleted => 'Habit deleted';

  @override
  String get habitArchived => 'Habit archived';

  @override
  String get habitRestored => 'Habit restored';

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
  String get exactAlarmButton => 'Allow exact alarm times (recommended)';

  @override
  String get exactAlarmGranted =>
      'Exact alarms are allowed — reminders will fire on time.';

  @override
  String get exactAlarmNotGranted =>
      'Exact alarms are still not allowed — try the system settings screen that just opened.';

  @override
  String get adhanTakbeerOnlyLabel => 'Takbeer only';

  @override
  String get adhanTakbeerOnlyHint =>
      'Stop after the opening takbeer instead of playing the full recording';

  @override
  String get adhanVoiceLabel => 'Adhan voice';

  @override
  String get adhanVoiceHint =>
      'Used for prayers set to the speaker (adhan) icon on the Prayer times screen.';

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

  @override
  String get customColor => 'Custom color';

  @override
  String get selectColor => 'Select';

  @override
  String get navStatistics => 'Statistics';

  @override
  String get reminderLabel => 'Reminder';

  @override
  String get reminderEnabledLabel => 'Habit reminder';

  @override
  String get reminderEnabledSubtitle =>
      'Get a notification on this habit\'s scheduled days at the time you choose';

  @override
  String get reminderTimeLabel => 'Reminder time';

  @override
  String get reminderIndependentHint =>
      'This reminder is separate from prayer reminders and works even when prayer reminders are off.';

  @override
  String reminderDailyAt(String time) {
    return 'At $time';
  }

  @override
  String get reminderOff => 'Off';

  @override
  String get notificationHabitReminderTitle => 'Habit reminder';

  @override
  String notificationHabitReminderBody(String habitName) {
    return 'Time for $habitName';
  }

  @override
  String get enterName => 'Enter a name';

  @override
  String get enterNumberGreaterThanZero => 'Enter a number greater than 0';

  @override
  String get enterNumberOneToSeven => 'Enter a number from 1 to 7';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Islamic Habits';

  @override
  String get onboardingWelcomeBody =>
      'Build a consistent routine around prayer, Quran, and the habits that matter to you.';

  @override
  String get onboardingHabitsTitle => 'One tap a day';

  @override
  String get onboardingHabitsBody =>
      'Track Yes/No and number habits, choose your own colors, and see your progress at a glance.';

  @override
  String get onboardingPrayerTitle => 'Prayer times, wherever you are';

  @override
  String get onboardingPrayerBody =>
      'Choose from thousands of cities or pick your exact location for accurate prayer times.';

  @override
  String get onboardingRemindersTitle => 'Reminders that fit your day';

  @override
  String get onboardingRemindersBody =>
      'Set a daily reminder for any habit and answer Yes or No right from the notification.';

  @override
  String get onboardingStatsTitle => 'See your progress';

  @override
  String get onboardingStatsBody =>
      'Charts, streaks, and success rates help you stay motivated and spot what needs attention.';

  @override
  String get statisticsOverallSuccess => 'Overall success';

  @override
  String get statisticsOverallSuccessSubtitle =>
      'Across all tracked habit days';

  @override
  String get statisticsBestStreak => 'Best streak';

  @override
  String get statisticsTotalHabits => 'Habits';

  @override
  String get statisticsDailyCompletion => 'Daily completion';

  @override
  String get statisticsDailyCompletionSubtitle =>
      'Your habit completion for the last 30 days';

  @override
  String get statisticsWeeklyProgress => 'Weekly progress';

  @override
  String get statisticsWeeklyProgressSubtitle =>
      'Average completion over the last four weeks';

  @override
  String get statisticsMonthlyProgress => 'Monthly progress';

  @override
  String get statisticsMonthlyProgressSubtitle =>
      'Average completion over the last six months';

  @override
  String get statisticsBreakdown => 'Habit breakdown';

  @override
  String get statisticsBreakdownSubtitle =>
      'Completed, missed, and unlogged habit days in the last 30 days';

  @override
  String get statisticsSuccess => 'Completed';

  @override
  String get statisticsMissed => 'Missed';

  @override
  String get statisticsNoData => 'No data';

  @override
  String get statisticsHabitPerformance => 'Habit performance';

  @override
  String get statisticsNoDataTitle => 'No data yet';

  @override
  String get statisticsNoDataBody =>
      'Start logging your habits to see charts, streaks, and success rates here.';
}
