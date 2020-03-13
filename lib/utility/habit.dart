import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islamic_habits/components/round_button.dart';

class Habit {
  String name;
  String description;
  Color color;
  HabitType type;
  DateTime createdTime = DateTime.now();
  Map<String, Map<DateTime, double>> habitData;
  Criteria criteria;
  double successValue; //The success of a habit
  int successTarget; //Number of days until the habit is achieved
  int startOfWeek = DateTime.friday;
  HabitDays habitDays;
  List<int> habitPeriod;

  Habit({
    @required this.name,
    @required this.color,
    this.habitPeriod,
    this.successTarget = 40,
    this.successValue = 1,
    this.type = HabitType.YES_NO,
    this.habitDays = HabitDays.EVERYDAY,
    this.criteria,
    this.description = '',
    this.createdTime,
    this.habitData,
  });

  Status getStatus(DateTime day) {
    if (!habitData.containsKey(DateFormat('yyyy-MM-DD').format(day)))
      return Status.NO_DATA;
    else {
      if (habitData[DateFormat('yyyy-MM-DD').format(day)].values.first ==
          successValue)
        return Status.SUCCESS;
      else
        return Status.FAIL;
    }
  }

  double getHabitDataValue(DateTime day) {
    if (!habitData.containsKey(DateFormat('yyyy-MM-DD').format(day)))
      return null;
    else {
      return habitData[DateFormat('yyyy-MM-DD').format(day)].values.first;
    }
  }

  void setHabitDataValue(DateTime day, double value) {
    if (value == null) {
      habitData.remove(DateFormat('yyyy-MM-DD').format(day));
    } else if (habitData.containsKey(day)) {
      habitData[DateFormat('yyyy-MM-DD').format(day)][
          habitData[DateFormat('yyyy-MM-DD').format(day)]
              .keys
              .toList()
              .first] = value;
    } else
      habitData.addAll({
        DateFormat('yyyy-MM-DD').format(day): {DateTime.now(): value}
      });

    print('$day: $value');
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
