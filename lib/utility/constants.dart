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
