import 'package:flutter/material.dart';
import 'package:islamic_habits/components/buttonsList.dart';
import 'package:islamic_habits/utility/prayer_helper.dart';
import 'package:adhan_flutter/adhan_flutter.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/constants.dart';

class SeveralHabitsPage extends StatefulWidget {
  final DateTime currentDate;
  final List<Habit> habits;
  SeveralHabitsPage({@required this.currentDate, @required this.habits});
  @override
  _SeveralHabitsPageState createState() => _SeveralHabitsPageState();
}

class _SeveralHabitsPageState extends State<SeveralHabitsPage> {
  final prayerHelper = PrayerHelper(
      latitude: 25.3157001,
      longitude: 51.8788493,
      calculationMethod: CalculationMethod.QATAR,
      dateTime: DateTime.now());

  @override
  void initState() {
    super.initState();
  }

  List<Widget> generateHabitsList() {
    List<Widget> habitWidgets = [
      Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            7,
            (i) => Container(
                width: 17 * MediaQuery.of(context).size.width / 144,
                child: Center(child: Text(kDays[(kStartOfWeek + i) % 7]))),
          ),
        ),
      )
    ];

    for (Habit habit in widget.habits) {
      habitWidgets
        ..add(Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              habit.name,
              style: TextStyle(color: habit.color),
            )))
        ..add(ButtonsList(
          length: 7,
          isHabitDetail: false,
          startOfWeek: Habit.startOfWeek,
          habit: habit,
          failColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.brown[800]
              : Colors.brown[300],
          startDate: widget.currentDate,
        ));
    }

    return habitWidgets;
  }

  @override
  Widget build(BuildContext context) {
//    print(widget.currentDate.toIso8601String());
    return Column(
//      mainAxisSize: MainAxisSize.min,
      children: generateHabitsList(),
    );
  }
}
