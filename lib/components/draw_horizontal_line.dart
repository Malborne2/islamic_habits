import 'package:flutter/material.dart';

class DrawHorizontalLine extends CustomPainter {
  Paint _paint;
  final Color lineColor;
  final double width;
  final double lineLength;

  DrawHorizontalLine(
      {@required this.lineColor,
      @required this.width,
      @required this.lineLength}) {
    _paint = Paint()
      ..color = lineColor
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(-lineLength, 0.0), Offset(0, 0.0), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
