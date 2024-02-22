import 'package:flutter/material.dart';
import 'package:news_glance/user_interface/line_chart_painter.dart';

class LineChart extends StatelessWidget {
  const LineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LineChartPainter(),
      child: const SizedBox(
        height: 200,
        width: 200,
      ),
    );
  }
}
