import 'package:adhan/adhan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerCity {
  final String name;
  final double latitude;
  final double longitude;
  const PrayerCity(this.name, this.latitude, this.longitude);
}

// Per-prayer notification behavior, selected via the bell icon on the
// prayer times screen.
enum PrayerNotifyMode { notify, silent, adhan }

// Which audio plays for prayers set to PrayerNotifyMode.adhan. `id` is the
// persisted preference value and the notification-channel suffix;
// `soundResource` is the filename (without extension) expected at
// android/app/src/main/res/raw/<soundResource>.mp3. Add more entries here
// (and the matching audio file) to offer more voices to choose from.
class AdhanVoiceOption {
  final String id;
  final String soundResource;
  final String displayName;
  const AdhanVoiceOption(this.id, this.soundResource, this.displayName);
}

const List<AdhanVoiceOption> kAdhanVoices = [
  AdhanVoiceOption('takbeer', 'takbeer', 'Takbeer only'),
  AdhanVoiceOption('full', 'adhan_full', 'Full Adhan'),
  AdhanVoiceOption('makkah', 'adhan_makkah', 'Makkah (Haramain)'),
  AdhanVoiceOption('madinah', 'adhan_madinah', 'Madinah (Haramain)'),
];

const List<PrayerCity> kPrayerCities = [
  PrayerCity('Doha', 25.3157001, 51.8788493),
  PrayerCity('Mecca', 21.3891, 39.8579),
  PrayerCity('Medina', 24.5247, 39.5692),
  PrayerCity('Cairo', 30.0444, 31.2357),
  PrayerCity('Istanbul', 41.0082, 28.9784),
  PrayerCity('Jakarta', -6.2088, 106.8456),
  PrayerCity('Karachi', 24.8607, 67.0011),
  PrayerCity('London', 51.5072, -0.1276),
  PrayerCity('New York', 40.7128, -74.0060),
  PrayerCity('Custom', 0, 0),
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
