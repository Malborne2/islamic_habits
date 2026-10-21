import 'package:adhan/adhan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerCity {
  final String name;
  final double latitude;
  final double longitude;
  const PrayerCity(this.name, this.latitude, this.longitude);
}

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
