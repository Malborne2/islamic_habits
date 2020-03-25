import 'package:flutter/material.dart';
import 'package:islamic_habits/components/buttonsList.dart';
import 'package:islamic_habits/utility/prayer_helper.dart';
import 'package:adhan_flutter/adhan_flutter.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/constants.dart';

class HabitPage extends StatefulWidget {
  final DateTime currentDate;
  final Habit habit;
  HabitPage({@required this.currentDate, @required this.habit});
  @override
  _HabitPageState createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  final prayerHelper = PrayerHelper(
      latitude: 25.3157001,
      longitude: 51.8788493,
      calculationMethod: CalculationMethod.QATAR,
      dateTime: DateTime.now());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    print(widget.currentDate.toIso8601String());
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: List.generate(
            7,
            (i) => Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 27,
                    vertical: 10),
                child: Text(kDays[(kStartOfWeek + i) % 7])),
          ),
        ),
        ButtonsList(
          length: daysOfMonth(widget.currentDate),
          habit: widget.habit,
          failColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.brown[800]
              : Colors.brown[300],
          startDate: widget.currentDate,
        )
      ],
    );
  }
}
