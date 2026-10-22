import 'package:adhan/adhan.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Per-prayer notification behavior, selected via the bell icon on the
// prayer times screen.
enum PrayerNotifyMode { notify, silent, adhan }

// Which reciter plays for prayers set to PrayerNotifyMode.adhan. `id` is the
// persisted preference value and part of the notification-channel name;
// `fullResource`/`takbeerResource` are filenames (without extension)
// expected at android/app/src/main/res/raw/. The "Takbeer only" vs "full
// recording" choice is a separate, orthogonal setting (PrayerSettings.
// adhanTakbeerOnly) — each voice ships both a full file and a pre-trimmed
// takbeer-only cut of the same recording, since Android's notification
// sound API can't stop partway through a file on its own. Add a voice by
// adding an entry here plus both audio files.
class AdhanVoiceOption {
  final String id;
  final String fullResource;
  final String takbeerResource;
  final String displayName;
  const AdhanVoiceOption(
      this.id, this.fullResource, this.takbeerResource, this.displayName);

  // Same two files as fullResource/takbeerResource, bundled a second time as
  // Flutter assets (see assets/adhan/ and pubspec.yaml) so the Settings
  // "Test this voice" preview can play them directly through an in-app
  // audio player instead of triggering a system notification.
  String get fullAsset => 'assets/adhan/$fullResource.mp3';
  String get takbeerAsset => 'assets/adhan/$takbeerResource.mp3';
}

const List<AdhanVoiceOption> kAdhanVoices = [
  AdhanVoiceOption(
      'voice1', 'adhan_01_full', 'adhan_01_takbeer', 'Ahmad Al-Haddad'),
  AdhanVoiceOption(
      'voice2', 'adhan_02_full', 'adhan_02_takbeer', 'Tariq Fathi Ahmad'),
  AdhanVoiceOption(
      'voice3', 'adhan_03_full', 'adhan_03_takbeer', 'Hamza Al-Majali'),
  AdhanVoiceOption(
      'voice4', 'adhan_04_full', 'adhan_04_takbeer', 'Ahmad Al-Kurdi'),
  AdhanVoiceOption('voice5', 'adhan_05_full', 'adhan_05_takbeer',
      'Rabah Bendareh Al-Jazairi'),
  AdhanVoiceOption(
      'voice6', 'adhan_06_full', 'adhan_06_takbeer', 'Al-Haram Al-Madani'),
  AdhanVoiceOption('voice7', 'adhan_07_full', 'adhan_07_takbeer',
      'Noureddine Hamza Al-Maghribi'),
  AdhanVoiceOption(
      'voice8', 'adhan_08_full', 'adhan_08_takbeer', 'Mohammed Rammal'),
];


// Global, in-memory prayer configuration. Mirrors the pattern already used by
// kStartOfWeek: a mutable value every screen reads directly, loaded once at
// startup and persisted whenever it changes.
class PrayerSettings {
  static double latitude = 25.3157001;
  static double longitude = 51.8788493;
  static String cityName = 'Doha';
  static CalculationMethod calculationMethod = CalculationMethod.qatar;
  static Madhab madhab = Madhab.shafi;
  static PrayerAdjustments adjustments = PrayerAdjustments();
  static bool remindersEnabled = false;
  static List<PrayerNotifyMode> prayerModes =
      List.filled(5, PrayerNotifyMode.notify);
  static String adhanVoiceId = kAdhanVoices.first.id;
  static AdhanVoiceOption get adhanVoice => kAdhanVoices.firstWhere(
      (v) => v.id == adhanVoiceId,
      orElse: () => kAdhanVoices.first);
  // Whether Adhan playback stops after the takbeer or plays the full
  // recording — applies to whichever voice is selected above.
  static bool adhanTakbeerOnly = false;

