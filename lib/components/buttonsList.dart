import 'package:flutter/material.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/components/draw_horizontal_line.dart';
import 'habit_button.dart';
import 'package:islamic_habits/components/habit_input_dialog.dart';
import 'package:vibration/vibration.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:islamic_habits/utility/functions.dart';

class ButtonsList extends StatefulWidget {
  final int length;
  final DateTime startDate;
  final Habit habit;
  final int startOfWeek;
//  final double wrapHeight;
//  final Function onPressed;
  final Color failColor;
  @override
  _ButtonsListState createState() => _ButtonsListState();
  ButtonsList({
    @required this.length,
    @required this.startDate,
    @required this.startOfWeek,
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

  onButtonPressed(DateTime day) async {
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

  int getWeekDaysDiff() {
    int diff = (widget.startDate.weekday - widget.startOfWeek);
    diff = diff < 0 ? diff += 7 : diff;
    return diff; //TODO
  }

  bool isHabitButton(int i) {
    return i < widget.length + getWeekDaysDiff() && i >= getWeekDaysDiff()
        ? true
        : false;
  }

  bool isStreakBefore(DateTime date) {
    if (widget.habit.getStatus(date) == Status.SUCCESS &&
        widget.habit.getStatus(date.subtract(Duration(days: 1))) ==
            Status.SUCCESS) return true;
    return false;
  }

  bool isStreakAfter(DateTime date) {
    if (widget.habit.getStatus(date) == Status.SUCCESS &&
        widget.habit.getStatus(date.add(Duration(days: 1))) == Status.SUCCESS)
      return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> habitDayButtons = List.generate(42, (i) {
      DateTime date =
          widget.startDate.add(Duration(days: i - getWeekDaysDiff()));
      double width = MediaQuery.of(context).size.width;

      double diameter = width / 9;
      double lineLength = diameter / 4;

      return Container(
        width: lineLength +
            diameter, //the width of the today circle is 1 on both sides
        child: Stack(
          alignment: AlignmentDirectional.center,
          overflow: Overflow.clip,
          children: <Widget>[
            RawMaterialButton(
              shape: CircleBorder(
                //The today circle in the habit
                side: BorderSide(
                    color:
                        isToday(date) ? Colors.yellow[600] : Colors.transparent,
                    width: widget.habit.hasData(date) || !isHabitButton(i)
                        ? 1
                        : 3),
              ),
              fillColor:
                  isHabitButton(i) ? null : Colors.grey[800].withAlpha(10),
              onPressed: null,
              constraints: BoxConstraints.tightFor(
                width: !isHabitButton(i) ? diameter : diameter + 5,
                height: !isHabitButton(i) ? diameter : diameter + 5,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CustomPaint(
                  painter: DrawHorizontalLine(
                      isBefore: true,
                      lineColor: isStreakBefore(date) && isHabitButton(i)
                          ? widget.habit.color.withOpacity(0.8)
                          : Colors.transparent,
                      width: 3,
                      lineLength: lineLength / 2),
                ),
                isHabitButton(i)
                    ? HabitButton(
                        day: date,
                        diameter: diameter,
                        successColor: widget.habit.color,
                        failColor: widget.failColor,
                        type: widget.habit.type,
                        successPercentage:
                            widget.habit.getSuccessPercentage(date),
                        onPressed: isTodayOrBefore(date)
                            ? () {
                                setState(() {
                                  DateTime now = DateTime.now();
                                  onButtonPressed(date.add(Duration(
                                      hours: now.hour,
                                      minutes: now.minute,
                                      seconds: now.second,
                                      milliseconds: now.millisecond)));
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
                CustomPaint(
                  painter: DrawHorizontalLine(
                      isBefore: false,
                      lineColor: isStreakAfter(date) && isHabitButton(i)
                          ? widget.habit.color.withOpacity(0.8)
                          : Colors.transparent,
                      width: 3,
                      lineLength: lineLength / 2),
                ),
              ],
            )
          ],
        ),
      );
    });

    return Wrap(
      runSpacing: 5,
      children: habitDayButtons,
    );

//    return GridView.count(
//      cacheExtent: 10,
////      padding: const EdgeInsets.all(10),
//      mainAxisSpacing: 10,
//      crossAxisCount: 7,
//      shrinkWrap: true,
//      children: habitDayButtons,
//    );
  }
}
