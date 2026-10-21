import 'package:flutter/material.dart';
import 'package:islamic_habits/components/habit_drawer.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/prayer_helper.dart';
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
  final prayerHelper = PrayerHelper.fromSettings();
  final HijriCalendar _today = HijriCalendar.now();

  Widget createPrayersTable() {
    List<Widget> prayersTimes = prayerHelper.getAllPrayersTime();
    List<Widget> notificationIcons = List.generate(
      5,
      (index) => IconButton(
        icon: const Icon(Icons.notifications_active),
        onPressed: () {},
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
                onPressed: () {},
              ),
              title: ListTile(
                title: Center(child: Text(_today.toFormat("MMMM dd yyyy"))),
                subtitle: Center(
                    child: Text(
                        DateFormat('EEE, MMM d yyyy').format(DateTime.now()))),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {},
              ),
            ),
          ),
          createPrayersTable(),
        ],
      ),
    );
  }
}
