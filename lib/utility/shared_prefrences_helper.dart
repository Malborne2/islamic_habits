import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final String _kAppTheme = 'Theme';
  static final String _kStartOfWeek = 'StartOfWeek';

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
}
