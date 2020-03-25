import 'package:flutter/material.dart';

List<String> kPrayersNames = [
  'Al-Fajir',
  'Al-DHuhr',
  'Al-Asr',
  'Al-Magrib',
  'Al-Isha',
];

int daysOfMonth(DateTime month) {
  var beginningNextMonth = (month.month < 12)
      ? new DateTime(month.year, month.month + 1, 1)
      : new DateTime(month.year + 1, 1, 1);
  return beginningNextMonth.subtract(new Duration(days: 1)).day;
}

List<String> kDays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

int kStartOfWeek = 5;

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
