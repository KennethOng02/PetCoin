import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyPieChart extends StatefulWidget {
  double income = 200;
  double expense = 30;

  MyPieChart({
    required this.income,
    required this.expense,
  });

  @override
  State<MyPieChart> createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  @override
  Widget build(BuildContext context) {
    return PieChart(
      swapAnimationDuration: const Duration(milliseconds: 750),
      swapAnimationCurve: Curves.easeInOut,
      PieChartData(sections: [
        PieChartSectionData(
          value: widget.income,
          color: Colors.green,
        ),
        PieChartSectionData(
          value: widget.expense,
          color: Colors.red,
        ),
        PieChartSectionData(
          value: widget.income - widget.expense,
          color: Colors.orange,
        ),
      ]),
    );
  }
}
