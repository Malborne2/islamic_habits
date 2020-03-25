import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class SemiCircle extends CustomPainter {
  double completePercent;
  double width;
  Color fillColor;
  Color lineColor;
  SemiCircle(
      {@required this.fillColor,
      @required this.lineColor,
      @required this.width,
      @required this.completePercent});
  @override
  void paint(Canvas canvas, Size size) {
    double percentage = completePercent ?? 0;
    percentage = percentage > 100 ? 100 : percentage;
//    print('Percentage: $percentage');
    double arcAngle = 2 * pi * (percentage / 100);
    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Paint complete = Paint()
      ..color = fillColor
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = 10;

    if (percentage > 0)
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 0,
          arcAngle, false, line);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 0, arcAngle,
        true, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
