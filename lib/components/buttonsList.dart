import 'package:flutter/material.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/components/draw_horizontal_line.dart';
import 'round_button.dart';

class ButtonsList extends StatefulWidget {
  final int length;
  final DateTime startDate;
  final Habit habit;
//  final Function onPressed;
  final Color failColor;
  @override
  _ButtonsListState createState() => _ButtonsListState();
  ButtonsList({
    @required this.length,
    @required this.startDate,
//    @required this.onPressed,
    @required this.habit,
    @required this.failColor,
  });
}

class _ButtonsListState extends State<ButtonsList> {
  onButtonPressed(DateTime day, double value) {
    setState(() {
      if (widget.habit.type == HabitType.YES_NO) {
        if (widget.habit.getHabitDataValue(day) == null)
          widget.habit.setHabitDataValue(day, 1);
        else if (widget.habit.getHabitDataValue(day) == 1)
          widget.habit.setHabitDataValue(day, 0);
        else
          widget.habit.setHabitDataValue(day, null);
      }
    });

    //TODO implement the logic for NUMBER HabitType
  }

  bool isStreak(DateTime date) {
    if (widget.habit.getStatus(date) == Status.SUCCESS &&
        widget.habit.getStatus(date.subtract(Duration(days: 1))) ==
            Status.SUCCESS) return true;
    return false;
  }

  bool isToday(DateTime date) {
    DateTime now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day)
      return true;
    return false;
  }

  bool isAfterToday(DateTime date) {
    DateTime now = DateTime.now();
    if (now.isAfter(date)) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> habitDayButtons = List.generate(widget.length, (i) {
      DateTime date = widget.startDate.add(Duration(days: i));
      double width = MediaQuery.of(context).size.width;
      double diameter = width / 9;
      double lineLength = 12;

      return Container(
        width: lineLength + diameter,
        child: Row(
          children: <Widget>[
            CustomPaint(
              painter: DrawHorizontalLine(
                  lineColor: isStreak(date)
                      ? widget.habit.color.withOpacity(0.8)
                      : Colors.transparent,
                  width: 3,
                  lineLength: lineLength),
            ),
            Material(
              shape: CircleBorder(
                side: BorderSide(
                    color:
                        isToday(date) ? Colors.yellow[600] : Colors.transparent,
                    width: 3),
              ),
              child: RoundButton(
                day: date,
                diameter: diameter,
                successColor: widget.habit.color,
                failColor: widget.failColor,
                onPressed: isAfterToday(date)
                    ? () {
                        setState(() {
                          onButtonPressed(date, null);
                          //TODO implement value selection by user
                        });
                      }
                    : () {},
                status: widget.habit.getStatus(date),
              ),
            )
          ],
        ),
      );
    });

    return Wrap(
      runSpacing: 10,
      children: habitDayButtons,
    );
  }
}
