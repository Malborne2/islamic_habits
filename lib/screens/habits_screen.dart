import 'package:flutter/material.dart';
import 'package:islamic_habits/screens/habit_page.dart';
import 'package:islamic_habits/screens/prayers_screen.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/prayer_helper.dart';
import 'package:adhan_flutter/adhan_flutter.dart';
import 'package:hijri/umm_alqura_calendar.dart';
import 'package:intl/intl.dart';

class HabitsScreen extends StatefulWidget {
  @override
  _HabitsScreenState createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  PageController controller;
  DateTime currentDate =
      DateTime.now().subtract(Duration(days: DateTime.now().day - 1));

  final prayerHelper = PrayerHelper(
      latitude: 25.3157001,
      longitude: 51.8788493,
      calculationMethod: CalculationMethod.QATAR,
      dateTime: DateTime.now());

  final Habit myHabit =
      Habit(name: 'New Habit', color: Colors.redAccent, habitData: {});
  List<HabitPage> habitPages;

  ummAlquraCalendar hijriFirstDay;
  ummAlquraCalendar hijriLastDay;

  @override
  void initState() {
    hijriFirstDay = ummAlquraCalendar.fromDate(currentDate);
    hijriLastDay = ummAlquraCalendar
        .fromDate(currentDate.add(Duration(days: daysOfMonth(currentDate))));
    controller = PageController(
        initialPage: (12 * (currentDate.year - 1971) + currentDate.month) - 1);
    DateTime date = DateTime(1971, 1);
    habitPages = List.generate(
        (12 * (currentDate.year - 1971) + currentDate.month + 1), (i) {
//      print(i % 13);
//      print(date);

      HabitPage myPage = HabitPage(
        habit: myHabit,
        currentDate: date,
      );
      date = date.add(
          Duration(days: daysOfMonth(DateTime(1971 + (i ~/ 12), 1 + i % 12))));

      return myPage;
    }); //from 1971 until today
//    habitPages = [
//      HabitPage(
//        habit: myHabit,
//        currentDate: currentDate.subtract(Duration(
//            days: daysOfMonth(currentDate.subtract(Duration(days: 1))))),
//      ),
//      HabitPage(
//        habit: myHabit,
//        currentDate: currentDate,
//      ),
//      HabitPage(
//        habit: myHabit,
//        currentDate: currentDate.add(Duration(days: daysOfMonth(currentDate))),
//      )
//    ];

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prayer times'),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.all(0),
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Theme.of(context).iconTheme.color,
                  onPressed: Navigator.of(context).pop,
                ),
                title: Text('Islamic Habits'),
              ),
//              margin: EdgeInsets.all(2),
//              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text('Prayers'),
              onTap: () {
                // Update the state of the app.
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PrayersScreen()));
                // ...
              },
            ),
            ListTile(
              title: Text('Al Fajir'),
              onTap: () {
                // Update the state of the app.
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HabitsScreen()));
              },
            ),
          ],
        ),
      ),
      body: Column(children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Material(
            elevation: 5,
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  setState(() {
                    controller.previousPage(
                        duration: Duration(seconds: 1), curve: Curves.ease);
                  });
                },
              ),
              title: ListTile(
                title: Center(
                    child: Text(DateFormat('MMMM yyyy').format(currentDate))),
                subtitle: Center(
                  child: Text(hijriFirstDay.toFormat("MMMM yyyy") ==
                          hijriLastDay.toFormat("MMMM yyyy")
                      ? hijriFirstDay.toFormat("MMMM yyyy")
                      : '${hijriFirstDay.toFormat("MMMM")} - ${hijriLastDay.toFormat("MMMM yyyy")}'),
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  setState(() {
                    controller.nextPage(
                        duration: Duration(seconds: 1), curve: Curves.ease);
                  });
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: Scaffold(
            body: PageView(
              controller: controller,
              children: habitPages,
              onPageChanged: (index) {
//                print('controller: ${controller.page.floor()}');
                setState(() {
//                  print(currentDate.toIso8601String());
                  if (index > controller.page.floor()) {
                    currentDate = currentDate
                        .add(Duration(days: daysOfMonth(currentDate)));

                    print('index: $index');
                    print('Controller: ${controller.page.toInt()}');
                    print('habitPages length: ${habitPages.length}');
                    if (index == habitPages.length - 1) {
//                      print(currentDate.toIso8601String());
                      habitPages.add(HabitPage(
                        habit: myHabit,
                        currentDate: currentDate
                            .add(Duration(days: daysOfMonth(currentDate))),
                      ));
                    }
                  } else {
                    currentDate = currentDate.subtract(Duration(
                        days: daysOfMonth(
                            currentDate.subtract(Duration(days: 1)))));
                  }

//                  print(currentDate.toIso8601String());

                  hijriFirstDay = ummAlquraCalendar.fromDate(currentDate);
                  hijriLastDay = ummAlquraCalendar.fromDate(currentDate
                      .add(Duration(days: daysOfMonth(currentDate))));
                });
//                prevIndex = index;
              },
            ),

//            PageView.builder(
//              controller: controller,
//              itemBuilder: (context, index) {
//                return HabitPage(
//                  currentDate: currentDate,
//                  habit: myHabit,
//                );
//              },
//              onPageChanged: (index) {
////                print('index: $index');
////                print('controller: ${controller.page.floor()}');
//                setState(() {
////                  print(currentDate.toIso8601String());
//                  currentDate = index > controller.page.floor()
//                      ? currentDate
//                          .add(Duration(days: daysOfMonth(currentDate)))
//                      : currentDate.subtract(Duration(
//                          days: daysOfMonth(
//                              currentDate.subtract(Duration(days: 1)))));
////                  print(currentDate.toIso8601String());
//
//                  hijriFirstDay = ummAlquraCalendar.fromDate(currentDate);
//                  hijriLastDay = ummAlquraCalendar.fromDate(currentDate
//                      .add(Duration(days: daysOfMonth(currentDate))));
//                });
////                prevIndex = index;
//              },
//            ),
          ),
        ),
      ]),
    );
  }
}
