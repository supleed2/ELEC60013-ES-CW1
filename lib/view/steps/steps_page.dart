import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:leg_barkr_app/model/steps_series.dart';
import 'package:leg_barkr_app/view/steps/steps_chart.dart';

class StepsPage extends StatefulWidget {
  const StepsPage({ Key? key }) : super(key: key);

  @override
  _StepsPageState createState() => _StepsPageState();
}

class _StepsPageState extends State<StepsPage> {
  // Dummy data
  final List<StepsSeries> data = [
    StepsSeries(DateTime.utc(2022, 2, 9), 9867),
    StepsSeries(DateTime.utc(2022, 2, 8), 8123),
    StepsSeries(DateTime.utc(2022, 2, 7), 10234),
    StepsSeries(DateTime.utc(2022, 2, 6), 6521),
    StepsSeries(DateTime.utc(2022, 2, 5), 1021),
    StepsSeries(DateTime.utc(2022, 2, 4), 10567),
    StepsSeries(DateTime.utc(2022, 2, 3), 7500)
  ];


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: StepsChart(data)
        ),
      ),
    );
  }
}