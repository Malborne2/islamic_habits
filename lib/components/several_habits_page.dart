import 'package:flutter/material.dart';
import 'package:islamic_habits/components/buttonsList.dart';
import 'package:islamic_habits/screens/habit_detail.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/habit_name_localizer.dart';
import 'package:islamic_habits/utility/weekday_localizer.dart';

class SeveralHabitsPage extends StatefulWidget {
  final DateTime currentDate;
  final List<Habit> habits;
  // The full habit list, for the drawer on the detail screen a tap here
  // opens — habits may be a filtered subset (e.g. just the five prayers),
  // in which case that drawer would otherwise only show this subset too.
  final List<Habit>? allHabits;
  final VoidCallback? onChanged;
  const SeveralHabitsPage(
      {super.key,
      required this.currentDate,
      required this.habits,
      this.allHabits,
      this.onChanged});
  @override
  _SeveralHabitsPageState createState() => _SeveralHabitsPageState();
}

class _SeveralHabitsPageState extends State<SeveralHabitsPage> {
  List<Widget> generateHabitsList(double itemWidth) {
    List<Widget> habitWidgets = [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: List.generate(
            7,
            (i) => SizedBox(
                width: itemWidth,
                child: Center(
                    child: Text(localizedWeekdayShort(
                        context, weekdayForColumn(kStartOfWeek, i))))),
          ),
        ),
      )
    ];

    for (Habit habit in widget.habits) {
      habitWidgets
        ..add(InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HabitDetail(
                      habit: habit,
                      habits: widget.allHabits ?? widget.habits),
                  settings: RouteSettings(name: '/${habit.name}'),
                ));
          },
          child: Container(
              alignment: Alignment.centerLeft,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                localizedHabitName(context, habit.name),
                style: TextStyle(color: habit.color),
              )),
        ))
        ..add(ButtonsList(
          length: 7,
          isHabitDetail: false,
          startOfWeek: Habit.startOfWeek,
          habit: habit,
          failColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.brown.shade800
              : Colors.brown.shade300,
          startDate: widget.currentDate,
          onChanged: widget.onChanged,
        ));
    }

    return habitWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemWidth = constraints.maxWidth / 7;
        return SingleChildScrollView(
          child: Column(
            children: generateHabitsList(itemWidth),
          ),
        );
      },
    );
  }
}
