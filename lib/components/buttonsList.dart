import 'package:flutter/material.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/components/draw_horizontal_line.dart';
import 'habit_button.dart';
import 'package:islamic_habits/components/habit_input_dialog.dart';
import 'package:vibration/vibration.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ButtonsList extends StatefulWidget {
  final int length;
  final DateTime startDate;
  final Habit habit;
//  final double wrapHeight;
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
  Future<double> getValue(double initialValue) async {
    var value = await showDialog<double>(
        context: context,
        builder: (BuildContext context) {
          return HabitInputDialog(
            initialValue: initialValue,
          );
        });
    if (value != null && value != initialValue) {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 100);
      }
      Fluttertoast.showToast(
          msg: "New value added successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 14.0);
    }
    return value;
  }

  onButtonPressed(DateTime day, double value) async {
    if (widget.habit.type == HabitType.YES_NO) {
      setState(() {
        if (widget.habit.getHabitDataValue(day) == null)
          widget.habit.setHabitDataValue(day, 1);
        else if (widget.habit.getHabitDataValue(day) == 1)
          widget.habit.setHabitDataValue(day, 0);
        else
          widget.habit.setHabitDataValue(day, null);
      });
    } else if (widget.habit.type == HabitType.NUMBER) {
      var value = await getValue(widget.habit.getHabitDataValue(day));
      setState(() {
        widget.habit.setHabitDataValue(day, value);
      });
    }
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
    List<Widget> habitDayButtons = List.generate(35, (i) {
      DateTime date = widget.startDate.add(Duration(days: i));
      double width = MediaQuery.of(context).size.width;
      double diameter = width / 9;
      double lineLength = 12;

      return Container(
        width: lineLength + diameter,
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
                //The today circle in the habit
                side: BorderSide(
                    color:
                        isToday(date) ? Colors.yellow[600] : Colors.transparent,
                    width: 3),
              ),
              color: i < widget.length ? null : Colors.grey.withAlpha(10),
              child: i < widget.length
                  ? HabitButton(
                      day: date,
                      diameter: diameter,
                      successColor: widget.habit.color,
                      failColor: widget.failColor,
                      type: widget.habit.type,
                      successPercentage:
                          widget.habit.getSuccessPercentage(date),
                      onPressed: isAfterToday(date)
                          ? () {
                              setState(() {
                                onButtonPressed(date, null);
                                //TODO implement value selection by user
                              });
                            }
                          : () {},
                      status: widget.habit.getStatus(date),
                    )
                  : RawMaterialButton(
                      onPressed: null,
                      constraints: BoxConstraints.tightFor(
                        width: diameter,
                        height: diameter,
                      ),
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
//    return GridView.count(
////      primary: false,
////      padding: const EdgeInsets.all(10),
////      crossAxisSpacing: 10,
////      mainAxisSpacing: 10,
//      crossAxisCount: 7,
//      shrinkWrap: true,
//      children: habitDayButtons,
//    );
  }
}
