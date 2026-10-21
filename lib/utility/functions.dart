// DateTime(year, month, 0) normalizes to the last day of the *previous*
// month via plain calendar-component arithmetic (and month 13 rolls over
// into January of the next year automatically), so this is immune to the
// Duration/DST pitfall addDays above guards against — the previous version
// used Duration(days: 1) subtraction here, which silently returned the
// wrong day count for any March whose 31st fell on the spring-forward
// DST Sunday, compounding into a multi-day drift in habit_detail.dart's
// page-date accumulation.
int daysOfMonth(DateTime month) {
  return DateTime(month.year, month.month + 1, 0).day;
}

// A calendar-day-safe version of date.add(Duration(days: n)). Duration
// addition is a fixed-length jump (n * 24h), which skips or repeats a
// calendar day across a DST transition; rebuilding the DateTime from its
// y/m/d components instead lets Dart's own normalization handle the
// month/year rollover correctly regardless of DST.
DateTime addDays(DateTime date, int days) {
  return DateTime(date.year, date.month, date.day + days, date.hour,
      date.minute, date.second, date.millisecond, date.microsecond);
}

DateTime weekdayDate(int weekday) {
  DateTime date = DateTime.now();
  int diff = (date.weekday - weekday);
  diff = diff < 0 ? diff += 7 : diff;
  return addDays(date, -diff);
}

bool isToday(DateTime date) {
  DateTime now = DateTime.now();
  return date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
}

bool isTodayOrBefore(DateTime date) {
  DateTime now = DateTime.now();
  return date.isBefore(now) || isToday(date);
}
