import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:islamic_habits/utility/data_access_object.dart';
import 'package:islamic_habits/utility/habit.dart';

// Local-file backup/restore. A cloud-backed implementation (e.g. Google
// Drive, Firebase) can later export/import through the same JSON shape
// produced here, so it can be wired in without touching the storage layer.
class BackupService {
  final HabitDao _dao = HabitDao();

  Future<File> exportToFile() async {
    final habits = await _dao.getAll();
    final prefs = await SharedPreferences.getInstance();
    final settings = <String, dynamic>{
      for (final key in prefs.getKeys()) key: prefs.get(key),
    };
    final data = {
      'version': 2,
      'exportedAt': DateTime.now().toIso8601String(),
      'habits': habits.map((h) => h.toMap()).toList(),
      'settings': settings,
    };

    final documentsDir = await getApplicationDocumentsDirectory();
    final backupsDir = Directory(join(documentsDir.path, 'backups'));
    if (!await backupsDir.exists()) {
      await backupsDir.create(recursive: true);
    }

    final fileName =
        'islamic_habits_backup_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.json';
    final file = File(join(backupsDir.path, fileName));
    await file.writeAsString(jsonEncode(data));
    return file;
  }

  Future<int> importFromFile(File file) async {
    final content = await file.readAsString();
    final data = jsonDecode(content) as Map<String, dynamic>;
    final habitsJson = data['habits'] as List;
    final habits = habitsJson
        .map((m) => Habit.fromMap(m as Map<String, dynamic>))
        .toList();

    await _dao.clear();
    for (final habit in habits) {
      await _dao.addHabit(habit);
    }

    final settingsJson = data['settings'] as Map<String, dynamic>?;
    if (settingsJson != null) {
      final prefs = await SharedPreferences.getInstance();
      for (final entry in settingsJson.entries) {
        final value = entry.value;
        if (value is bool) {
          await prefs.setBool(entry.key, value);
        } else if (value is int) {
          await prefs.setInt(entry.key, value);
        } else if (value is double) {
          await prefs.setDouble(entry.key, value);
        } else if (value is String) {
          await prefs.setString(entry.key, value);
        } else if (value is List) {
          await prefs.setStringList(entry.key, value.cast<String>());
        }
      }
    }

    return habits.length;
  }
}
