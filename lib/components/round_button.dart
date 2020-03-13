import 'package:flutter/material.dart';
import 'package:islamic_habits/components/draw_horizontal_line.dart';

class RoundButton extends StatelessWidget {
  final DateTime day;
  final Status status;
  final Function onPressed;
  final Color successColor;
  final Color failColor;
  final double diameter;
  RoundButton({
    @required this.day,
    @required this.diameter,
    @required this.onPressed,
    @required this.successColor,
    @required this.failColor,
    @required this.status,
  });

  bool isSuccess() {
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
  }
}

enum Status {
  SUCCESS,
  FAIL,
  NO_DATA,
}
