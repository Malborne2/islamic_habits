import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kEasternArabicDigits = '٠١٢٣٤٥٦٧٨٩';

// Arabic locale data formats numbers with Eastern Arabic-Indic digits by
// default; most apps (and most Arabic-speaking users' phones) instead show
// plain Western digits, so that's the default here too, with this setting
// as the opt-in override back to Eastern digits.
class NumeralSettings {
  static bool useEasternArabicNumerals = false;
  static const _key = 'UseEasternArabicNumerals';

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    useEasternArabicNumerals = prefs.getBool(_key) ?? false;
  }

  static Future<void> setUseEasternArabicNumerals(bool value) async {
    useEasternArabicNumerals = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}

// Converts Eastern Arabic-Indic digits in [text] back to Western digits,
// unless the user opted into Eastern numerals or the current locale isn't
// Arabic (in which case [text] is returned unchanged).
String localizeDigits(BuildContext context, String text) {
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';
  if (!isArabic || NumeralSettings.useEasternArabicNumerals) return text;
  final buffer = StringBuffer();
  for (final ch in text.split('')) {
    final idx = _kEasternArabicDigits.indexOf(ch);
    buffer.write(idx == -1 ? ch : idx.toString());
  }
  return buffer.toString();
}
