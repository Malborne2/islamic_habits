import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_habits/screens/backup_screen.dart';
import 'package:islamic_habits/screens/prayer_settings_screen.dart';
import 'package:islamic_habits/utility/bloc/bloc.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/shared_prefrences_helper.dart';

const List<String> _kWeekdayNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

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
    final isDark =
        context.watch<ThemeBloc>().state.themeData.brightness ==
            Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: const Text('Dark mode'),
            value: isDark,
            onChanged: (value) {
              context.read<ThemeBloc>().add(
                  ThemeChanged(theme: value ? 'PurpleDark' : 'PurpleLight'));
            },
          ),
          ListTile(
            title: const Text('Start of week'),
            trailing: DropdownButton<int>(
              value: _startOfWeek,
              items: List.generate(
                7,
                (i) => DropdownMenuItem(
                  value: i + 1,
                  child: Text(_kWeekdayNames[i]),
                ),
              ),
              onChanged: _onStartOfWeekChanged,
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Prayer time settings'),
            subtitle: const Text(
                'Location, calculation method, and prayer reminders'),
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
            title: const Text('Backup & Restore'),
            subtitle: const Text('Export or restore your habit data'),
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
