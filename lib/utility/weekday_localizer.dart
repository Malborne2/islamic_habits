import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

// January 1 2024 was a Monday, so DateTime(2024, 1, weekday) lands on the
// matching ISO weekday (1=Monday .. 7=Sunday).
String localizedWeekdayShort(BuildContext context, int weekday) {
  final locale = Localizations.localeOf(context).toString();
  return DateFormat('EEE', locale).format(DateTime(2024, 1, weekday));
}

// The column headers walk 7 days starting at kStartOfWeek (a weekday int,
// 1=Monday..7=Sunday); this returns which weekday lands in column [i].
int weekdayForColumn(int startOfWeek, int i) {
  return ((startOfWeek - 1 + i) % 7) + 1;
}
