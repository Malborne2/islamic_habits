import 'package:flutter/material.dart';

List<String> kPrayersNames = [
  'Al Fajir',
  'Al DHuhr',
  'Al Asr',
  'Al Magrib',
  'Al Isha',
];

List<String> kDays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
List<String> kMetricNames = [
  'Current Streak',
  'Streak Target',
  'Maximum Streak',
  'Sucess Percentage',
  'Weekly Average',
  'Monthly Average'
];

int kStartOfWeek = DateTime.friday;

const kHabitColors = [
//  Colors.red,
  Color(0xFFEB5757),
  Color(0xFFF2994A),
  Color(0xFF2D9CDB),
  Color(0xFFB94680),
  Color(0xFF651E3E),
  Color(0xFF27AE60),
  Color(0xFF854085),
  Color(0xFFFF8566),
  Color(0xFF36C9A2),
];

const kTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.deepPurple, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  ),
);
