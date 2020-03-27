import 'package:adhan_flutter/adhan_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islamic_habits/components/habit_drawer.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/prayer_helper.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/constants.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Address: Doha, Qatar
  final prayerHelper = PrayerHelper(
      latitude: 25.3157001,
      longitude: 51.8788493,
      calculationMethod: CalculationMethod.QATAR,
      dateTime: DateTime.now());

  final List<Habit> islamicHabits = List.generate(
      6,
      (i) => Habit(
          name: i < kPrayersNames.length
              ? '${kPrayersNames[i]} Prayer'
              : 'Reciting the Quran',
          color: kHabitColors[i % kHabitColors.length],
          habitData: {},
          successValue: i < kPrayersNames.length ? 1 : 20,
          criteria: Criteria.AT_LEAST,
          type:
              i < kPrayersNames.length ? HabitType.YES_NO : HabitType.NUMBER));

//  [
//    Habit(
//        name: 'Al Fajir Prayer',
//        color: Colors.redAccent,
//        habitData: {},
//        successValue: 1,
//        criteria: Criteria.AT_LEAST,
//        type: HabitType.YES_NO),
//    Habit(
//        name: 'Al Dhuhr Prayer',
//        color: Colors.redAccent,
//        habitData: {},
//        successValue: 1,
//        criteria: Criteria.AT_LEAST,
//        type: HabitType.YES_NO),
//    Habit(
//        name: 'Al Asr Prayer',
//        color: Colors.redAccent,
//        habitData: {},
//        successValue: 1,
//        criteria: Criteria.AT_LEAST,
//        type: HabitType.YES_NO),
//    Habit(
//        name: 'Al Magrib Prayer',
//        color: Colors.redAccent,
//        habitData: {},
//        successValue: 1,
//        criteria: Criteria.AT_LEAST,
//        type: HabitType.YES_NO),
//    Habit(
//        name: 'Al Ishaa Prayer',
//        color: Colors.redAccent,
//        habitData: {},
//        successValue: 1,
//        criteria: Criteria.AT_LEAST,
//        type: HabitType.YES_NO),
//    Habit(
//        name: 'Reciting the Quran',
//        color: Colors.redAccent,
//        habitData: {},
//        successValue: 20,
//        criteria: Criteria.AT_LEAST,
//        type: HabitType.NUMBER),
//  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Islamic Habits'),
      ),
      drawer: HabitDrawer(
        habits: islamicHabits,
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Column(
            children: <Widget>[
              Card(
                margin: EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          FutureBuilder(
                            future: prayerHelper.getNextPrayerName(),
                            builder: (context, AsyncSnapshot<String> snapshot) {
                              if (snapshot.hasData) {
                                final prayerName = snapshot.data;
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    prayerName,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text(snapshot.error.toString());
                              } else {
                                return Text('Waiting...');
                              }
                            },
                          ),
                          FutureBuilder(
                            future: prayerHelper.getNextPrayerTime(),
                            builder:
                                (context, AsyncSnapshot<DateTime> snapshot) {
                              if (snapshot.hasData) {
                                final dateTime = snapshot.data.toLocal();
                                return Text(
                                  DateFormat.jm().format(dateTime),
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
                      VerticalDivider(
                        thickness: 5,
                        color: Colors.grey,
                        width: 2,
                        indent: 2,
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
