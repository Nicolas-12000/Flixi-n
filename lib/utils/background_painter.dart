import 'package:flutter/material.dart';

class BackgroundPatternPainter extends CustomPainter {
  final double offset;

  BackgroundPatternPainter(this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha((0.05 * 255).round())
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.2 * i + offset, size.height * 0.3 + offset),
        40,
        paint,
      );
      canvas.drawCircle(
        Offset(size.width * 0.2 * i - offset, size.height * 0.7 - offset),
        60,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(BackgroundPatternPainter oldDelegate) =>
      oldDelegate.offset != offset;
}
