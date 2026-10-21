import 'package:flutter/material.dart';
import 'semiCircle.dart';
import 'package:islamic_habits/utility/habit.dart';

class HabitButton extends StatelessWidget {
  final DateTime day;
  final Status status;
  final VoidCallback onPressed;
  final Color successColor;
  final Color failColor;
  final double diameter;
  final HabitType type;
  final double? successPercentage;
  // A day that isn't scheduled for this habit but sits between two
  // completed scheduled days: same ring as a success day, but with no
  // fill, since nothing was actually logged on it.
  final bool outlineOnly;

  const HabitButton({
    super.key,
    required this.day,
    required this.diameter,
    required this.onPressed,
    required this.successColor,
    required this.failColor,
    required this.status,
    required this.type,
    required this.successPercentage,
    this.outlineOnly = false,
  });

  bool isSuccess() => status == Status.SUCCESS || outlineOnly;

  @override
  Widget build(BuildContext context) {
    if (type == HabitType.YES_NO || outlineOnly) {
      return RawMaterialButton(
        onPressed: onPressed,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: CircleBorder(
          side: BorderSide(
              color: isSuccess()
                  ? successColor.withValues(alpha: 0.8)
                  : Colors.transparent,
              width: 2.5),
        ),
        elevation: 0,
        fillColor: outlineOnly
            ? Colors.transparent
            : isSuccess()
                ? successColor.withValues(alpha: 0.5)
                : status == Status.FAIL
                    ? failColor
                    : Colors.transparent,
        constraints: BoxConstraints.tightFor(
          width: diameter,
          height: diameter,
        ),
        child: Text(day.day.toString()),
      );
    } else {
      return Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          SizedBox(
            width: diameter,
            height: diameter,
            child: CustomPaint(
              foregroundPainter: SemiCircle(
                fillColor: successColor.withValues(alpha: 0.5),
                lineColor: successColor.withValues(alpha: 0.8),
                completePercent: successPercentage ?? 0,
                width: 2.5,
              ),
            ),
          ),
          RawMaterialButton(
            onPressed: onPressed,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: const CircleBorder(),
            elevation: 0,
            fillColor: status == Status.FAIL && (successPercentage ?? 0) == 0
                ? failColor
                : Colors.transparent,
            constraints: BoxConstraints.tightFor(
              width: diameter,
              height: diameter,
            ),
            child: Text(day.day.toString()),
          ),
        ],
      );
    }
  }
}

enum Status {
  SUCCESS,
  FAIL,
  NO_DATA,
}
