import 'package:flutter/material.dart';

// Paints a single horizontal segment spanning the full width of its own
// box, at vertical center. Used for the small "gap" box on either side of
// a day's circle in ButtonsList: each box's width is exactly the space
// between a cell's edge and the circle's edge, so drawing edge-to-edge
// within that box touches the circle's border precisely (no overlap into
// it) on one end and the adjacent cell's own gap box exactly at the other
// end — two adjacent cells' lines meet flush at the shared cell boundary
// with no separate overdraw/clip bookkeeping to get wrong.
class DrawHorizontalLine extends CustomPainter {
  final Color color;
  final double width;

  DrawHorizontalLine({required this.color, required this.width});

  @override
  void paint(Canvas canvas, Size size) {
    if (color == Colors.transparent) return;
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.square;
    final midY = size.height / 2;
    canvas.drawLine(Offset(0, midY), Offset(size.width, midY), paint);
  }

  @override
  bool shouldRepaint(covariant DrawHorizontalLine oldDelegate) =>
      oldDelegate.color != color || oldDelegate.width != width;
}
