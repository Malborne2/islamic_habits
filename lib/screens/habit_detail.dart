import 'package:flutter/material.dart';
import 'package:islamic_habits/screens/habit_page.dart';
import 'package:islamic_habits/screens/prayers_screen.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/prayer_helper.dart';
import 'package:adhan_flutter/adhan_flutter.dart';
import 'package:hijri/umm_alqura_calendar.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HabitDetail extends StatefulWidget {
  @override
  _HabitDetailState createState() => _HabitDetailState();
}

class _HabitDetailState extends State<HabitDetail> {
  PageController controller;
  DateTime currentDate =
      DateTime.now().subtract(Duration(days: DateTime.now().day - 1));

  final prayerHelper = PrayerHelper(
      latitude: 25.3157001,
      longitude: 51.8788493,
      calculationMethod: CalculationMethod.QATAR,
      dateTime: DateTime.now());

  final Habit myHabit = Habit(
      name: 'Al Fajir Prayer',
      color: Colors.redAccent,
      habitData: {},
      successValue: 20,
      criteria: Criteria.AT_LEAST,
      type: HabitType.NUMBER);
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
        title: Text(myHabit.name),
        backgroundColor: myHabit.color,
        actions: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '1',
                style: Theme.of(context).textTheme.title,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 30),
                child: Text(
                  '15%',
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ],
          ),
        ],
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
                    MaterialPageRoute(builder: (context) => HabitDetail()));
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
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
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Center(
                        child: Text(
                      DateFormat('MMMM yyyy').format(currentDate),
                      style: TextStyle(fontSize: 20),
                    )),
                  ),
                  subtitle: Center(
                    child: AutoSizeText(
                      hijriFirstDay.toFormat("MMMM yyyy") ==
                              hijriLastDay.toFormat("MMMM yyyy")
                          ? hijriFirstDay.toFormat("MMMM yyyy")
                          : '${hijriFirstDay.toFormat("MMMM")} - ${hijriLastDay.toFormat("MMMM yyyy")}',
                      style: TextStyle(fontSize: 18.0),
                      maxLines: 1,
                    ),
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
          SizedBox(
            height: 6 * (MediaQuery.of(context).size.width / 9) +
                60, //Calculation for the total height of the buttons list
            child: PageView(
              controller: controller,
              children: habitPages,
              onPageChanged: (index) {
//                print('controller: ${controller.page.floor()}');
                setState(() {
//                  print(currentDate.toIso8601String());
                  if (index > controller.page.floor()) {
                    currentDate = currentDate
                        .add(Duration(days: daysOfMonth(currentDate)));

//                    print('index: $index');
//                    print('Controller: ${controller.page.toInt()}');
//                    print('habitPages length: ${habitPages.length}');
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
          ),
          Material(
            elevation: 0,
            color: myHabit.color.withAlpha(50),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: myHabit.color.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              child: ListTile(
                title: Text('Hello'),
              ),
            ),
          ),
          Material(
            elevation: 0,
            color: myHabit.color.withAlpha(50),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: myHabit.color.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              child: ListTile(
                title: Text('Hello'),
              ),
            ),
          ),
          Material(
            elevation: 0,
            color: myHabit.color.withAlpha(50),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: myHabit.color.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              child: ListTile(
                title: Text('Hello'),
              ),
            ),
          ),
          Material(
            elevation: 0,
            color: myHabit.color.withAlpha(50),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: myHabit.color.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              child: ListTile(
                title: Text('Hello'),
              ),
            ),
          ),
          Material(
            elevation: 0,
            color: myHabit.color.withAlpha(50),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: myHabit.color.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              child: ListTile(
                title: Text('Hello'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
