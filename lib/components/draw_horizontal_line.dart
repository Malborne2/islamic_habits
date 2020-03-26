import 'package:flutter/material.dart';

class DrawHorizontalLine extends CustomPainter {
  Paint _paint;
  final Color lineColor;
  final double width;
  final double lineLength;
  final bool isBefore;

  DrawHorizontalLine(
      {@required this.lineColor,
      @required this.width,
      @required this.isBefore,
      @required this.lineLength}) {
    _paint = Paint()
      ..color = lineColor
      ..strokeWidth = width
      ..strokeCap = StrokeCap.square;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(isBefore ? -lineLength : -1, 0.0),
        Offset(isBefore ? 1 : lineLength, 0.0), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
