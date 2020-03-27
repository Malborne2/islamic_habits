import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:islamic_habits/components/habit_drawer.dart';
import 'package:islamic_habits/components/habit_page.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/functions.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/prayer_helper.dart';
import 'package:adhan_flutter/adhan_flutter.dart';
import 'package:hijri/umm_alqura_calendar.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HabitDetail extends StatefulWidget {
  final Habit habit;
  final List<Habit> habits;
  HabitDetail({@required this.habit, @required this.habits});
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

//  final Habit myHabit = Habit(
//      name: 'Al Fajir Prayer',
//      color: Colors.redAccent,
//      habitData: {},
//      successValue: 20,
//      criteria: Criteria.AT_LEAST,
//      type: HabitType.NUMBER);
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
        habit: widget.habit,
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
    widget.habit.getCurrentStreak();
    List<Widget> metrics = List.generate(
        kMetricNames.length,
        (i) => Padding(
              padding: const EdgeInsets.all(5),
              child: Text(kMetricNames[i]),
            ));
    List<Widget> values = List.generate(
        metrics.length,
        (i) => Padding(
              padding: const EdgeInsets.all(5),
              child: Text((i + 1).toString()),
            ));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit.name),
        backgroundColor: widget.habit.color,
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
      drawer: HabitDrawer(
        habits: widget.habits,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10),
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
            height: 8 * (MediaQuery.of(context).size.width / 9) +
                20, //Calculation for the total height of the buttons list
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
                        habit: widget.habit,
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: Material(
              elevation: 0,
              color: widget.habit.color.withAlpha(50),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1, color: widget.habit.color.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: metrics),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: values)
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
