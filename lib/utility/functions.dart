int daysOfMonth(DateTime month) {
  var beginningNextMonth = (month.month < 12)
      ? new DateTime(month.year, month.month + 1, 1)
      : new DateTime(month.year + 1, 1, 1);
  return beginningNextMonth.subtract(new Duration(days: 1)).day;
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
