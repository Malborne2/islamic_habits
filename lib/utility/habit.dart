import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islamic_habits/components/habit_button.dart';
import 'package:islamic_habits/utility/data_access_object.dart';
import 'package:islamic_habits/utility/functions.dart';

class Habit {
  int? id;
  String name;
  String description;
  Color color;
  HabitType type;
  DateTime createdTime;
  Map<String, Map<String, double>> habitData;
  Criteria criteria;
  double successValue;
  int successTarget;
  static int startOfWeek = DateTime.friday;
  HabitDays habitDays;
  List<int>? habitPeriod;
  String numberUnit;

  Habit({
    required this.name,
    required this.color,
    this.habitPeriod,
    this.successTarget = 40,
    required this.successValue,
    this.type = HabitType.YES_NO,
    this.habitDays = HabitDays.EVERYDAY,
    required this.criteria,
    this.description = '',
    this.numberUnit = 'pages',
    DateTime? createdTime,
    Map<String, Map<String, double>>? habitData,
  })  : createdTime = createdTime ?? DateTime.now(),
        habitData = habitData ?? {};

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'color': color.toARGB32(),
      'type': type.toString(),
      'createdTime': createdTime.millisecondsSinceEpoch,
      'dataKeys': habitData.keys.toList(),
      'habitTimeStamp': habitData.values.map((f) => f.keys.first).toList(),
      'habitData': habitData.values.map((f) => f.values.first).toList(),
      'criteria': criteria.toString(),
      'successValue': successValue,
      'successTarget': successTarget,
      'startOfWeek': startOfWeek,
      'habitDays': habitDays.toString(),
      'habitPeriod': habitPeriod,
      'numberUnit': numberUnit,
    };
  }

  static Habit fromMap(Map<String, dynamic> map) {
    Map<String, Map<String, double>> habitData = {};
    if (map['dataKeys'] != null && (map['habitData'] as List).isNotEmpty) {
      final keys = map['dataKeys'] as List;
      final timestamps = map['habitTimeStamp'] as List;
      final values = map['habitData'] as List;
      for (int i = 0; i < keys.length; i++) {
        habitData[keys[i] as String] = {
          timestamps[i] as String: (values[i] as num).toDouble()
        };
      }
    }
    startOfWeek = map['startOfWeek'] as int;

    return Habit(
      name: map['name'] as String,
      description: map['description'] as String,
      color: Color(map['color'] as int),
      type: HabitType.values.firstWhere((e) => e.toString() == map['type']),
      createdTime: DateTime.fromMillisecondsSinceEpoch(map['createdTime'] as int),
      habitData: habitData,
      criteria: Criteria.values.firstWhere((e) => e.toString() == map['criteria']),
      successValue: (map['successValue'] as num).toDouble(),
      successTarget: map['successTarget'] as int,
      habitDays: HabitDays.values.firstWhere((e) => e.toString() == map['habitDays']),
      habitPeriod: (map['habitPeriod'] as List?)?.cast<int>(),
      numberUnit: map['numberUnit'] as String? ?? 'pages',
    );
  }

  Status getStatus(DateTime day) {
    if (!habitData.containsKey(DateFormat('yyyy-MM-dd').format(day))) {
      return Status.NO_DATA;
    } else {
      if (type == HabitType.YES_NO) {
        if (habitData[DateFormat('yyyy-MM-dd').format(day)]!.values.first == 1)
          return Status.SUCCESS;
        else
          return Status.FAIL;
      } else if (criteria == Criteria.EXACTLY &&
              habitData[DateFormat('yyyy-MM-dd').format(day)]!.values.first ==
                  successValue ||
          criteria == Criteria.AT_LEAST &&
              habitData[DateFormat('yyyy-MM-dd').format(day)]!.values.first >=
                  successValue ||
          criteria == Criteria.NOT_MORE_THAN &&
              habitData[DateFormat('yyyy-MM-dd').format(day)]!.values.first <=
                  successValue)
        return Status.SUCCESS;
      else
        return Status.FAIL;
    }
  }

  double? getHabitDataValue(DateTime day) {
    if (!habitData.containsKey(DateFormat('yyyy-MM-dd').format(day)))
      return null;
    else
      return habitData[DateFormat('yyyy-MM-dd').format(day)]!.values.first;
  }

  bool hasData(DateTime day) {
    return habitData.containsKey(DateFormat('yyyy-MM-dd').format(day));
  }

  double? getSuccessPercentage(DateTime day) {
    if (!habitData.containsKey(DateFormat('yyyy-MM-dd').format(day)) ||
        type == HabitType.YES_NO)
      return null;
    else
      return 100 *
          habitData[DateFormat('yyyy-MM-dd').format(day)]!.values.first /
          successValue;
  }

  DateTime _dateOnly(DateTime day) => DateTime(day.year, day.month, day.day);

  // Whether [day] counts as "not yet decided" because it is today's habit
  // day and no data has been logged for it yet.
  bool _isPendingToday(DateTime day) =>
      isToday(day) && getStatus(day) == Status.NO_DATA;

  // The earliest day stats should consider: normally the habit's creation
  // date, but if data was backfilled for an earlier day (e.g. right after
  // creating the habit), that day should still count toward the stats.
  DateTime _earliestTrackedDay() {
    DateTime earliest = _dateOnly(createdTime);
    for (final key in habitData.keys) {
      final date = DateFormat('yyyy-MM-dd').parse(key);
      if (date.isBefore(earliest)) earliest = date;
    }
    return earliest;
  }

  int getCurrentStreak() {
    int streak = 0;
    DateTime day = _dateOnly(DateTime.now());
    final earliestDay = _earliestTrackedDay();
    while (!day.isBefore(earliestDay)) {
      if (!isHabitDay(day)) {
        day = day.subtract(const Duration(days: 1));
        continue;
      }
      if (getStatus(day) == Status.SUCCESS) {
        streak++;
      } else if (!_isPendingToday(day)) {
        break;
      }
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }

  int getMaximumStreak() {
    int maxStreak = 0;
    int current = 0;
    DateTime day = _earliestTrackedDay();
    final today = _dateOnly(DateTime.now());
    while (!day.isAfter(today)) {
      if (isHabitDay(day)) {
        if (getStatus(day) == Status.SUCCESS) {
          current++;
          if (current > maxStreak) maxStreak = current;
        } else if (!_isPendingToday(day)) {
          current = 0;
        }
      }
      day = day.add(const Duration(days: 1));
    }
    return maxStreak;
  }

  // Percentage of habit days, since the habit was created, that were
  // completed successfully. Today is excluded while it has no data yet.
  double getOverallSuccessRate() {
    int total = 0;
    int success = 0;
    DateTime day = _earliestTrackedDay();
    final today = _dateOnly(DateTime.now());
    while (!day.isAfter(today)) {
      if (isHabitDay(day) && !_isPendingToday(day)) {
        total++;
        if (getStatus(day) == Status.SUCCESS) success++;
      }
      day = day.add(const Duration(days: 1));
    }
    return total == 0 ? 0 : 100 * success / total;
  }

  // For NUMBER habits this is the average recorded value over the last
  // [days] days; for YES_NO habits it is the success rate over the same
  // period, both restricted to days on/after the habit's creation.
  double getAverageOverPeriod(int days) {
    final today = _dateOnly(DateTime.now());
    DateTime start = today.subtract(Duration(days: days - 1));
    final earliestDay = _earliestTrackedDay();
    if (start.isBefore(earliestDay)) start = earliestDay;

    if (type == HabitType.NUMBER) {
      double sum = 0;
      int count = 0;
      DateTime day = start;
      while (!day.isAfter(today)) {
        if (isHabitDay(day)) {
          final value = getHabitDataValue(day);
          if (value != null) {
            sum += value;
            count++;
          }
        }
        day = day.add(const Duration(days: 1));
      }
      return count == 0 ? 0 : sum / count;
    } else {
      int total = 0;
      int success = 0;
      DateTime day = start;
      while (!day.isAfter(today)) {
        if (isHabitDay(day) && !_isPendingToday(day)) {
          total++;
          if (getStatus(day) == Status.SUCCESS) success++;
        }
        day = day.add(const Duration(days: 1));
      }
      return total == 0 ? 0 : 100 * success / total;
    }
  }

  void setHabitDataValue(DateTime day, double? value) {
    final key = DateFormat('yyyy-MM-dd').format(day);
    if (value == null) {
      habitData.remove(key);
    } else if (habitData.containsKey(key)) {
      habitData[key]![habitData[key]!.keys.first] = value;
    } else {
      habitData[key] = {
        DateTime.now().millisecondsSinceEpoch.toString(): value
      };
    }
    HabitDao().updateHabit(this);
  }

  bool isHabitDay(DateTime today) {
    switch (habitDays) {
      case HabitDays.EVERYDAY:
        return true;

      case HabitDays.DAYS_OF_WEEK:
        if (habitPeriod != null && habitPeriod!.contains(today.weekday))
          return true;
        return false;

      case HabitDays.REPEATING:
        if (habitPeriod != null &&
            today.difference(createdTime).inDays % habitPeriod!.first == 0)
          return true;
        return false;

      // Any day may be logged; success is a weekly count rather than a
      // fixed calendar day, so every day counts as a habit day here.
      case HabitDays.TIMES_PER_WEEK:
        return true;
    }
  }
}

enum HabitType {
  YES_NO,
  NUMBER,
}

enum Criteria {
  AT_LEAST,
  EXACTLY,
  NOT_MORE_THAN,
}

enum HabitDays {
  EVERYDAY,
  DAYS_OF_WEEK,
  REPEATING,
  TIMES_PER_WEEK,
}
