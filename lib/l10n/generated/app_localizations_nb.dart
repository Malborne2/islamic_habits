// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appTitle => 'Islamske Vaner';

  @override
  String get navHome => 'Hjem';

  @override
  String get navPrayerTimes => 'Bønnetider';

  @override
  String get navAllHabits => 'Alle vaner';

  @override
  String get navFivePrayers => 'De fem bønnene';

  @override
  String get navAddHabit => 'Legg til ny vane';

  @override
  String get editHabitTitle => 'Rediger vane';

  @override
  String get editHabitAction => 'Rediger vane';

  @override
  String get settingsTitle => 'Innstillinger';

  @override
  String get settingsDarkMode => 'Mørk modus';

  @override
  String get settingsStartOfWeek => 'Ukens start';

  @override
  String get settingsPrayerTimeSettings => 'Innstillinger for bønnetider';

  @override
  String get settingsPrayerTimeSettingsSubtitle =>
      'Sted, beregningsmetode og bønnepåminnelser';

  @override
  String get settingsBackupRestore => 'Sikkerhetskopi og gjenoppretting';

  @override
  String get settingsBackupRestoreSubtitle =>
      'Eksporter eller gjenopprett vanedataene dine';

  @override
  String get settingsLanguage => 'Språk';

  @override
  String get settingsLanguageSystem => 'Telefonens språk';

  @override
  String get todayHabits => 'Dagens vaner';

  @override
  String todayProgress(int completed, int total) {
    return 'I dag: $completed / $total vaner fullført';
  }

  @override
  String longestStreak(String daysText, String habitName) {
    return 'Lengste rekke: $daysText · $habitName';
  }

  @override
  String get save => 'Lagre';

  @override
  String get cancel => 'Avbryt';

  @override
  String get delete => 'Slett';

  @override
  String get edit => 'Rediger';

  @override
  String get archive => 'Arkiver';

  @override
  String get unarchive => 'Gjenopprett';

  @override
  String get archivedHabits => 'Arkiverte vaner';

  @override
  String get noArchivedHabits => 'Ingen arkiverte vaner';

  @override
  String get archivedHabitsHint =>
      'Arkiverte vaner beholder historikken, men skjules fra Hjem og statistikk.';

  @override
  String get habitIcon => 'Ikon';

  @override
  String get chooseIcon => 'Velg ikon';

  @override
  String get removeIcon => 'Fjern ikon';

  @override
  String get deleteHabitTitle => 'Slette vanen?';

  @override
  String deleteHabitMessage(String name) {
    return '«$name» og hele historikken slettes permanent. Dette kan ikke angres.';
  }

  @override
  String get habitDeleted => 'Vanen er slettet';

  @override
  String get habitArchived => 'Vanen er arkivert';

  @override
  String get habitRestored => 'Vanen er gjenopprettet';

  @override
  String get setValue => 'Angi';

  @override
  String get exportBackup => 'Eksporter sikkerhetskopi';

  @override
  String get restoreFromBackup => 'Gjenopprett fra sikkerhetskopi';

  @override
  String get habitName => 'Vanens navn';

  @override
  String get successMetric => 'Suksessmål';

  @override
  String get yesNo => 'Ja / Nei';

  @override
  String get number => 'Tall';

  @override
  String get streakTarget => 'Rekkemål';

  @override
  String get targetStreakDays => 'Rekkemål (dager)';

  @override
  String get schedule => 'Tidsplan';

  @override
  String get everyDay => 'Hver dag';

  @override
  String get certainDaysOfWeek => 'Bestemte ukedager';

  @override
  String get timesPerWeek => 'Et antall ganger per uke';

  @override
  String get color => 'Farge';

  @override
  String get saveHabit => 'Lagre vane';

  @override
  String get habitFajrPrayer => 'Fajr-bønn';

  @override
  String get habitDhuhrPrayer => 'Dhuhr-bønn';

  @override
  String get habitAsrPrayer => 'Asr-bønn';

  @override
  String get habitMaghribPrayer => 'Maghrib-bønn';

  @override
  String get habitIshaPrayer => 'Isha-bønn';

  @override
  String get habitRecitingQuran => 'Resitere Koranen';

  @override
  String get todayLabel => 'I dag';

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
  String get notifyMode => 'Varsle';

  @override
  String get silentMode => 'Stille';

  @override
  String get adhanMode => 'Adhan';

  @override
  String get weekdayMonday => 'Mandag';

  @override
  String get weekdayTuesday => 'Tirsdag';

  @override
  String get weekdayWednesday => 'Onsdag';

  @override
  String get weekdayThursday => 'Torsdag';

  @override
  String get weekdayFriday => 'Fredag';

  @override
  String get weekdaySaturday => 'Lørdag';

  @override
  String get weekdaySunday => 'Søndag';

  @override
  String get settingsNumerals => 'Tallsiffer';

  @override
  String get numeralsWestern => 'Vestlige (0, 1, 2…)';

  @override
  String get numeralsEastern => 'Østarabiske (٠, ١, ٢…)';

  @override
  String get unitPages => 'sider';

  @override
  String get deleteEntryTitle => 'Slett oppføring';

  @override
  String get deleteEntryConfirm =>
      'Er du sikker på at du vil slette denne oppføringen permanent?';

  @override
  String get targetAmountLabel => 'Målverdi';

  @override
  String get unitLabel => 'Enhet';

  @override
  String get timesPerWeekLabel => 'Ganger per uke';

  @override
  String get restoreBackupTitle => 'Gjenopprett sikkerhetskopi';

  @override
  String get restoreBackupConfirm =>
      'Dette vil erstatte alle vaner som er lagret på denne enheten med de fra den valgte sikkerhetskopien. Fortsette?';

  @override
  String get restoreAction => 'Gjenopprett';

  @override
  String get notificationPermissionDenied =>
      'Varslingstillatelse ble ikke gitt';

  @override
  String get prayerRemindersLabel => 'Bønnepåminnelser';

  @override
  String get prayerRemindersSubtitle =>
      '30 minutter etter hver bønn, spør om du har bedt';

  @override
  String get sendTestReminder => 'Send en testpåminnelse nå';

  @override
  String get batteryOptimizationHint =>
      'Hvis påminnelser fortsatt ikke kommer til rett tid, kan telefonens batterioptimalisering forsinke eller blokkere dem i bakgrunnen.';

  @override
  String get batteryOptimizationButton =>
      'Unnta denne appen fra batterioptimalisering';

  @override
  String get exactAlarmButton => 'Tillat eksakte alarmtider (anbefalt)';

  @override
  String get exactAlarmGranted =>
      'Eksakte alarmer er tillatt — påminnelser kommer til rett tid.';

  @override
  String get exactAlarmNotGranted =>
      'Eksakte alarmer er fortsatt ikke tillatt — prøv systeminnstillingene som nettopp åpnet.';

  @override
  String get adhanTakbeerOnlyLabel => 'Kun takbir';

  @override
  String get adhanTakbeerOnlyHint =>
      'Stopp etter den innledende takbiren i stedet for å spille hele opptaket';

  @override
  String get adhanVoiceLabel => 'Adhan-stemme';

  @override
  String get adhanVoiceHint =>
      'Brukes for bønner satt til høyttaler-ikonet (adhan) på bønnetider-skjermen.';

  @override
  String get takbeerOnly => 'Kun Takbeer';

  @override
  String get fullAdhan => 'Full Adhan';

  @override
  String get testAdhanVoice => 'Test denne stemmen';

  @override
  String get adhanAudioMissing =>
      'Ingen lydfil er lagt til for denne stemmen ennå — legg den til under android/app/src/main/res/raw for å høre den.';

  @override
  String get locationLabel => 'Sted';

  @override
  String get cityLabel => 'By';

  @override
  String get latitudeLabel => 'Breddegrad';

  @override
  String get longitudeLabel => 'Lengdegrad';

  @override
  String get citySearchHint => 'Søk etter en by';

  @override
  String get cityNotFoundPrompt => 'Finner du ikke byen din?';

  @override
  String get pickOnMap => 'Velg på kart';

  @override
  String get noCitiesFound => 'Ingen byer funnet';

  @override
  String get mapPickerTitle => 'Velg et sted';

  @override
  String get mapPickerInstructions =>
      'Trykk hvor som helst på kartet for å angi stedet for bønnetider';

  @override
  String get useThisLocation => 'Bruk dette stedet';

  @override
  String get customLocationLabel => 'Egendefinert sted';

  @override
  String get calculationMethodLabel => 'Beregningsmetode';

  @override
  String get madhabLabel => 'Madhab (Asr-beregning)';

  @override
  String get shafiLabel => 'Shafi';

  @override
  String get hanafiLabel => 'Hanafi';

  @override
  String get manualCorrectionLabel => 'Manuell korreksjon (minutter)';

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
  String get cityMecca => 'Mekka';

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
  String get cityCustom => 'Egendefinert';

  @override
  String get notificationPrayerTimeTitle => 'Bønnetid';

  @override
  String notificationPrayerTimeBody(String prayerName) {
    return 'Det er tid for $prayerName';
  }

  @override
  String get notificationReminderTitle => 'Bønnepåminnelse';

  @override
  String notificationReminderBody(String prayerName) {
    return 'Ba du $prayerName?';
  }

  @override
  String get notificationYes => 'Ja';

  @override
  String get notificationNo => 'Nei';

  @override
  String get weekdayMonShort => 'Man';

  @override
  String get weekdayTueShort => 'Tir';

  @override
  String get weekdayWedShort => 'Ons';

  @override
  String get weekdayThuShort => 'Tor';

  @override
  String get weekdayFriShort => 'Fre';

  @override
  String get weekdaySatShort => 'Lør';

  @override
  String get weekdaySunShort => 'Søn';

  @override
  String get pickAtLeastOneDay => 'Velg minst én ukedag';

  @override
  String get setValueTitle => 'Angi verdi';

  @override
  String setUnitTitle(String unit) {
    return 'Angi $unit';
  }

  @override
  String get metricCurrentStreak => 'Nåværende rekke';

  @override
  String get metricStreakTarget => 'Rekkemål';

  @override
  String get metricMaximumStreak => 'Lengste rekke';

  @override
  String get metricSuccessPercentage => 'Suksessrate';

  @override
  String get metricWeeklyAverage => 'Ukentlig gjennomsnitt';

  @override
  String get metricMonthlyAverage => 'Månedlig gjennomsnitt';

  @override
  String get backupDescription =>
      'Alle vanedata lagres lokalt på denne enheten. Eksporter en sikkerhetskopi for å beholde en kopi eller flytte den til en annen enhet, for eksempel ved å dele den til en skylagring eller e-post.';

  @override
  String exportFailed(String error) {
    return 'Eksport mislyktes: $error';
  }

  @override
  String importFailed(String error) {
    return 'Import mislyktes: $error';
  }

  @override
  String restoredCount(int count) {
    return 'Gjenopprettet $count vane(r)';
  }

  @override
  String get shareBackupText => 'Sikkerhetskopi av Islamske Vaner';

  @override
  String get valueAddedSuccess => 'Ny verdi lagt til';

  @override
  String get prayerSunrise => 'Soloppgang';

  @override
  String get methodMuslimWorldLeague => 'Muslim World League';

  @override
  String get methodEgyptian => 'Egyptisk';

  @override
  String get methodKarachi => 'Karachi';

  @override
  String get methodUmmAlQura => 'Umm al-Qura';

  @override
  String get methodDubai => 'Dubai';

  @override
  String get methodMoonSightingCommittee => 'Månesiktingskomiteen';

  @override
  String get methodNorthAmerica => 'Nord-Amerika';

  @override
  String get methodKuwait => 'Kuwait';

  @override
  String get methodQatar => 'Qatar';

  @override
  String get methodSingapore => 'Singapore';

  @override
  String get methodTurkey => 'Tyrkia';

  @override
  String get methodTehran => 'Teheran';

  @override
  String get methodOther => 'Annet';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dager',
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
  String get customColor => 'Egendefinert farge';

  @override
  String get selectColor => 'Velg';

  @override
  String get navStatistics => 'Statistikk';

  @override
  String get reminderLabel => 'Påminnelse';

  @override
  String get reminderEnabledLabel => 'Daglig påminnelse';

  @override
  String get reminderEnabledSubtitle => 'Få et varsel på tidspunktet du velger';

  @override
  String get reminderTimeLabel => 'Påminnelsestid';

  @override
  String get reminderIndependentHint =>
      'Denne påminnelsen er separat fra bønnepåminnelsene og fungerer selv når bønnepåminnelsene er av.';

  @override
  String reminderDailyAt(String time) {
    return 'Daglig kl. $time';
  }

  @override
  String get reminderOff => 'Av';

  @override
  String get notificationHabitReminderTitle => 'Vanevarsel';

  @override
  String notificationHabitReminderBody(String habitName) {
    return 'Tid for $habitName';
  }

  @override
  String get enterName => 'Skriv inn et navn';

  @override
  String get enterNumberGreaterThanZero => 'Skriv inn et tall større enn 0';

  @override
  String get enterNumberOneToSeven => 'Skriv inn et tall fra 1 til 7';

  @override
  String get onboardingSkip => 'Hopp over';

  @override
  String get onboardingNext => 'Neste';

  @override
  String get onboardingGetStarted => 'Kom i gang';

  @override
  String get onboardingWelcomeTitle => 'Velkommen til Islamic Habits';

  @override
  String get onboardingWelcomeBody =>
      'Bygg en jevn rutine rundt bønn, Koranen og vanene som betyr noe for deg.';

  @override
  String get onboardingHabitsTitle => 'Ett trykk om dagen';

  @override
  String get onboardingHabitsBody =>
      'Følg ja/nei- og tallvaner, velg dine egne farger og se fremgangen din med et blikk.';

  @override
  String get onboardingPrayerTitle => 'Bønnetider, uansett hvor du er';

  @override
  String get onboardingPrayerBody =>
      'Velg blant tusenvis av byer eller velg din nøyaktige posisjon for korrekte bønnetider.';

  @override
  String get onboardingRemindersTitle => 'Påminnelser som passer dagen din';

  @override
  String get onboardingRemindersBody =>
      'Sett en daglig påminnelse for enhver vane og svar ja eller nei direkte fra varselet.';

  @override
  String get onboardingStatsTitle => 'Se fremgangen din';

  @override
  String get onboardingStatsBody =>
      'Diagrammer, rekker og suksessrater hjelper deg å holde motivasjonen oppe og se hva som trenger oppmerksomhet.';

  @override
  String get statisticsOverallSuccess => 'Samlet suksess';

  @override
  String get statisticsOverallSuccessSubtitle =>
      'På tvers av alle registrerte vanedager';

  @override
  String get statisticsBestStreak => 'Beste rekke';

  @override
  String get statisticsTotalHabits => 'Vaner';

  @override
  String get statisticsDailyCompletion => 'Daglig fullføring';

  @override
  String get statisticsDailyCompletionSubtitle =>
      'Fullføringen av vanene dine de siste 30 dagene';

  @override
  String get statisticsWeeklyProgress => 'Ukentlig fremgang';

  @override
  String get statisticsWeeklyProgressSubtitle =>
      'Gjennomsnittlig fullføring de siste fire ukene';

  @override
  String get statisticsMonthlyProgress => 'Månedlig fremgang';

  @override
  String get statisticsMonthlyProgressSubtitle =>
      'Gjennomsnittlig fullføring de siste seks månedene';

  @override
  String get statisticsBreakdown => 'Vanedetaljer';

  @override
  String get statisticsBreakdownSubtitle =>
      'Fullførte, tapte og uregistrerte vanedager de siste 30 dagene';

  @override
  String get statisticsSuccess => 'Fullført';

  @override
  String get statisticsMissed => 'Tapt';

  @override
  String get statisticsNoData => 'Ingen data';

  @override
  String get statisticsHabitPerformance => 'Vaneresultater';

  @override
  String get statisticsNoDataTitle => 'Ingen data ennå';

  @override
  String get statisticsNoDataBody =>
      'Begynn å registrere vanene dine for å se diagrammer, rekker og suksessrater her.';
}
