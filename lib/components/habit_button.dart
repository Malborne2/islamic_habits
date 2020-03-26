import 'package:flutter/material.dart';
import 'semiCircle.dart';
import 'package:islamic_habits/utility/habit.dart';

class HabitButton extends StatelessWidget {
  final DateTime day;
  final Status status;
  final Function onPressed;
  final Color successColor;
  final Color failColor;
  final double diameter;
  final HabitType type;
  final double successPercentage;
  HabitButton({
    @required this.day,
    @required this.diameter,
    @required this.onPressed,
    @required this.successColor,
    @required this.failColor,
    @required this.status,
    @required this.type,
    @required this.successPercentage,
  });

  bool isSuccess() {
    print(status.toString());
    if (status == Status.SUCCESS)
      return true;
    else
      return false;
  }

//  void changeStatus() {
//    if (status == Status.NO_DATA)
//      status = Status.SUCCESS;
//    else if (status == Status.SUCCESS)
//      status = Status.FAIL;
//    else
//      status = Status.NO_DATA;
//  }

  @override
  Widget build(BuildContext context) {
//    double width = MediaQuery.of(context).size.width;
//    double diameter = width / 9;
//    double lineLength = 12;
    if (type == HabitType.YES_NO) {
      return RawMaterialButton(
        onPressed: this.onPressed,
        shape: CircleBorder(
          side: BorderSide(
              color: isSuccess()
                  ? successColor.withOpacity(0.8)
                  : Colors.transparent,
              width: 3),
        ),
        elevation: 0,
        child: Text(
          this.day.day.toString(),
//              style: Theme.of(context).textTheme.body1,
        ),
        fillColor: isSuccess()
            ? successColor.withOpacity(0.5)
            : status == Status.FAIL ? failColor : Colors.transparent,
        constraints: BoxConstraints.tightFor(
          width: diameter,
          height: diameter,
        ),
      );
    } else {
      //Number
//      print('Success percentage: $successPercentage');
      return Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Container(
            width: diameter,
            height: diameter,
            child: CustomPaint(
              foregroundPainter: SemiCircle(
                fillColor: successColor.withOpacity(0.5),
                lineColor: successColor.withOpacity(0.8),
                completePercent: successPercentage,
                width: 2.5,
              ),
            ),
          ),
          RawMaterialButton(
            onPressed: this.onPressed,
            shape: CircleBorder(),
            elevation: 0,
            fillColor: status == Status.FAIL && successPercentage == 0
                ? failColor
                : Colors.transparent,
            constraints: BoxConstraints.tightFor(
              width: diameter,
              height: diameter,
            ),
            child: Text(
              this.day.day.toString(),
//              style: Theme.of(context).textTheme.body1,
            ),
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
