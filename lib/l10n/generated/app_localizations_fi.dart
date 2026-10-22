// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'Islamilaiset tavat';

  @override
  String get navHome => 'Koti';

  @override
  String get navPrayerTimes => 'Rukousajat';

  @override
  String get navAllHabits => 'Kaikki tavat';

  @override
  String get navFivePrayers => 'Viisi rukousta';

  @override
  String get navAddHabit => 'Lisää uusi tapa';

  @override
  String get editHabitTitle => 'Muokkaa tapaa';

  @override
  String get editHabitAction => 'Muokkaa tapaa';

  @override
  String get settingsTitle => 'Asetukset';

  @override
  String get settingsDarkMode => 'Tumma tila';

  @override
  String get settingsStartOfWeek => 'Viikon alkupäivä';

  @override
  String get settingsPrayerTimeSettings => 'Rukousaika-asetukset';

  @override
  String get settingsPrayerTimeSettingsSubtitle =>
      'Sijainti, laskentamenetelmä ja rukousmuistutukset';

  @override
  String get settingsBackupRestore => 'Varmuuskopiointi ja palautus';

  @override
  String get settingsBackupRestoreSubtitle => 'Vie tai palauta tapatietosi';

  @override
  String get settingsLanguage => 'Kieli';

  @override
  String get settingsLanguageSystem => 'Puhelimen kieli';

  @override
  String get todayHabits => 'Tämän päivän tavat';

  @override
  String todayProgress(int completed, int total) {
    return 'Tänään: $completed / $total tapaa tehty';
  }

  @override
  String longestStreak(String daysText, String habitName) {
    return 'Pisin putki: $daysText · $habitName';
  }

  @override
  String get save => 'Tallenna';

  @override
  String get cancel => 'Peruuta';

  @override
  String get delete => 'Poista';

  @override
  String get setValue => 'Aseta';

  @override
  String get exportBackup => 'Vie varmuuskopio';

  @override
  String get restoreFromBackup => 'Palauta varmuuskopiosta';

  @override
  String get habitName => 'Tavan nimi';

  @override
  String get successMetric => 'Onnistumismittari';

  @override
  String get yesNo => 'Kyllä / Ei';

  @override
  String get number => 'Numero';

  @override
  String get streakTarget => 'Putkitavoite';

  @override
  String get targetStreakDays => 'Tavoiteputki (päivää)';

  @override
  String get schedule => 'Aikataulu';

  @override
  String get everyDay => 'Joka päivä';

  @override
  String get certainDaysOfWeek => 'Tietyt viikonpäivät';

  @override
  String get timesPerWeek => 'Tietty määrä kertoja viikossa';

  @override
  String get color => 'Väri';

  @override
  String get saveHabit => 'Tallenna tapa';

  @override
  String get habitFajrPrayer => 'Fajr-rukous';

  @override
  String get habitDhuhrPrayer => 'Dhuhr-rukous';

  @override
  String get habitAsrPrayer => 'Asr-rukous';

  @override
  String get habitMaghribPrayer => 'Maghrib-rukous';

  @override
  String get habitIshaPrayer => 'Isha-rukous';

  @override
  String get habitRecitingQuran => 'Koraanin lukeminen';

  @override
  String get todayLabel => 'Tänään';

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
  String get notifyMode => 'Ilmoita';

  @override
  String get silentMode => 'Äänetön';

  @override
  String get adhanMode => 'Adhan';

  @override
  String get weekdayMonday => 'Maanantai';

  @override
  String get weekdayTuesday => 'Tiistai';

  @override
  String get weekdayWednesday => 'Keskiviikko';

  @override
  String get weekdayThursday => 'Torstai';

  @override
  String get weekdayFriday => 'Perjantai';

  @override
  String get weekdaySaturday => 'Lauantai';

  @override
  String get weekdaySunday => 'Sunnuntai';

  @override
  String get settingsNumerals => 'Numeromuoto';

  @override
  String get numeralsWestern => 'Länsimaiset (0, 1, 2…)';

  @override
  String get numeralsEastern => 'Itäarabialaiset (٠, ١, ٢…)';

  @override
  String get unitPages => 'sivua';

  @override
  String get deleteEntryTitle => 'Poista merkintä';

  @override
  String get deleteEntryConfirm =>
      'Haluatko varmasti poistaa tämän merkinnän pysyvästi?';

  @override
  String get targetAmountLabel => 'Tavoitemäärä';

  @override
  String get unitLabel => 'Yksikkö';

  @override
  String get timesPerWeekLabel => 'Kertaa viikossa';

  @override
  String get restoreBackupTitle => 'Palauta varmuuskopio';

  @override
  String get restoreBackupConfirm =>
      'Tämä korvaa kaikki laitteelle tallennetut tavat valitun varmuuskopion tiedoilla. Jatketaanko?';

  @override
  String get restoreAction => 'Palauta';

  @override
  String get notificationPermissionDenied => 'Ilmoituslupaa ei myönnetty';

  @override
  String get prayerRemindersLabel => 'Rukousmuistutukset';

  @override
  String get prayerRemindersSubtitle =>
      '30 minuuttia jokaisen rukouksen jälkeen kysytään, rukoilitko';

  @override
  String get sendTestReminder => 'Lähetä testimuistutus nyt';

  @override
  String get batteryOptimizationHint =>
      'Jos muistutukset eivät silti saavu oikeaan aikaan, puhelimesi akun optimointi saattaa viivästyttää tai estää niitä taustalla.';

  @override
  String get batteryOptimizationButton =>
      'Vapauta tämä sovellus akun optimoinnista';

  @override
  String get adhanVoiceLabel => 'Adhan-ääni';

  @override
  String get adhanVoiceHint =>
      'Käytetään rukouksille, jotka on asetettu mikrofonikuvakkeeseen (adhan) rukousaikanäytöllä.';

  @override
  String get takbeerOnly => 'Vain takbir';

  @override
  String get fullAdhan => 'Täysi adhan';

  @override
  String get testAdhanVoice => 'Testaa tätä ääntä';

  @override
  String get adhanAudioMissing =>
      'Tälle äänelle ei vielä ole liitetty äänitiedostoa — lisää se kansioon android/app/src/main/res/raw kuullaksesi sen.';

  @override
  String get locationLabel => 'Sijainti';

  @override
  String get cityLabel => 'Kaupunki';

  @override
  String get latitudeLabel => 'Leveysaste';

  @override
  String get longitudeLabel => 'Pituusaste';

  @override
  String get citySearchHint => 'Hae kaupunkia';

  @override
  String get cityNotFoundPrompt => 'Etkö löydä kaupunkiasi?';

  @override
  String get pickOnMap => 'Valitse kartalta';

  @override
  String get noCitiesFound => 'Kaupunkeja ei löytynyt';

  @override
  String get mapPickerTitle => 'Valitse sijainti';

  @override
  String get mapPickerInstructions =>
      'Napauta karttaa mistä tahansa asettaaksesi rukousaikojen sijainnin';

  @override
  String get useThisLocation => 'Käytä tätä sijaintia';

  @override
  String get customLocationLabel => 'Mukautettu sijainti';

  @override
  String get calculationMethodLabel => 'Laskentamenetelmä';

  @override
  String get madhabLabel => 'Madhhab (Asr-laskenta)';

  @override
  String get shafiLabel => 'Shafi';

  @override
  String get hanafiLabel => 'Hanafi';

  @override
  String get manualCorrectionLabel => 'Manuaalinen korjaus (minuuttia)';

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
  String get cityLondon => 'Lontoo';

  @override
  String get cityNewYork => 'New York';

  @override
  String get cityCustom => 'Mukautettu';

  @override
  String get notificationPrayerTimeTitle => 'Rukousaika';

  @override
  String notificationPrayerTimeBody(String prayerName) {
    return 'On aika rukoilla $prayerName';
  }

  @override
  String get notificationReminderTitle => 'Rukousmuistutus';

  @override
  String notificationReminderBody(String prayerName) {
    return 'Rukoilitko $prayerName?';
  }

  @override
  String get notificationYes => 'Kyllä';

  @override
  String get notificationNo => 'Ei';

  @override
  String get weekdayMonShort => 'Ma';

  @override
  String get weekdayTueShort => 'Ti';

  @override
  String get weekdayWedShort => 'Ke';

  @override
  String get weekdayThuShort => 'To';

  @override
  String get weekdayFriShort => 'Pe';

  @override
  String get weekdaySatShort => 'La';

  @override
  String get weekdaySunShort => 'Su';

  @override
  String get pickAtLeastOneDay => 'Valitse vähintään yksi viikonpäivä';

  @override
  String get setValueTitle => 'Aseta arvo';

  @override
  String setUnitTitle(String unit) {
    return 'Aseta $unit';
  }

  @override
  String get metricCurrentStreak => 'Nykyinen putki';

  @override
  String get metricStreakTarget => 'Putkitavoite';

  @override
  String get metricMaximumStreak => 'Pisin putki';

  @override
  String get metricSuccessPercentage => 'Onnistumisprosentti';

  @override
  String get metricWeeklyAverage => 'Viikkokeskiarvo';

  @override
  String get metricMonthlyAverage => 'Kuukausikeskiarvo';

  @override
  String get backupDescription =>
      'Kaikki tapatiedot tallennetaan paikallisesti tähän laitteeseen. Vie varmuuskopiotiedosto säilyttääksesi kopion tai siirtääksesi sen toiselle laitteelle, esimerkiksi jakamalla se pilvipalveluun tai sähköpostiin.';

  @override
  String exportFailed(String error) {
    return 'Vienti epäonnistui: $error';
  }

  @override
  String importFailed(String error) {
    return 'Tuonti epäonnistui: $error';
  }

  @override
  String restoredCount(int count) {
    return 'Palautettiin $count tapaa';
  }

  @override
  String get shareBackupText => 'Islamilaiset tavat -varmuuskopio';

  @override
  String get valueAddedSuccess => 'Uusi arvo lisätty onnistuneesti';

  @override
  String get prayerSunrise => 'Auringonnousu';

  @override
  String get methodMuslimWorldLeague => 'Muslim World League';

  @override
  String get methodEgyptian => 'Egyptiläinen';

  @override
  String get methodKarachi => 'Karachi';

  @override
  String get methodUmmAlQura => 'Umm al-Qura';

  @override
  String get methodDubai => 'Dubai';

  @override
  String get methodMoonSightingCommittee => 'Kuun havainnointikomitea';

  @override
  String get methodNorthAmerica => 'Pohjois-Amerikka';

  @override
  String get methodKuwait => 'Kuwait';

  @override
  String get methodQatar => 'Qatar';

  @override
  String get methodSingapore => 'Singapore';

  @override
  String get methodTurkey => 'Turkki';

  @override
  String get methodTehran => 'Teheran';

  @override
  String get methodOther => 'Muu';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count päivää',
      one: '$count päivä',
    );
    return '$_temp0';
  }

  @override
  String nextPrayerCountdownHm(int hours, int minutes) {
    return '$hours t $minutes min kuluttua';
  }

  @override
  String nextPrayerCountdownM(int minutes) {
    return '$minutes min kuluttua';
  }
}
