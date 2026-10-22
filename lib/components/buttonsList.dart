import 'package:flutter/material.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/components/draw_horizontal_line.dart';
import 'habit_button.dart';
import 'package:islamic_habits/components/habit_input_dialog.dart';
import 'package:vibration/vibration.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
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
          msg: AppLocalizations.of(context).valueAddedSuccess,
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

  // A day that isn't scheduled for this habit doesn't break the streak; if
  // both the nearest scheduled day before and after it were completed, it
  // should visually read as part of the same unbroken chain.
  bool _isBridgedOffDay(DateTime date) {
    if (widget.habit.isHabitDay(date)) return false;
    DateTime prev = addDays(date, -1);
    int guard = 0;
    while (!widget.habit.isHabitDay(prev) && guard < 14) {
      prev = addDays(prev, -1);
      guard++;
    }
    DateTime next = addDays(date, 1);
    guard = 0;
    while (!widget.habit.isHabitDay(next) && guard < 14) {
      next = addDays(next, 1);
      guard++;
    }
    return widget.habit.getStatus(prev) == Status.SUCCESS &&
        widget.habit.getStatus(next) == Status.SUCCESS;
  }

  bool _effectiveSuccess(DateTime date) {
    return widget.habit.getStatus(date) == Status.SUCCESS ||
        _isBridgedOffDay(date);
  }

  bool isStreakBefore(DateTime date) {
    return _effectiveSuccess(date) && _effectiveSuccess(addDays(date, -1));
  }

  bool isStreakAfter(DateTime date) {
    return _effectiveSuccess(date) && _effectiveSuccess(addDays(date, 1));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Divide the available width into exactly 7 equal slots so there is
        // never any leftover space that could cause overflow.
        final double itemWidth = constraints.maxWidth / 7;
        final double diameter = itemWidth * 0.8;

        List<Widget> habitDayButtons =
            List.generate(widget.isHabitDetail ? 42 : 7, (i) {
          DateTime date = addDays(widget.startDate, i - getWeekDaysDiff());

          final chainColor = widget.habit.color.withValues(alpha: 0.8);
          final showChain = isHabitButton(i);

          return SizedBox(
            width: itemWidth,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                // Drawn first (bottom of the stack) so it sits entirely
                // behind the circle — each half only needs to reach the
                // cell's own center, not stop exactly at the circle's
                // edge, so there's no gap/border math to get wrong.
                SizedBox(
                  width: itemWidth,
                  height: diameter,
                  child: CustomPaint(
                    painter: DrawHorizontalLine(
                      beforeColor: showChain && isStreakBefore(date)
                          ? chainColor
                          : Colors.transparent,
                      afterColor: showChain && isStreakAfter(date)
                          ? chainColor
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
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
                showChain
                    ? HabitButton(
                        day: date,
                        diameter: diameter,
                        successColor: widget.habit.color,
                        failColor: widget.failColor,
                        type: widget.habit.type,
                        successPercentage:
                            widget.habit.getSuccessPercentage(date),
                        // Only show the empty outline when nothing was
                        // actually logged; if the user did the habit
                        // anyway on a day it isn't scheduled, it's a
                        // real success and should render fully colored.
                        outlineOnly: !widget.habit.isHabitDay(date) &&
                            !widget.habit.hasData(date) &&
                            _isBridgedOffDay(date),
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