  static const _kLat = 'PrayerLatitude';
  static const _kLon = 'PrayerLongitude';
  static const _kCity = 'PrayerCity';
  static const _kMethod = 'PrayerCalculationMethod';
  static const _kMadhab = 'PrayerMadhab';
  static const _kAdjFajr = 'PrayerAdjFajr';
  static const _kAdjDhuhr = 'PrayerAdjDhuhr';
  static const _kAdjAsr = 'PrayerAdjAsr';
  static const _kAdjMaghrib = 'PrayerAdjMaghrib';
  static const _kAdjIsha = 'PrayerAdjIsha';
  static const _kRemindersEnabled = 'PrayerRemindersEnabled';
  static const _kPrayerModes = 'PrayerNotifyModes';
  static const _kAdhanVoice = 'AdhanVoice';
  static const _kAdhanTakbeerOnly = 'AdhanTakbeerOnly';

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    latitude = prefs.getDouble(_kLat) ?? latitude;
    longitude = prefs.getDouble(_kLon) ?? longitude;
    cityName = prefs.getString(_kCity) ?? cityName;

    final methodName = prefs.getString(_kMethod);
    if (methodName != null) {
      calculationMethod = CalculationMethod.values.firstWhere(
          (m) => m.name == methodName,
          orElse: () => calculationMethod);
    }

    final madhabName = prefs.getString(_kMadhab);
    if (madhabName != null) {
      madhab = Madhab.values
          .firstWhere((m) => m.name == madhabName, orElse: () => madhab);
    }

    adjustments = PrayerAdjustments(
      fajr: prefs.getInt(_kAdjFajr) ?? 0,
      dhuhr: prefs.getInt(_kAdjDhuhr) ?? 0,
      asr: prefs.getInt(_kAdjAsr) ?? 0,
      maghrib: prefs.getInt(_kAdjMaghrib) ?? 0,
      isha: prefs.getInt(_kAdjIsha) ?? 0,
    );

    remindersEnabled = prefs.getBool(_kRemindersEnabled) ?? false;

    final modeIndexes = prefs.getStringList(_kPrayerModes);
    if (modeIndexes != null && modeIndexes.length == 5) {
      prayerModes = modeIndexes
          .map((i) => PrayerNotifyMode.values[int.parse(i)])
          .toList();
    }

    adhanVoiceId = prefs.getString(_kAdhanVoice) ?? adhanVoiceId;
    adhanTakbeerOnly =
        prefs.getBool(_kAdhanTakbeerOnly) ?? adhanTakbeerOnly;
  }

  static Future<void> setPrayerMode(int prayerIndex, PrayerNotifyMode mode) async {
    prayerModes[prayerIndex] = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kPrayerModes,
        prayerModes.map((m) => m.index.toString()).toList());
  }

  static Future<void> setAdhanVoice(AdhanVoiceOption voice) async {
    adhanVoiceId = voice.id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAdhanVoice, voice.id);
  }

  static Future<void> setAdhanTakbeerOnly(bool value) async {
    adhanTakbeerOnly = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAdhanTakbeerOnly, value);
  }

  static Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kLat, latitude);
    await prefs.setDouble(_kLon, longitude);
    await prefs.setString(_kCity, cityName);
    await prefs.setString(_kMethod, calculationMethod.name);
    await prefs.setString(_kMadhab, madhab.name);
    await prefs.setInt(_kAdjFajr, adjustments.fajr);
    await prefs.setInt(_kAdjDhuhr, adjustments.dhuhr);
    await prefs.setInt(_kAdjAsr, adjustments.asr);
    await prefs.setInt(_kAdjMaghrib, adjustments.maghrib);
    await prefs.setInt(_kAdjIsha, adjustments.isha);
  }

  static Future<void> setRemindersEnabled(bool value) async {
    remindersEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kRemindersEnabled, value);
  }

  static CalculationParameters getParameters() {
    final params = calculationMethod.getParameters();
    params.madhab = madhab;
    params.adjustments = adjustments;
    return params;
  }
}
