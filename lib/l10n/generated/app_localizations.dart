import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_nb.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('nb')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Islamic Habits'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navPrayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Prayer times'**
  String get navPrayerTimes;

  /// No description provided for @navAllHabits.
  ///
  /// In en, this message translates to:
  /// **'All habits'**
  String get navAllHabits;

  /// No description provided for @navFivePrayers.
  ///
  /// In en, this message translates to:
  /// **'The five prayers'**
  String get navFivePrayers;

  /// No description provided for @navAddHabit.
  ///
  /// In en, this message translates to:
  /// **'Add new habit'**
  String get navAddHabit;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get settingsDarkMode;

  /// No description provided for @settingsStartOfWeek.
  ///
  /// In en, this message translates to:
  /// **'Start of week'**
  String get settingsStartOfWeek;

  /// No description provided for @settingsPrayerTimeSettings.
  ///
  /// In en, this message translates to:
  /// **'Prayer time settings'**
  String get settingsPrayerTimeSettings;

  /// No description provided for @settingsPrayerTimeSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Location, calculation method, and prayer reminders'**
  String get settingsPrayerTimeSettingsSubtitle;

  /// No description provided for @settingsBackupRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get settingsBackupRestore;

  /// No description provided for @settingsBackupRestoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Export or restore your habit data'**
  String get settingsBackupRestoreSubtitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'Phone language'**
  String get settingsLanguageSystem;

  /// No description provided for @todayHabits.
  ///
  /// In en, this message translates to:
  /// **'Today\'s habits'**
  String get todayHabits;

  /// No description provided for @todayProgress.
  ///
  /// In en, this message translates to:
  /// **'Today: {completed} / {total} habits done'**
  String todayProgress(int completed, int total);

  /// No description provided for @longestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest streak: {daysText} · {habitName}'**
  String longestStreak(String daysText, String habitName);

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @setValue.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get setValue;

  /// No description provided for @exportBackup.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get exportBackup;

  /// No description provided for @restoreFromBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup'**
  String get restoreFromBackup;

  /// No description provided for @habitName.
  ///
  /// In en, this message translates to:
  /// **'Habit name'**
  String get habitName;

  /// No description provided for @successMetric.
  ///
  /// In en, this message translates to:
  /// **'Success metric'**
  String get successMetric;

  /// No description provided for @yesNo.
  ///
  /// In en, this message translates to:
  /// **'Yes / No'**
  String get yesNo;

  /// No description provided for @number.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get number;

  /// No description provided for @streakTarget.
  ///
  /// In en, this message translates to:
  /// **'Streak target'**
  String get streakTarget;

  /// No description provided for @targetStreakDays.
  ///
  /// In en, this message translates to:
  /// **'Target streak (days)'**
  String get targetStreakDays;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @everyDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get everyDay;

  /// No description provided for @certainDaysOfWeek.
  ///
  /// In en, this message translates to:
  /// **'Certain days of the week'**
  String get certainDaysOfWeek;

  /// No description provided for @timesPerWeek.
  ///
  /// In en, this message translates to:
  /// **'A number of times per week'**
  String get timesPerWeek;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @saveHabit.
  ///
  /// In en, this message translates to:
  /// **'Save habit'**
  String get saveHabit;

  /// No description provided for @habitFajrPrayer.
  ///
  /// In en, this message translates to:
  /// **'Al Fajir Prayer'**
  String get habitFajrPrayer;

  /// No description provided for @habitDhuhrPrayer.
  ///
  /// In en, this message translates to:
  /// **'Al Dhuhr Prayer'**
  String get habitDhuhrPrayer;

  /// No description provided for @habitAsrPrayer.
  ///
  /// In en, this message translates to:
  /// **'Al Asr Prayer'**
  String get habitAsrPrayer;

  /// No description provided for @habitMaghribPrayer.
  ///
  /// In en, this message translates to:
  /// **'Al Magrib Prayer'**
  String get habitMaghribPrayer;

  /// No description provided for @habitIshaPrayer.
  ///
  /// In en, this message translates to:
  /// **'Al Isha Prayer'**
  String get habitIshaPrayer;

  /// No description provided for @habitRecitingQuran.
  ///
  /// In en, this message translates to:
  /// **'Reciting the Quran'**
  String get habitRecitingQuran;

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayLabel;

  /// No description provided for @prayerFajr.
  ///
  /// In en, this message translates to:
  /// **'Al Fajir'**
  String get prayerFajr;

  /// No description provided for @prayerDhuhr.
  ///
  /// In en, this message translates to:
  /// **'Al Dhuhr'**
  String get prayerDhuhr;

  /// No description provided for @prayerAsr.
  ///
  /// In en, this message translates to:
  /// **'Al Asr'**
  String get prayerAsr;

  /// No description provided for @prayerMaghrib.
  ///
  /// In en, this message translates to:
  /// **'Al Magrib'**
  String get prayerMaghrib;

  /// No description provided for @prayerIsha.
  ///
  /// In en, this message translates to:
  /// **'Al Isha'**
  String get prayerIsha;

  /// No description provided for @notifyMode.
  ///
  /// In en, this message translates to:
  /// **'Notify'**
  String get notifyMode;

  /// No description provided for @silentMode.
  ///
  /// In en, this message translates to:
  /// **'Silent'**
  String get silentMode;

  /// No description provided for @adhanMode.
  ///
  /// In en, this message translates to:
  /// **'Adhan'**
  String get adhanMode;

  /// No description provided for @weekdayMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdayMonday;

  /// No description provided for @weekdayTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekdayTuesday;

  /// No description provided for @weekdayWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekdayWednesday;

  /// No description provided for @weekdayThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekdayThursday;

  /// No description provided for @weekdayFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekdayFriday;

  /// No description provided for @weekdaySaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekdaySaturday;

  /// No description provided for @weekdaySunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdaySunday;

  /// No description provided for @settingsNumerals.
  ///
  /// In en, this message translates to:
  /// **'Numerals'**
  String get settingsNumerals;

  /// No description provided for @numeralsWestern.
  ///
  /// In en, this message translates to:
  /// **'Western (0, 1, 2…)'**
  String get numeralsWestern;

  /// No description provided for @numeralsEastern.
  ///
  /// In en, this message translates to:
  /// **'Eastern Arabic-Indic (٠, ١, ٢…)'**
  String get numeralsEastern;

  /// No description provided for @unitPages.
  ///
  /// In en, this message translates to:
  /// **'pages'**
  String get unitPages;

  /// No description provided for @deleteEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete entry'**
  String get deleteEntryTitle;

  /// No description provided for @deleteEntryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete this entry?'**
  String get deleteEntryConfirm;

  /// No description provided for @targetAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Target amount'**
  String get targetAmountLabel;

  /// No description provided for @unitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unitLabel;

  /// No description provided for @timesPerWeekLabel.
  ///
  /// In en, this message translates to:
  /// **'Times per week'**
  String get timesPerWeekLabel;

  /// No description provided for @restoreBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore backup'**
  String get restoreBackupTitle;

  /// No description provided for @restoreBackupConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will replace all habits currently stored on this device with the ones from the selected backup. Continue?'**
  String get restoreBackupConfirm;

  /// No description provided for @restoreAction.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreAction;

  /// No description provided for @notificationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notification permission was not granted'**
  String get notificationPermissionDenied;

  /// No description provided for @prayerRemindersLabel.
  ///
  /// In en, this message translates to:
  /// **'Prayer reminders'**
  String get prayerRemindersLabel;

  /// No description provided for @prayerRemindersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'30 minutes after each prayer, ask whether you prayed'**
  String get prayerRemindersSubtitle;

  /// No description provided for @sendTestReminder.
  ///
  /// In en, this message translates to:
  /// **'Send a test reminder now'**
  String get sendTestReminder;

  /// No description provided for @adhanVoiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Adhan voice'**
  String get adhanVoiceLabel;

  /// No description provided for @adhanVoiceHint.
  ///
  /// In en, this message translates to:
  /// **'Used for prayers set to the microphone (adhan) bell icon on the Prayer times screen.'**
  String get adhanVoiceHint;

  /// No description provided for @takbeerOnly.
  ///
  /// In en, this message translates to:
  /// **'Takbeer only'**
  String get takbeerOnly;

  /// No description provided for @fullAdhan.
  ///
  /// In en, this message translates to:
  /// **'Full Adhan'**
  String get fullAdhan;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityLabel;

  /// No description provided for @latitudeLabel.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitudeLabel;

  /// No description provided for @longitudeLabel.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitudeLabel;

  /// No description provided for @calculationMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Calculation method'**
  String get calculationMethodLabel;

  /// No description provided for @madhabLabel.
  ///
  /// In en, this message translates to:
  /// **'Madhab (Asr calculation)'**
  String get madhabLabel;

  /// No description provided for @shafiLabel.
  ///
  /// In en, this message translates to:
  /// **'Shafi'**
  String get shafiLabel;

  /// No description provided for @hanafiLabel.
  ///
  /// In en, this message translates to:
  /// **'Hanafi'**
  String get hanafiLabel;

  /// No description provided for @manualCorrectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Manual correction (minutes)'**
  String get manualCorrectionLabel;

  /// No description provided for @adjFajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get adjFajr;

  /// No description provided for @adjDhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get adjDhuhr;

  /// No description provided for @adjAsr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get adjAsr;

  /// No description provided for @adjMaghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get adjMaghrib;

  /// No description provided for @adjIsha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get adjIsha;

  /// No description provided for @cityDoha.
  ///
  /// In en, this message translates to:
  /// **'Doha'**
  String get cityDoha;

  /// No description provided for @cityMecca.
  ///
  /// In en, this message translates to:
  /// **'Mecca'**
  String get cityMecca;

  /// No description provided for @cityMedina.
  ///
  /// In en, this message translates to:
  /// **'Medina'**
  String get cityMedina;

  /// No description provided for @cityCairo.
  ///
  /// In en, this message translates to:
  /// **'Cairo'**
  String get cityCairo;

  /// No description provided for @cityIstanbul.
  ///
  /// In en, this message translates to:
  /// **'Istanbul'**
  String get cityIstanbul;

  /// No description provided for @cityJakarta.
  ///
  /// In en, this message translates to:
  /// **'Jakarta'**
  String get cityJakarta;

  /// No description provided for @cityKarachi.
  ///
  /// In en, this message translates to:
  /// **'Karachi'**
  String get cityKarachi;

  /// No description provided for @cityLondon.
  ///
  /// In en, this message translates to:
  /// **'London'**
  String get cityLondon;

  /// No description provided for @cityNewYork.
  ///
  /// In en, this message translates to:
  /// **'New York'**
  String get cityNewYork;

  /// No description provided for @cityCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get cityCustom;

  /// No description provided for @notificationPrayerTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer time'**
  String get notificationPrayerTimeTitle;

  /// No description provided for @notificationPrayerTimeBody.
  ///
  /// In en, this message translates to:
  /// **'It is time for {prayerName}'**
  String notificationPrayerTimeBody(String prayerName);

  /// No description provided for @notificationReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer reminder'**
  String get notificationReminderTitle;

  /// No description provided for @notificationReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Did you pray {prayerName}?'**
  String notificationReminderBody(String prayerName);

  /// No description provided for @notificationYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get notificationYes;

  /// No description provided for @notificationNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get notificationNo;

  /// No description provided for @weekdayMonShort.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekdayMonShort;

  /// No description provided for @weekdayTueShort.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekdayTueShort;

  /// No description provided for @weekdayWedShort.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekdayWedShort;

  /// No description provided for @weekdayThuShort.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekdayThuShort;

  /// No description provided for @weekdayFriShort.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekdayFriShort;

  /// No description provided for @weekdaySatShort.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekdaySatShort;

  /// No description provided for @weekdaySunShort.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekdaySunShort;

  /// No description provided for @pickAtLeastOneDay.
  ///
  /// In en, this message translates to:
  /// **'Pick at least one day of the week'**
  String get pickAtLeastOneDay;

  /// No description provided for @setValueTitle.
  ///
  /// In en, this message translates to:
  /// **'Set value'**
  String get setValueTitle;

  /// No description provided for @setUnitTitle.
  ///
  /// In en, this message translates to:
  /// **'Set {unit}'**
  String setUnitTitle(String unit);

  /// No description provided for @metricCurrentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get metricCurrentStreak;

  /// No description provided for @metricStreakTarget.
  ///
  /// In en, this message translates to:
  /// **'Streak Target'**
  String get metricStreakTarget;

  /// No description provided for @metricMaximumStreak.
  ///
  /// In en, this message translates to:
  /// **'Maximum Streak'**
  String get metricMaximumStreak;

  /// No description provided for @metricSuccessPercentage.
  ///
  /// In en, this message translates to:
  /// **'Success Percentage'**
  String get metricSuccessPercentage;

  /// No description provided for @metricWeeklyAverage.
  ///
  /// In en, this message translates to:
  /// **'Weekly Average'**
  String get metricWeeklyAverage;

  /// No description provided for @metricMonthlyAverage.
  ///
  /// In en, this message translates to:
  /// **'Monthly Average'**
  String get metricMonthlyAverage;

  /// No description provided for @backupDescription.
  ///
  /// In en, this message translates to:
  /// **'All habit data is stored locally on this device. Export a backup file to keep a copy or move it to another device, for example by sharing it to a cloud drive or email.'**
  String get backupDescription;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailed(String error);

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {error}'**
  String importFailed(String error);

  /// No description provided for @restoredCount.
  ///
  /// In en, this message translates to:
  /// **'Restored {count} habit(s)'**
  String restoredCount(int count);

  /// No description provided for @shareBackupText.
  ///
  /// In en, this message translates to:
  /// **'Islamic Habits backup'**
  String get shareBackupText;

  /// No description provided for @valueAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'New value added successfully'**
  String get valueAddedSuccess;

  /// No description provided for @prayerSunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get prayerSunrise;

  /// No description provided for @methodMuslimWorldLeague.
  ///
  /// In en, this message translates to:
  /// **'Muslim World League'**
  String get methodMuslimWorldLeague;

  /// No description provided for @methodEgyptian.
  ///
  /// In en, this message translates to:
  /// **'Egyptian'**
  String get methodEgyptian;

  /// No description provided for @methodKarachi.
  ///
  /// In en, this message translates to:
  /// **'Karachi'**
  String get methodKarachi;

  /// No description provided for @methodUmmAlQura.
  ///
  /// In en, this message translates to:
  /// **'Umm al-Qura'**
  String get methodUmmAlQura;

  /// No description provided for @methodDubai.
  ///
  /// In en, this message translates to:
  /// **'Dubai'**
  String get methodDubai;

  /// No description provided for @methodMoonSightingCommittee.
  ///
  /// In en, this message translates to:
  /// **'Moon Sighting Committee'**
  String get methodMoonSightingCommittee;

  /// No description provided for @methodNorthAmerica.
  ///
  /// In en, this message translates to:
  /// **'North America'**
  String get methodNorthAmerica;

  /// No description provided for @methodKuwait.
  ///
  /// In en, this message translates to:
  /// **'Kuwait'**
  String get methodKuwait;

  /// No description provided for @methodQatar.
  ///
  /// In en, this message translates to:
  /// **'Qatar'**
  String get methodQatar;

  /// No description provided for @methodSingapore.
  ///
  /// In en, this message translates to:
  /// **'Singapore'**
  String get methodSingapore;

  /// No description provided for @methodTurkey.
  ///
  /// In en, this message translates to:
  /// **'Turkey'**
  String get methodTurkey;

  /// No description provided for @methodTehran.
  ///
  /// In en, this message translates to:
  /// **'Tehran'**
  String get methodTehran;

  /// No description provided for @methodOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get methodOther;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'nb'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'nb':
      return AppLocalizationsNb();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
