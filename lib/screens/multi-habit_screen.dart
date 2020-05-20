import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:islamic_habits/components/habit_drawer.dart';
import 'package:islamic_habits/components/several_habits_page.dart';
import 'package:islamic_habits/utility/functions.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/prayer_helper.dart';
import 'package:adhan_flutter/adhan_flutter.dart';
import 'package:hijri/umm_alqura_calendar.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

class SeveralHabitsScreen extends StatefulWidget {
  final List<Habit> habits;
  SeveralHabitsScreen({@required this.habits});
  @override
  _SeveralHabitsScreenState createState() => _SeveralHabitsScreenState();
}

class _SeveralHabitsScreenState extends State<SeveralHabitsScreen> {
  PageController controller;
  DateTime currentDate = weekdayDate(Habit.startOfWeek);
  DateTime _lowerDate;
  DateTime _upperDate;
  final prayerHelper = PrayerHelper(
      latitude: 25.3157001,
      longitude: 51.8788493,
      calculationMethod: CalculationMethod.QATAR,
      dateTime: DateTime.now());

  List<DateTime> startingDates;

  ummAlquraCalendar hijriFirstDay;
  ummAlquraCalendar hijriLastDay;

  Widget _buildPages(DateTime dateTime) {
    return SeveralHabitsPage(habits: widget.habits, currentDate: dateTime);
  }

  @override
  void initState() {
    hijriFirstDay = ummAlquraCalendar.fromDate(currentDate);
    hijriLastDay =
        ummAlquraCalendar.fromDate(currentDate.add(Duration(days: 7)));
    controller = PageController(initialPage: 1);
    _lowerDate = currentDate.subtract(Duration(days: 7));
    _upperDate = currentDate.add(Duration(days: 7));
    startingDates = [_lowerDate, currentDate, _upperDate];

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    List<Widget> metrics = List.generate(
//        kMetricNames.length,
//        (i) => Padding(
//              padding: const EdgeInsets.all(5),
//              child: Text(kMetricNames[i]),
//            ));
//    List<Widget> values = List.generate(
//        metrics.length,
//        (i) => Padding(
//              padding: const EdgeInsets.all(5),
//              child: Text((i + 1).toString()),
//            ));

    return Scaffold(
      appBar: AppBar(
        title: Text('All habits'),
        backgroundColor: Colors.teal, //TODO set app color
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
      body: ListView.builder(
          itemCount: 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
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
                              duration: Duration(seconds: 1),
                              curve: Curves.ease);
                        });
                      },
                    ),
                    title: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Center(
                            child: Text(
                          DateFormat('MMMM yyyy').format(currentDate) ==
                                  DateFormat('MMMM yyyy').format(
                                      currentDate.add(Duration(days: 6)))
                              ? DateFormat('MMMM yyyy').format(currentDate)
                              : '${DateFormat('MMMM').format(currentDate)} - ${DateFormat('MMMM yyyy').format(currentDate.add(Duration(days: 6)))}',
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
                              duration: Duration(seconds: 1),
                              curve: Curves.ease);
                        });
                      },
                    ),
                  ),
                ),
              );
            } else {
              return SizedBox(
                height: 700,
                child: PageView(
                  onPageChanged: (index) {
                    setState(() {
                      if (index == startingDates.length - 1) {
                        print("Last page, add page to end");
                        _upperDate = _upperDate.add(Duration(days: 7));

                        startingDates.add(_upperDate);
                      }
                      if (index == 0) {
                        _lowerDate = _lowerDate.subtract(Duration(days: 7));

                        startingDates.insert(0, _lowerDate);

                        controller
                            .jumpTo(1.5 * MediaQuery.of(context).size.width);
                        controller.animateToPage(1,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                        currentDate = currentDate.add(Duration(days: 7));
                      }
                      if (index > controller.page.floor()) {
                        // controlling the Date displayed
                        currentDate = currentDate.add(Duration(days: 7));
                      } else {
                        currentDate = currentDate.subtract(Duration(days: 7));
                      }

                      hijriFirstDay = ummAlquraCalendar.fromDate(currentDate);
                      hijriLastDay = ummAlquraCalendar
                          .fromDate(currentDate.add(Duration(days: 7)));
                    });
                  },
                  controller: controller,
                  children: List<Widget>.generate(
                    startingDates.length,
                    (i) => _buildPages(startingDates[i]),
                  ),
                ),
              );
            }
          }

//          Padding(
//            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
//            child: Material(
//              elevation: 0,
//              color: widget.habit.color.withAlpha(50),
//              shape: RoundedRectangleBorder(
//                side: BorderSide(
//                    width: 1, color: widget.habit.color.withOpacity(0.5)),
//                borderRadius: BorderRadius.circular(20),
//              ),
//              child: Container(
//                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
//                  child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: metrics),
//                      Column(
//                          crossAxisAlignment: CrossAxisAlignment.end,
//                          children: values)
//                    ],
//                  )),
//            ),
//          ),
          ),
    );
  }
}
