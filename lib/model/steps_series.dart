import 'package:charts_flutter/flutter.dart' as charts;

class StepSeries {
  final DateTime date;
  final int steps;
  final charts.Color barColor;

  StepSeries({
        required this.date,
        required this.steps,
        required this.barColor
      });
}