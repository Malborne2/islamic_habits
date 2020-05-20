import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islamic_habits/components/habit_button.dart';
import 'package:islamic_habits/utility/data_access_object.dart';

class Habit {
  int id;
  String name;
  String description;
  Color color;
  HabitType type;
  DateTime createdTime = DateTime.now();
  Map<String, Map<String, double>> habitData;
  Criteria criteria;
  double successValue; //The success of a habit
  int successTarget; //Number of days until the habit is achieved
  static int startOfWeek = DateTime.friday;
  HabitDays habitDays; //Everyday, some days of the week or repeating
  List<int> habitPeriod; //The list of days in the week the habit is active

  Habit({
    @required this.name,
    @required this.color,
    this.habitPeriod,
    this.successTarget = 40,
    @required this.successValue,
    this.type = HabitType.YES_NO,
    this.habitDays = HabitDays.EVERYDAY,
    @required this.criteria,
    this.description = '',
    this.createdTime,
//    this.startOfWeek = DateTime.friday,
    this.habitData,
  });

  Map<String, dynamic> toMap() {
    if (habitData == null) habitData = {};
    return {
      'name': name,
      'description': description,
      'color': color.value,
      'type': type.toString(),
      'createdTime': createdTime?.millisecondsSinceEpoch ??
          DateTime.now().millisecondsSinceEpoch,
      'dataKeys': habitData.keys.toList(),
      'habitTimeStamp': habitData.values.map((f) => f.keys.first).toList(),
      'habitData': habitData.values.map((f) => f.values.first).toList(),
      'criteria': criteria.toString(),
      'successValue': successValue,
      'successTarget': successTarget,
      'startOfWeek': startOfWeek,
      'habitDays': habitDays.toString(),
      'habitPeriod': habitPeriod,
    };
  }

  static Habit fromMap(Map<String, dynamic> map) {
    Map<String, Map<String, double>> habitData = {};
    if (map['dataKeys'] != null && map['habitData'].length > 0) {
      for (int i = 0; i < map['dataKeys'].length; i++) {
        habitData.addAll({
          map['dataKeys'][i]: {map['habitTimeStamp'][i]: map['habitData'][i]}
        });
      }
    }
    startOfWeek = map['startOfWeek'];

    return Habit(
      name: map['name'],
      description: map['description'],
      color: Color(map['color']),
      type: HabitType.values.firstWhere((e) => e.toString() == map['type']),
      createdTime: DateTime.fromMillisecondsSinceEpoch(map['createdTime']),
      habitData: habitData,
      criteria:
          Criteria.values.firstWhere((e) => e.toString() == map['criteria']),
      successValue: map['successValue'],
      successTarget: map['successTarget'],
      habitDays:
          HabitDays.values.firstWhere((e) => e.toString() == map['habitDays']),
      habitPeriod: map['habitPeriod'],
    );
  }

  Status getStatus(DateTime day) {
    if (habitData == null ||
        !habitData.containsKey(DateFormat('yyyy-MM-dd').format(day)))
      return Status.NO_DATA;
    else {
      if (type == HabitType.YES_NO) {
        if (habitData[DateFormat('yyyy-MM-dd').format(day)].values.first == 1)
          return Status.SUCCESS;
        else
          return Status.FAIL;
      } else if (criteria == Criteria.EXACTLY &&
              habitData[DateFormat('yyyy-MM-dd').format(day)].values.first ==
                  successValue ||
          criteria == Criteria.AT_LEAST &&
              habitData[DateFormat('yyyy-MM-dd').format(day)].values.first >=
                  successValue ||
          criteria == Criteria.NOT_MORE_THAN &&
              habitData[DateFormat('yyyy-MM-dd').format(day)].values.first <=
                  successValue)
        return Status.SUCCESS;
      else
        return Status.FAIL;
    }
  }

  double getHabitDataValue(DateTime day) {
    if (habitData == null ||
        !habitData.containsKey(DateFormat('yyyy-MM-dd').format(day)))
      return null;
    else {
      return habitData[DateFormat('yyyy-MM-dd').format(day)].values.first;
    }
  }

  bool hasData(DateTime day) {
    if (habitData == null ||
        !habitData.containsKey(DateFormat('yyyy-MM-dd').format(day)))
      return false;
    else {
      return true;
    }
  }

  double getSuccessPercentage(DateTime day) {
    if (habitData == null ||
        !habitData.containsKey(DateFormat('yyyy-MM-dd').format(day)) ||
        type == HabitType.YES_NO)
      return null;
    else {
      return 100 *
          habitData[DateFormat('yyyy-MM-dd').format(day)].values.first /
          successValue;
    }
  }

  int getCurrentStreak() {
    if (habitData == null || habitData.isEmpty) return 0;

    return 0;
  }

  void setHabitDataValue(DateTime day, double value) {
    if (habitData == null) habitData = {};
    if (value == null) {
      habitData.remove(DateFormat('yyyy-MM-dd').format(day));
    } else if (habitData != null &&
        habitData.containsKey(DateFormat('yyyy-MM-dd').format(day))) {
      habitData[DateFormat('yyyy-MM-dd').format(day)][
          habitData[DateFormat('yyyy-MM-dd').format(day)]
              .keys
              .toList()
              .first] = value;
    } else
      habitData.addAll({
        DateFormat('yyyy-MM-dd').format(day): {
          DateTime.now().millisecondsSinceEpoch.toString(): value
        } //set to now because this is the value added date as opposed to the registered date string used for the first map
      });

    HabitDao().updateHabit(this); // Update the data in the local database
  }

  bool isHabitDay(DateTime today) {
    switch (habitDays) {
      case HabitDays.EVERYDAY:
        return true;

      case HabitDays.DAYS_OF_WEEK:
        if (habitPeriod.contains(today.weekday)) return true;
        return false;

      case HabitDays.REPEATING:
        if (today.difference(createdTime).inDays % habitPeriod.first == 0)
          return true;
        return false;

      default:
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
}
