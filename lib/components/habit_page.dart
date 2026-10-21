import 'package:flutter/material.dart';
import 'package:islamic_habits/components/buttonsList.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/functions.dart';
import 'package:islamic_habits/utility/weekday_localizer.dart';

class HabitPage extends StatefulWidget {
  final DateTime currentDate;
  final Habit habit;
  final VoidCallback? onChanged;
  const HabitPage(
      {super.key,
      required this.currentDate,
      required this.habit,
      this.onChanged});
  @override
  _HabitPageState createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemWidth = constraints.maxWidth / 7;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: List.generate(
                  7,
                  (i) => SizedBox(
                      width: itemWidth,
                      child:
                          Center(
                              child: Text(localizedWeekdayShort(context,
                                  weekdayForColumn(kStartOfWeek, i))))),
                ),
              ),
            ),
            ButtonsList(
              length: daysOfMonth(widget.currentDate),
              startOfWeek: Habit.startOfWeek,
              habit: widget.habit,
              failColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.brown.shade800
                  : Colors.brown.shade300,
              startDate: widget.currentDate,
              onChanged: widget.onChanged,
            )
          ],
        );
      },
    );
  }
}
