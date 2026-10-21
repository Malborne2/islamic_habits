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
  final bool isHabitDetail;
  final Color failColor;
  final VoidCallback? onChanged;

  const ButtonsList({
    super.key,
    required this.length,
    required this.startDate,
    required this.startOfWeek,
    required this.habit,
    required this.failColor,
    this.isHabitDetail = true,
    this.onChanged,
  });

  @override
  _ButtonsListState createState() => _ButtonsListState();
}

class _ButtonsListState extends State<ButtonsList> {
  Future<double?> getValue(double? initialValue) async {
    final value = await showDialog<double>(
        context: context,
        builder: (BuildContext context) {
          return HabitInputDialog(
              initialValue: initialValue, unit: widget.habit.numberUnit);
        });
    if (value != null && value != initialValue) {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 100);
      }
      Fluttertoast.showToast(
          msg: "New value added successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 14.0);
    }
    return value;
  }

  void onButtonPressed(DateTime day) async {
    if (widget.habit.type == HabitType.YES_NO) {
      setState(() {
        final currentValue = widget.habit.getHabitDataValue(day);
        if (currentValue == 1)
          widget.habit.setHabitDataValue(day, 0);
        else if (currentValue == 0)
          widget.habit.setHabitDataValue(day, null);
        else
          widget.habit.setHabitDataValue(day, 1);
      });
      widget.onChanged?.call();
    } else if (widget.habit.type == HabitType.NUMBER) {
      final value = await getValue(widget.habit.getHabitDataValue(day));
      setState(() {
        widget.habit.setHabitDataValue(day, value);
      });
      widget.onChanged?.call();
    }
  }

  int getWeekDaysDiff() {
    int diff = (widget.startDate.weekday - widget.startOfWeek);
    return diff < 0 ? diff + 7 : diff;
  }

  bool isHabitButton(int i) {
    return i < widget.length + getWeekDaysDiff() && i >= getWeekDaysDiff();
  }

  bool isStreakBefore(DateTime date) {
    return widget.habit.getStatus(date) == Status.SUCCESS &&
        widget.habit.getStatus(date.subtract(const Duration(days: 1))) ==
            Status.SUCCESS;
  }

  bool isStreakAfter(DateTime date) {
    return widget.habit.getStatus(date) == Status.SUCCESS &&
        widget.habit.getStatus(date.add(const Duration(days: 1))) ==
            Status.SUCCESS;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Divide the available width into exactly 7 equal slots so there is
        // never any leftover space that could cause overflow.
        final double itemWidth = constraints.maxWidth / 7;
        final double diameter = itemWidth * 0.8;
        final double gap = (itemWidth - diameter) / 2; // space on each side

        List<Widget> habitDayButtons =
            List.generate(widget.isHabitDetail ? 42 : 7, (i) {
          DateTime date =
              widget.startDate.add(Duration(days: i - getWeekDaysDiff()));

          return SizedBox(
            width: itemWidth,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                RawMaterialButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: CircleBorder(
                    side: BorderSide(
                        color: isToday(date)
                            ? Colors.yellow.shade600
                            : Colors.transparent,
                        width: widget.habit.hasData(date) || !isHabitButton(i)
                            ? 1
                            : 3),
                  ),
                  fillColor: isHabitButton(i)
                      ? null
                      : Colors.grey.shade800.withValues(alpha: 10 / 255),
                  onPressed: null,
                  constraints: BoxConstraints.tightFor(
                    width: diameter,
                    height: diameter,
                  ),
                ),
                // Row fills the full slot so streak-line SizedBoxes are
                // sized explicitly — no zero-width CustomPaint ambiguity.
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      width: gap,
                      child: CustomPaint(
                        painter: DrawHorizontalLine(
                            isBefore: true,
                            lineColor: isStreakBefore(date) && isHabitButton(i)
                                ? widget.habit.color.withValues(alpha: 0.8)
                                : Colors.transparent,
                            width: 3,
                            lineLength: gap),
                      ),
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
                                      onButtonPressed(date);
                                    });
                                  }
                                : () {},
                            status: widget.habit.getStatus(date),
                          )
                        : RawMaterialButton(
                            onPressed: null,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            constraints: BoxConstraints.tightFor(
                              width: diameter,
                              height: diameter,
                            ),
                          ),
                    SizedBox(
                      width: gap,
                      child: CustomPaint(
                        painter: DrawHorizontalLine(
                            isBefore: false,
                            lineColor: isStreakAfter(date) && isHabitButton(i)
                                ? widget.habit.color.withValues(alpha: 0.8)
                                : Colors.transparent,
                            width: 3,
                            lineLength: gap),
                      ),
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
      },
    );
  }
}
