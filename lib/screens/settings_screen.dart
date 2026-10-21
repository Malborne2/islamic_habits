import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/screens/backup_screen.dart';
import 'package:islamic_habits/screens/prayer_settings_screen.dart';
import 'package:islamic_habits/utility/bloc/bloc.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/language_settings.dart';
import 'package:islamic_habits/utility/numeral_settings.dart';
import 'package:islamic_habits/utility/shared_prefrences_helper.dart';

// weekday is an ISO weekday int (1=Monday .. 7=Sunday).
String _weekdayName(AppLocalizations l10n, int weekday) {
  switch (weekday) {
    case 1:
      return l10n.weekdayMonday;
    case 2:
      return l10n.weekdayTuesday;
    case 3:
      return l10n.weekdayWednesday;
    case 4:
      return l10n.weekdayThursday;
    case 5:
      return l10n.weekdayFriday;
    case 6:
      return l10n.weekdaySaturday;
    default:
      return l10n.weekdaySunday;
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late int _startOfWeek = kStartOfWeek;

  Future<void> _onStartOfWeekChanged(int? weekday) async {
    if (weekday == null) return;
    setState(() => _startOfWeek = weekday);
    kStartOfWeek = weekday;
    Habit.startOfWeek = weekday;
    await SharedPreferencesHelper.setStartOfWeek(weekday);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark =
        context.watch<ThemeBloc>().state.themeData.brightness ==
            Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: Text(l10n.settingsDarkMode),
            value: isDark,
            onChanged: (value) {
              context.read<ThemeBloc>().add(
                  ThemeChanged(theme: value ? 'PurpleDark' : 'PurpleLight'));
            },
          ),
          ListTile(
            title: Text(l10n.settingsStartOfWeek),
            trailing: DropdownButton<int>(
              value: _startOfWeek,
              items: List.generate(
                7,
                (i) => DropdownMenuItem(
                  value: i + 1,
                  child: Text(_weekdayName(l10n, i + 1)),
                ),
              ),
              onChanged: _onStartOfWeekChanged,
            ),
          ),
          ListTile(
            title: Text(l10n.settingsLanguage),
            trailing: DropdownButton<String>(
              value: LanguageSettings.locale?.languageCode ?? 'system',
              items: [
                DropdownMenuItem(
                    value: 'system', child: Text(l10n.settingsLanguageSystem)),
                ...kSupportedLocales.map((locale) => DropdownMenuItem(
                      value: locale.languageCode,
                      child: Text(kLanguageNames[locale.languageCode]!),
                    )),
              ],
              onChanged: (value) {
                setState(() {
                  LanguageSettings.setLocale(value == null || value == 'system'
                      ? null
                      : Locale(value));
                });
              },
            ),
          ),
          if (Localizations.localeOf(context).languageCode == 'ar')
            ListTile(
              title: Text(l10n.settingsNumerals),
              trailing: DropdownButton<bool>(
                value: NumeralSettings.useEasternArabicNumerals,
                items: [
                  DropdownMenuItem(
                      value: false, child: Text(l10n.numeralsWestern)),
                  DropdownMenuItem(
                      value: true, child: Text(l10n.numeralsEastern)),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    NumeralSettings.setUseEasternArabicNumerals(value);
                  });
                },
              ),
            ),
          const Divider(),
          ListTile(
            title: Text(l10n.settingsPrayerTimeSettings),
            subtitle: Text(l10n.settingsPrayerTimeSettingsSubtitle),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PrayerSettingsScreen(),
                      settings: const RouteSettings(
                          name: '/PrayerSettingsScreen')));
            },
          ),
          const Divider(),
          ListTile(
            title: Text(l10n.settingsBackupRestore),
            subtitle: Text(l10n.settingsBackupRestoreSubtitle),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BackupScreen(),
                      settings: const RouteSettings(name: '/BackupScreen')));
            },
          ),
        ],
      ),
    );
  }
}
