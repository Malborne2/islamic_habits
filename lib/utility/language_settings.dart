import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<Locale> kSupportedLocales = [
  Locale('en'),
  Locale('ar'),
  Locale('nb'),
  Locale('ja'),
  Locale('sv'),
  Locale('fi'),
  Locale('ur'),
  Locale('fa'),
  Locale('id'),
];

const Map<String, String> kLanguageNames = {
  'en': 'English',
  'ar': 'العربية',
  'nb': 'Norsk',
  'ja': '日本語',
  'sv': 'Svenska',
  'fi': 'Suomi',
  'ur': 'اردو',
  'fa': 'فارسی',
  'id': 'Bahasa Indonesia',
};

// null means "follow the phone's language" (falling back to English if the
// phone's language isn't one of the supported ones).
class LanguageSettings {
  // The app's locale as a listenable value, so the root MaterialApp can
  // rebuild immediately when the user changes the language in Settings.
  static final ValueNotifier<Locale?> localeNotifier = ValueNotifier(null);

  static Locale? get locale => localeNotifier.value;

  static const _kLanguageCode = 'LanguageCode';

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_kLanguageCode);
    localeNotifier.value = code == null ? null : Locale(code);
  }

  static Future<void> setLocale(Locale? value) async {
    localeNotifier.value = value;
    final prefs = await SharedPreferences.getInstance();
    if (value == null) {
      await prefs.remove(_kLanguageCode);
    } else {
      await prefs.setString(_kLanguageCode, value.languageCode);
    }
  }
}
