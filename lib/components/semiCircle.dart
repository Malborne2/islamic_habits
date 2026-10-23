import 'dart:math';
import 'package:flutter/material.dart';

class SemiCircle extends CustomPainter {
  final double width;
  final Color fillColor;
  final Color lineColor;
  final double completePercent;

  const SemiCircle({
    required this.fillColor,
    required this.lineColor,
    required this.width,
    this.completePercent = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double percentage = completePercent > 100 ? 100 : completePercent;
    double arcAngle = 2 * pi * (percentage / 100);
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    Paint line = Paint()
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

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 0,
        arcAngle, true, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
