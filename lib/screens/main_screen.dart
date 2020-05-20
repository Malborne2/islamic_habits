import 'package:adhan_flutter/adhan_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islamic_habits/components/habit_drawer.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/prayer_helper.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:hijri/umm_alqura_calendar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:islamic_habits/utility/data_access_object.dart';

class MainScreen extends StatefulWidget {
  List<Habit> islamicHabits;
  MainScreen({this.islamicHabits});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ummAlquraCalendar hijriToday;
  DateTime today = DateTime.now();
  // Address: Doha, Qatar
  final prayerHelper = PrayerHelper(
      latitude: 25.3157001,
      longitude: 51.8788493,
      calculationMethod: CalculationMethod.QATAR,
      dateTime: DateTime.now());

  @override
  void initState() {
    super.initState();
    hijriToday = ummAlquraCalendar.fromDate(today);
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
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Column(
            children: <Widget>[
              Card(
                margin: EdgeInsets.all(0),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 15,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
//                        mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Center(
                                  child: AutoSizeText(
                                    hijriToday.toFormat("DDDD, d MMMM yyyy"),
                                    maxLines: 1,
                                    style: TextStyle(
//                                      fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Center(
                                child: AutoSizeText(
                                  DateFormat('MMMM d yyyy').format(today),
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: VerticalDivider(
                            thickness: 1,
//                          color: Colors.white,
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
                              FutureBuilder(
                                future: prayerHelper.getNextPrayerName(),
                                builder:
                                    (context, AsyncSnapshot<String> snapshot) {
                                  if (snapshot.hasData) {
                                    final prayerName = snapshot.data;
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AutoSizeText(
                                        prayerName,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text(snapshot.error.toString());
                                  } else {
                                    return Text('...');
                                  }
                                },
                              ),
                              FutureBuilder(
                                future: prayerHelper.getNextPrayerTime(),
                                builder: (context,
                                    AsyncSnapshot<DateTime> snapshot) {
                                  if (snapshot.hasData) {
                                    final dateTime = snapshot.data.toLocal();
                                    return AutoSizeText(
                                      DateFormat.jm().format(dateTime),
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text(snapshot.error.toString());
                                  } else {
                                    return Text('Waiting...');
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: VerticalDivider(
                            thickness: 1,
//                          color: Colors.white,
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
                              FutureBuilder(
                                future: prayerHelper.getLaterPrayerName(),
                                builder:
                                    (context, AsyncSnapshot<String> snapshot) {
                                  if (snapshot.hasData) {
                                    final prayerName = snapshot.data;
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AutoSizeText(
                                        prayerName,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text(snapshot.error.toString());
                                  } else {
                                    return Text('...');
                                  }
                                },
                              ),
                              FutureBuilder(
                                future: prayerHelper.getLaterPrayerTime(),
                                builder: (context,
                                    AsyncSnapshot<DateTime> snapshot) {
                                  if (snapshot.hasData) {
                                    final dateTime = snapshot.data.toLocal();
                                    return AutoSizeText(
                                      DateFormat.jm().format(dateTime),
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text(snapshot.error.toString());
                                  } else {
                                    return Text('...');
                                  }
                                },
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
