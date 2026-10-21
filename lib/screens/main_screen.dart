import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islamic_habits/components/habit_drawer.dart';
import 'package:islamic_habits/utility/prayer_helper.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MainScreen extends StatefulWidget {
  final List<Habit> islamicHabits;
  const MainScreen({super.key, required this.islamicHabits});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late HijriCalendar hijriToday;
  DateTime today = DateTime.now();
  final prayerHelper = PrayerHelper.fromSettings();

  @override
  void initState() {
    super.initState();
    hijriToday = HijriCalendar.fromDate(today);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Islamic Habits'),
      ),
      drawer: HabitDrawer(
        habits: widget.islamicHabits,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Column(
            children: <Widget>[
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Center(
                                  child: AutoSizeText(
                                    hijriToday.toFormat("DDDD, d MMMM yyyy"),
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Center(
                                child: AutoSizeText(
                                  DateFormat('MMMM d yyyy').format(today),
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                        child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: VerticalDivider(
                            thickness: 1,
                            width: 2,
                            indent: 2,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AutoSizeText(
                                  prayerHelper.getNextPrayerName(),
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              AutoSizeText(
                                DateFormat.jm().format(
                                    prayerHelper.getNextPrayerTime()),
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                        child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: VerticalDivider(
                            thickness: 1,
                            width: 2,
                            indent: 2,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AutoSizeText(
                                  prayerHelper.getLaterPrayerName(),
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              AutoSizeText(
                                DateFormat.jm().format(
                                    prayerHelper.getLaterPrayerTime()),
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
