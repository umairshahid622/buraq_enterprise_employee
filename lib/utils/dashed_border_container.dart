
import 'dart:ui';

import 'package:flutter/material.dart';

class DashedBorderContainer extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double borderRadius;
  final List<double> dashPattern;

  DashedBorderContainer({
    this.color = Colors.grey,
    this.strokeWidth = 2.0,
    this.borderRadius = 12.0,
    this.dashPattern = const [6, 3],
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ));

    final Path dashedPath = Path();
    
    for (PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < pathMetric.length) {
        double len = dashPattern[draw ? 0 : 1];
        if (draw) {
          dashedPath.addPath(
            pathMetric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(DashedBorderContainer oldDelegate) => false;
}