import 'package:flutter/material.dart';

class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint axisPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Paint dataPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Paint markingLinePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final List<Offset> mockDataPoints = <Offset>[
      const Offset(15, 155),
      const Offset(20, 133),
      const Offset(34, 125),
      const Offset(40, 105),
      const Offset(70, 85),
      const Offset(80, 95),
      const Offset(90, 60),
      const Offset(120, 54),
      const Offset(160, 60),
      const Offset(200, -10),
    ];

    final Path axis = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height);

    final Path markingLine = Path()
      ..moveTo(-10, 50)
      ..lineTo(size.width + 10, 50);

    final Path data = Path()..moveTo(1, 180);

    for (Offset dataPoint in mockDataPoints) {
      data.lineTo(dataPoint.dx, dataPoint.dy);
    }

    canvas.drawPath(axis, axisPaint);
    canvas.drawPath(data, dataPaint);
    canvas.drawPath(markingLine, markingLinePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
