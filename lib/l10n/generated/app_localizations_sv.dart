// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Islamiska vanor';

  @override
  String get navHome => 'Hem';

  @override
  String get navPrayerTimes => 'Bönetider';

  @override
  String get navAllHabits => 'Alla vanor';

  @override
  String get navFivePrayers => 'De fem bönerna';

  @override
  String get navAddHabit => 'Lägg till ny vana';

  @override
  String get editHabitTitle => 'Redigera vana';

  @override
  String get editHabitAction => 'Redigera vana';

  @override
  String get settingsTitle => 'Inställningar';

  @override
  String get settingsDarkMode => 'Mörkt läge';

  @override
  String get settingsStartOfWeek => 'Veckans start';

  @override
  String get settingsPrayerTimeSettings => 'Inställningar för bönetider';

  @override
  String get settingsPrayerTimeSettingsSubtitle =>
      'Plats, beräkningsmetod och böneparminnelser';

  @override
  String get settingsBackupRestore => 'Säkerhetskopiera och återställ';

  @override
  String get settingsBackupRestoreSubtitle =>
      'Exportera eller återställ dina vandata';

  @override
  String get settingsLanguage => 'Språk';

  @override
  String get settingsLanguageSystem => 'Telefonens språk';

  @override
  String get todayHabits => 'Dagens vanor';

  @override
  String todayProgress(int completed, int total) {
    return 'Idag: $completed / $total vanor klara';
  }

  @override
  String longestStreak(String daysText, String habitName) {
    return 'Längsta svit: $daysText · $habitName';
  }

  @override
  String get save => 'Spara';

  @override
  String get cancel => 'Avbryt';

  @override
  String get unsavedChangesTitle => 'Osparade ändringar';

  @override
  String get unsavedChangesMessage =>
      'Du har osparade ändringar i böneinställningarna. Vill du spara dem innan du lämnar?';

  @override
  String get discardChanges => 'Släng';

  @override
  String get delete => 'Ta bort';

  @override
  String get edit => 'Redigera';

  @override
  String get archive => 'Arkivera';

  @override
  String get unarchive => 'Återställ';

  @override
  String get archivedHabits => 'Arkiverade vanor';

  @override
  String get noArchivedHabits => 'Inga arkiverade vanor';

  @override
  String get archivedHabitsHint =>
      'Arkiverade vanor behåller historiken men döljs från Hem och statistik.';

  @override
  String get habitIcon => 'Ikon';

  @override
  String get chooseIcon => 'Välj ikon';

  @override
  String get removeIcon => 'Ta bort ikon';

  @override
  String get deleteHabitTitle => 'Radera vanan?';

  @override
  String deleteHabitMessage(String name) {
    return '”$name” och all dess historik raderas permanent. Detta kan inte ångras.';
  }

  @override
  String get habitDeleted => 'Vanen raderades';

  @override
  String get habitArchived => 'Vanan arkiverades';

  @override
  String get habitRestored => 'Vanan återställdes';

  @override
  String get setValue => 'Ange';

  @override
  String get exportBackup => 'Exportera säkerhetskopia';

  @override
  String get restoreFromBackup => 'Återställ från säkerhetskopia';

  @override
  String get habitName => 'Vanans namn';

  @override
  String get successMetric => 'Framgångsmått';

  @override
  String get yesNo => 'Ja / Nej';

  @override
  String get number => 'Nummer';

  @override
  String get streakTarget => 'Svitmål';

  @override
  String get targetStreakDays => 'Målsvit (dagar)';

  @override
  String get schedule => 'Schema';

  @override
  String get everyDay => 'Varje dag';

  @override
  String get certainDaysOfWeek => 'Vissa veckodagar';

  @override
  String get timesPerWeek => 'Ett antal gånger per vecka';

  @override
  String get color => 'Färg';

  @override
  String get saveHabit => 'Spara vana';

  @override
  String get habitFajrPrayer => 'Fajr-bönen';

  @override
  String get habitDhuhrPrayer => 'Dhuhr-bönen';

  @override
  String get habitAsrPrayer => 'Asr-bönen';

  @override
  String get habitMaghribPrayer => 'Maghrib-bönen';

  @override
  String get habitIshaPrayer => 'Isha-bönen';

  @override
  String get habitRecitingQuran => 'Recitera Koranen';

  @override
  String get todayLabel => 'Idag';

  @override
  String get prayerFajr => 'Fajr';

  @override
  String get prayerDhuhr => 'Dhuhr';

  @override
  String get prayerAsr => 'Asr';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Isha';

  @override
  String get notifyMode => 'Meddela';

  @override
  String get silentMode => 'Tyst';

  @override
  String get adhanMode => 'Adhan';

  @override
  String get weekdayMonday => 'Måndag';

  @override
  String get weekdayTuesday => 'Tisdag';

  @override
  String get weekdayWednesday => 'Onsdag';

  @override
  String get weekdayThursday => 'Torsdag';

  @override
  String get weekdayFriday => 'Fredag';

  @override
  String get weekdaySaturday => 'Lördag';

  @override
  String get weekdaySunday => 'Söndag';

  @override
  String get settingsNumerals => 'Sifferform';

  @override
  String get numeralsWestern => 'Västerländska (0, 1, 2…)';

  @override
  String get numeralsEastern => 'Östarabiska (٠, ١, ٢…)';

  @override
  String get unitPages => 'sidor';

  @override
  String get deleteEntryTitle => 'Ta bort post';

  @override
  String get deleteEntryConfirm =>
      'Är du säker på att du vill ta bort den här posten permanent?';

  @override
  String get targetAmountLabel => 'Målmängd';

  @override
  String get unitLabel => 'Enhet';

  @override
  String get timesPerWeekLabel => 'Gånger per vecka';

  @override
  String get restoreBackupTitle => 'Återställ säkerhetskopia';

  @override
  String get restoreBackupConfirm =>
      'Detta ersätter alla vanor som för närvarande lagras på enheten med dem från den valda säkerhetskopian. Fortsätta?';

  @override
  String get restoreAction => 'Återställ';

  @override
  String get notificationPermissionDenied =>
      'Tillstånd för meddelanden beviljades inte';

  @override
  String get prayerRemindersLabel => 'Bönepåminnelser';

  @override
  String get prayerRemindersSubtitle =>
      '30 minuter efter varje bön, fråga om du har bett';

  @override
  String get sendTestReminder => 'Skicka en testpåminnelse nu';

  @override
  String get batteryOptimizationHint =>
      'Om påminnelser fortfarande inte kommer i rätt tid kan telefonens batterioptimering fördröja eller blockera dem i bakgrunden.';

  @override
  String get batteryOptimizationButton =>
      'Undanta den här appen från batterioptimering';

  @override
  String get exactAlarmButton => 'Tillåt exakta larmtider (rekommenderas)';

  @override
  String get exactAlarmGranted =>
      'Exakta larm är tillåtna — påminnelser kommer i rätt tid.';

  @override
  String get exactAlarmNotGranted =>
      'Exakta larm är fortfarande inte tillåtna — prova systeminställningarna som just öppnades.';

  @override
  String get adhanTakbeerOnlyLabel => 'Endast takbir';

  @override
  String get adhanTakbeerOnlyHint =>
      'Stoppa efter den inledande takbiren istället för att spela hela inspelningen';

  @override
  String get adhanVoiceLabel => 'Adhan-röst';

  @override
  String get adhanVoiceHint =>
      'Används för böner inställda på högtalarikonen (adhan) på bönetidsskärmen.';

  @override
  String get takbeerOnly => 'Endast takbir';

  @override
  String get fullAdhan => 'Fullständig adhan';

  @override
  String get testAdhanVoice => 'Testa den här rösten';

  @override
  String get adhanAudioMissing =>
      'Ingen ljudfil är ännu bifogad för den här rösten — lägg till den under android/app/src/main/res/raw för att höra den.';

  @override
  String get locationLabel => 'Plats';

  @override
  String get cityLabel => 'Stad';

  @override
  String get latitudeLabel => 'Latitud';

  @override
  String get longitudeLabel => 'Longitud';

  @override
  String get citySearchHint => 'Sök efter en stad';

  @override
  String get cityNotFoundPrompt => 'Hittar du inte din stad?';

  @override
  String get pickOnMap => 'Välj på kartan';

  @override
  String get noCitiesFound => 'Inga städer hittades';

  @override
  String get mapPickerTitle => 'Välj en plats';

  @override
  String get mapPickerInstructions =>
      'Tryck var som helst på kartan för att ange din plats för bönetider';

  @override
  String get useThisLocation => 'Använd den här platsen';

  @override
  String get customLocationLabel => 'Anpassad plats';

  @override
  String get calculationMethodLabel => 'Beräkningsmetod';

  @override
  String get madhabLabel => 'Madhhab (Asr-beräkning)';

  @override
  String get shafiLabel => 'Shafi';

  @override
  String get hanafiLabel => 'Hanafi';

  @override
  String get manualCorrectionLabel => 'Manuell korrigering (minuter)';

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
  String get cityMecca => 'Mecka';

  @override
  String get cityMedina => 'Medina';

  @override
  String get cityCairo => 'Kairo';

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
  String get cityCustom => 'Anpassad';

  @override
  String get notificationPrayerTimeTitle => 'Bönetid';

  @override
  String notificationPrayerTimeBody(String prayerName) {
    return 'Det är dags för $prayerName';
  }

  @override
  String get notificationReminderTitle => 'Bönepåminnelse';

  @override
  String notificationReminderBody(String prayerName) {
    return 'Bad du $prayerName?';
  }

  @override
  String get notificationYes => 'Ja';

  @override
  String get notificationNo => 'Nej';

  @override
  String get weekdayMonShort => 'Mån';

  @override
  String get weekdayTueShort => 'Tis';

  @override
  String get weekdayWedShort => 'Ons';

  @override
  String get weekdayThuShort => 'Tor';

  @override
  String get weekdayFriShort => 'Fre';

  @override
  String get weekdaySatShort => 'Lör';

  @override
  String get weekdaySunShort => 'Sön';

  @override
  String get pickAtLeastOneDay => 'Välj minst en veckodag';

  @override
  String get setValueTitle => 'Ange värde';

  @override
  String setUnitTitle(String unit) {
    return 'Ange $unit';
  }

  @override
  String get metricCurrentStreak => 'Nuvarande svit';

  @override
  String get metricStreakTarget => 'Svitmål';

  @override
  String get metricMaximumStreak => 'Längsta svit';

  @override
  String get metricSuccessPercentage => 'Framgångsprocent';

  @override
  String get metricWeeklyAverage => 'Veckogenomsnitt';

  @override
  String get metricMonthlyAverage => 'Månadsgenomsnitt';

  @override
  String get backupDescription =>
      'All vandata lagras lokalt på den här enheten. Exportera en säkerhetskopia för att behålla en kopia eller flytta den till en annan enhet, till exempel genom att dela den till en molntjänst eller e-post.';

  @override
  String exportFailed(String error) {
    return 'Export misslyckades: $error';
  }

  @override
  String importFailed(String error) {
    return 'Import misslyckades: $error';
  }

  @override
  String restoredCount(int count) {
    return 'Återställde $count vana/vanor';
  }

  @override
  String get shareBackupText => 'Säkerhetskopia av Islamiska vanor';

  @override
  String get valueAddedSuccess => 'Nytt värde tillagt';

  @override
  String get prayerSunrise => 'Soluppgång';

  @override
  String get methodMuslimWorldLeague => 'Muslimska världsförbundet';

  @override
  String get methodEgyptian => 'Egyptisk';

  @override
  String get methodKarachi => 'Karachi';

  @override
  String get methodUmmAlQura => 'Umm al-Qura';

  @override
  String get methodDubai => 'Dubai';

  @override
  String get methodMoonSightingCommittee => 'Månskådningskommittén';

  @override
  String get methodNorthAmerica => 'Nordamerika';

  @override
  String get methodKuwait => 'Kuwait';

  @override
  String get methodQatar => 'Qatar';

  @override
  String get methodSingapore => 'Singapore';

  @override
  String get methodTurkey => 'Turkiet';

  @override
  String get methodTehran => 'Teheran';

  @override
  String get methodOther => 'Annan';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagar',
      one: '$count dag',
    );
    return '$_temp0';
  }

  @override
  String nextPrayerCountdownHm(int hours, int minutes) {
    return 'om ${hours}t ${minutes}m';
  }

  @override
  String nextPrayerCountdownM(int minutes) {
    return 'om ${minutes}m';
  }

  @override
  String get customColor => 'Anpassad färg';

  @override
  String get selectColor => 'Välj';

  @override
  String get navStatistics => 'Statistik';

  @override
  String get reminderLabel => 'Påminnelse';

  @override
  String get reminderEnabledLabel => 'Vanepåminnelse';

  @override
  String get reminderEnabledSubtitle =>
      'Få en avisering vid tiden du väljer på vanans schemalagda dagar';

  @override
  String get reminderTimeLabel => 'Påminnelsetid';

  @override
  String get reminderIndependentHint =>
      'Den här påminnelsen är separat från bönepåminnelserna och fungerar även när bönepåminnelserna är avstängda.';

  @override
  String reminderDailyAt(String time) {
    return 'Kl. $time';
  }

  @override
  String get reminderOff => 'Av';

  @override
  String get notificationHabitReminderTitle => 'Vanepåminnelse';

  @override
  String notificationHabitReminderBody(String habitName) {
    return 'Dags för $habitName';
  }

  @override
  String get enterName => 'Ange ett namn';

  @override
  String get enterNumberGreaterThanZero => 'Ange ett tal större än 0';

  @override
  String get enterNumberOneToSeven => 'Ange ett tal från 1 till 7';

  @override
  String get onboardingSkip => 'Hoppa över';

  @override
  String get onboardingNext => 'Nästa';

  @override
  String get onboardingGetStarted => 'Kom igång';

  @override
  String get onboardingWelcomeTitle => 'Välkommen till Islamic Habits';

  @override
  String get onboardingWelcomeBody =>
      'Bygg en jämn rutin kring bön, Koranen och vanorna som betyder något för dig.';

  @override
  String get onboardingHabitsTitle => 'Ett tryck om dagen';

  @override
  String get onboardingHabitsBody =>
      'Följ ja/nej- och siffervanor, välj dina egna färger och se dina framsteg direkt.';

  @override
  String get onboardingPrayerTitle => 'Bönetider, var du än är';

  @override
  String get onboardingPrayerBody =>
      'Välj bland tusentals städer eller välj din exakta plats för korrekta bönetider.';

  @override
  String get onboardingRemindersTitle => 'Påminnelser som passar din dag';

  @override
  String get onboardingRemindersBody =>
      'Ställ in en daglig påminnelse för vilken vana som helst och svara ja eller nej direkt från aviseringen.';

  @override
  String get onboardingStatsTitle => 'Se dina framsteg';

  @override
  String get onboardingStatsBody =>
      'Diagram, sviter och framgångsfrekvens hjälper dig att hålla motivationen uppe och se vad som behöver uppmärksamhet.';

  @override
  String get statisticsOverallSuccess => 'Total framgång';

  @override
  String get statisticsOverallSuccessSubtitle =>
      'Över alla registrerade vanedagar';

  @override
  String get statisticsBestStreak => 'Bästa svit';

  @override
  String get statisticsTotalHabits => 'Vanor';

  @override
  String get statisticsDailyCompletion => 'Dagligt slutförande';

  @override
  String get statisticsDailyCompletionSubtitle =>
      'Ditt slutförande av vanor de senaste 30 dagarna';

  @override
  String get statisticsWeeklyProgress => 'Veckoframsteg';

  @override
  String get statisticsWeeklyProgressSubtitle =>
      'Genomsnittligt slutförande de senaste fyra veckorna';

  @override
  String get statisticsMonthlyProgress => 'Månadsframsteg';

  @override
  String get statisticsMonthlyProgressSubtitle =>
      'Genomsnittligt slutförande de senaste sex månaderna';

  @override
  String get statisticsBreakdown => 'Vanöversikt';

  @override
  String get statisticsBreakdownSubtitle =>
      'Slutförda, missade och oregistrerade vanedagar de senaste 30 dagarna';

  @override
  String get statisticsSuccess => 'Slutförd';

  @override
  String get statisticsMissed => 'Missad';

  @override
  String get statisticsNoData => 'Ingen data';

  @override
  String get statisticsHabitPerformance => 'Vaneprestation';

  @override
  String get statisticsNoDataTitle => 'Ingen data än';

  @override
  String get statisticsNoDataBody =>
      'Börja logga dina vanor för att se diagram, sviter och framgångsfrekvens här.';
}
