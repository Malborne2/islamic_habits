import 'package:flutter/material.dart';
import 'package:islamic_habits/components/habit_drawer.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/notification_service.dart';
import 'package:islamic_habits/utility/prayer_helper.dart';
import 'package:islamic_habits/utility/prayer_settings.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:islamic_habits/utility/habit.dart';

class PrayersScreen extends StatefulWidget {
  final List<Habit> habits;
  const PrayersScreen({super.key, required this.habits});
  @override
  _PrayersScreenState createState() => _PrayersScreenState();
}

class _PrayersScreenState extends State<PrayersScreen> {
  DateTime _selectedDate = DateTime.now();

  bool get _isToday {
    final now = DateTime.now();
    return _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
  }

  void _goToPreviousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _goToNextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
  }

  void _goToToday() {
    if (_isToday) return;
    setState(() {
      _selectedDate = DateTime.now();
    });
  }

  Future<void> _cyclePrayerMode(int index) async {
    const order = [
      PrayerNotifyMode.notify,
      PrayerNotifyMode.silent,
      PrayerNotifyMode.adhan,
    ];
    final current = PrayerSettings.prayerModes[index];
    final next = order[(order.indexOf(current) + 1) % order.length];
    setState(() {});
    await PrayerSettings.setPrayerMode(index, next);
    await NotificationService.scheduleTodayReminders();
    if (mounted) setState(() {});
  }

  IconData _iconForMode(PrayerNotifyMode mode) {
    switch (mode) {
      case PrayerNotifyMode.notify:
        return Icons.notifications_active;
      case PrayerNotifyMode.silent:
        return Icons.notifications_off;
      case PrayerNotifyMode.adhan:
        return Icons.mic;
    }
  }

  String _labelForMode(PrayerNotifyMode mode) {
    switch (mode) {
      case PrayerNotifyMode.notify:
        return 'Notify';
      case PrayerNotifyMode.silent:
        return 'Silent';
      case PrayerNotifyMode.adhan:
        return 'Adhan';
    }
  }

  Widget createPrayersTable(PrayerHelper prayerHelper) {
    List<Widget> prayersTimes = prayerHelper.getAllPrayersTime();
    List<Widget> notificationIcons = List.generate(
      5,
      (index) => IconButton(
        icon: Icon(_iconForMode(PrayerSettings.prayerModes[index])),
        tooltip: _labelForMode(PrayerSettings.prayerModes[index]),
        onPressed: () => _cyclePrayerMode(index),
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
    );
    List<Widget> prayersNames = List.generate(
      5,
      (index) => Text(
        kPrayersNames[index],
        style: const TextStyle(fontSize: 16),
      ),
    );

    List<TableRow> prayerRows = List.generate(
        5,
        (i) => TableRow(children: [
              prayersNames[i],
              notificationIcons[i],
              prayersTimes[i],
            ]));
    return Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Table(
          border: const TableBorder(
              horizontalInside: BorderSide(color: Colors.grey, width: 0.5)),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: prayerRows,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final prayerHelper = PrayerHelper.fromSettings(dateTime: _selectedDate);
    final hijriDate = HijriCalendar.fromDate(_selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer times'),
      ),
      drawer: HabitDrawer(
        habits: widget.habits,
      ),
      body: Column(
        children: <Widget>[
          Material(
            elevation: 5,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: _goToPreviousDay,
              ),
              title: InkWell(
                onTap: _goToToday,
                child: ListTile(
                  title: Center(
                      child: Text(hijriDate.toFormat("MMMM dd yyyy"))),
                  subtitle: Center(
                    child: Text(
                      _isToday
                          ? 'Today, ${DateFormat('MMM d yyyy').format(_selectedDate)}'
                          : DateFormat('EEE, MMM d yyyy').format(_selectedDate),
                    ),
                  ),
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: _goToNextDay,
              ),
            ),
          ),
          createPrayersTable(prayerHelper),
        ],
      ),
    );
  }
}
