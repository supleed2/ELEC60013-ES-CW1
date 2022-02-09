import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:leg_barkr_app/model/steps_series.dart';

class StepsChart extends StatelessWidget {
  List<StepsSeries> data;

  StepsChart(this.data);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<StepsSeries, String>> series = [
      charts.Series(
          id: "Steps",
          data: data,
          domainFn: (StepsSeries series, _) => series.date.day.toString() + "/" + series.date.month.toString(),
          measureFn: (StepsSeries series, _) => series.steps,
          colorFn: (StepsSeries series, _) => charts.ColorUtil.fromDartColor(Colors.green)
      )
    ];

    return Container(
      height: 600,
      width: double.infinity,
      child: charts.BarChart(series, animate: true)
    );
  }

}