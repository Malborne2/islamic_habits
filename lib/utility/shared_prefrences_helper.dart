import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final String _kAppTheme = 'Theme';
  static final String _kStartOfWeek = 'StartOfWeek';
  static final String _kOnboardingCompleted = 'OnboardingCompleted';
  static final String _kTasbeehGoal = 'TasbeehGoal';
  static final String _kTasbeehPreset = 'TasbeehPreset';
  static final String _kTasbeehColor = 'TasbeehColor';
  static final String _kTasbeehPattern = 'TasbeehPattern';

  static Future<String?> getAppTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kAppTheme);
  }

  static Future<bool> setAppTheme(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_kAppTheme, value);
  }

  static Future<int?> getStartOfWeek() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kStartOfWeek);
  }

  static Future<bool> setStartOfWeek(int weekday) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(_kStartOfWeek, weekday);
  }

  static Future<bool> getOnboardingCompleted() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kOnboardingCompleted) ?? false;
  }

  static Future<bool> setOnboardingCompleted(bool completed) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_kOnboardingCompleted, completed);
  }

  static Future<int?> getTasbeehGoal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kTasbeehGoal);
  }

  static Future<bool> setTasbeehGoal(int goal) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(_kTasbeehGoal, goal);
  }

  static Future<String?> getTasbeehPreset() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kTasbeehPreset);
  }

  static Future<bool> setTasbeehPreset(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_kTasbeehPreset, id);
  }

  static Future<String?> getTasbeehColor() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kTasbeehColor);
  }

  static Future<bool> setTasbeehColor(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_kTasbeehColor, id);
  }

  static Future<String?> getTasbeehPattern() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kTasbeehPattern);
  }

  static Future<bool> setTasbeehPattern(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_kTasbeehPattern, id);
  }
}
