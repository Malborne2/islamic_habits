int daysOfMonth(DateTime month) {
  //returns the number of days in a given month
  var beginningNextMonth = (month.month < 12)
      ? new DateTime(month.year, month.month + 1, 1)
      : new DateTime(month.year + 1, 1, 1);
  return beginningNextMonth.subtract(new Duration(days: 1)).day;
}

DateTime weekdayDate(int weekday) {
  DateTime date = DateTime.now();
  int diff = (date.weekday - weekday);
  diff = diff < 0 ? diff += 7 : diff;
  print(date.subtract(Duration(days: diff)));
  return date.subtract(Duration(days: diff));
}

bool isToday(DateTime date) {
  DateTime now = DateTime.now();
  if (date.year == now.year && date.month == now.month && date.day == now.day)
    return true;
  return false;
}

bool isTodayOrBefore(DateTime date) {
  DateTime now = DateTime.now();
  if (date.isBefore(now) || isToday(date)) return true;
  return false;
}
