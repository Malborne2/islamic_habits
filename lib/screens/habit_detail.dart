import 'package:flutter/material.dart';
import 'package:islamic_habits/components/habit_drawer.dart';
import 'package:islamic_habits/components/habit_page.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/functions.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HabitDetail extends StatefulWidget {
  final Habit habit;
  final List<Habit> habits;
  const HabitDetail({super.key, required this.habit, required this.habits});
  @override
  _HabitDetailState createState() => _HabitDetailState();
}

class _HabitDetailState extends State<HabitDetail> {
  late PageController controller;
  DateTime currentDate =
      DateTime.now().subtract(Duration(days: DateTime.now().day - 1));

  List<HabitPage> habitPages = [];
  late HijriCalendar hijriFirstDay;
  late HijriCalendar hijriLastDay;

  @override
  void initState() {
    hijriFirstDay = HijriCalendar.fromDate(currentDate);
    hijriLastDay = HijriCalendar.fromDate(
        currentDate.add(Duration(days: daysOfMonth(currentDate))));
    controller = PageController(
        initialPage: (12 * (currentDate.year - 1971) + currentDate.month) - 1);
    DateTime date = DateTime(1971, 1);
    habitPages = List.generate(
        (12 * (currentDate.year - 1971) + currentDate.month + 1), (i) {
      HabitPage myPage = HabitPage(
        habit: widget.habit,
        currentDate: date,
        onChanged: () => setState(() {}),
      );
      date = date.add(
          Duration(days: daysOfMonth(DateTime(1971 + (i ~/ 12), 1 + i % 12))));
      return myPage;
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStreak = widget.habit.getCurrentStreak();
    final overallSuccessRate = widget.habit.getOverallSuccessRate();
    final weeklyAverage = widget.habit.getAverageOverPeriod(7);
    final monthlyAverage = widget.habit.getAverageOverPeriod(30);
    final isNumberHabit = widget.habit.type == HabitType.NUMBER;

    List<String> metricValues = [
      currentStreak.toString(),
      widget.habit.successTarget.toString(),
      widget.habit.getMaximumStreak().toString(),
      '${overallSuccessRate.toStringAsFixed(0)}%',
      isNumberHabit
          ? '${weeklyAverage.toStringAsFixed(1)} ${widget.habit.numberUnit}'
          : '${weeklyAverage.toStringAsFixed(0)}%',
      isNumberHabit
          ? '${monthlyAverage.toStringAsFixed(1)} ${widget.habit.numberUnit}'
          : '${monthlyAverage.toStringAsFixed(0)}%',
    ];

    const metricTextStyle = TextStyle(fontSize: 13);
    List<Widget> metrics = List.generate(
        kMetricNames.length,
        (i) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(kMetricNames[i], style: metricTextStyle),
            ));
    List<Widget> values = List.generate(
        metrics.length,
        (i) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(metricValues[i],
                  style:
                      metricTextStyle.copyWith(fontWeight: FontWeight.w600)),
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
                currentStreak.toString(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 30),
                child: Text(
                  '${overallSuccessRate.toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: HabitDrawer(
        habits: widget.habits,
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Material(
              elevation: 5,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    setState(() {
                      controller.previousPage(
                          duration: const Duration(seconds: 1),
                          curve: Curves.ease);
                    });
                  },
                ),
                title: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Center(
                        child: Text(
                      DateFormat('MMMM yyyy').format(currentDate),
                      style: const TextStyle(fontSize: 20),
                    )),
                  ),
                  subtitle: Center(
                    child: AutoSizeText(
                      hijriFirstDay.toFormat("MMMM yyyy") ==
                              hijriLastDay.toFormat("MMMM yyyy")
                          ? hijriFirstDay.toFormat("MMMM yyyy")
                          : '${hijriFirstDay.toFormat("MMMM")} - ${hijriLastDay.toFormat("MMMM yyyy")}',
                      style: const TextStyle(fontSize: 18.0),
                      maxLines: 1,
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    setState(() {
                      controller.nextPage(
                          duration: const Duration(seconds: 1),
                          curve: Curves.ease);
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  if (index > controller.page!.floor()) {
                    currentDate = currentDate
                        .add(Duration(days: daysOfMonth(currentDate)));

                    if (index == habitPages.length - 1) {
                      habitPages.add(HabitPage(
                        habit: widget.habit,
                        currentDate: currentDate
                            .add(Duration(days: daysOfMonth(currentDate))),
                        onChanged: () => setState(() {}),
                      ));
                    }
                  } else {
                    currentDate = currentDate.subtract(Duration(
                        days: daysOfMonth(
                            currentDate.subtract(const Duration(days: 1)))));
                  }

                  hijriFirstDay = HijriCalendar.fromDate(currentDate);
                  hijriLastDay = HijriCalendar.fromDate(currentDate
                      .add(Duration(days: daysOfMonth(currentDate))));
                });
              },
              children: habitPages
                  .map((page) => SingleChildScrollView(child: page))
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: Material(
              elevation: 1,
              color: widget.habit.color.withAlpha(50),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1,
                    color: widget.habit.color.withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
