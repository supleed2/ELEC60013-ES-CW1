import 'package:flutter/material.dart';
import 'package:leg_barkr_app/model/steps_series.dart';
import 'package:leg_barkr_app/service/steps_service.dart';
import 'package:leg_barkr_app/view/steps/steps_chart.dart';
import 'package:leg_barkr_app/view/steps/steps_today.dart';

class StepsPage extends StatefulWidget {
  const StepsPage({ Key? key }) : super(key: key);

  @override
  _StepsPageState createState() => _StepsPageState();
}

class _StepsPageState extends State<StepsPage> {

  Future<List<int>> onStepsRetrieved() async{
      List<dynamic> res = await StepsService().getStepsLastFiveDays("132-567-001");
      List<int> steps = [];
      for (int i = 0; i < res.length; i++){
        steps.add(res[i]);
      }
      return steps;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 50.0, 10.0, 0.0),
      child: FutureBuilder(
        future: onStepsRetrieved(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          int stepsToday = 0;
          List<StepsSeries> stepsSeries = [];
          if(snapshot.hasData) {
            List<int> stepsLastFiveDays = snapshot.data;
            stepsToday = stepsLastFiveDays[0];
            for(int i = 0; i < stepsLastFiveDays.length; i++){
              DateTime now = DateTime.now();
              stepsSeries.add(StepsSeries(DateTime(now.year, now.month, now.day-i), stepsLastFiveDays[i]));
            }
            stepsSeries = List.from(stepsSeries.reversed);
          }
          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StepsToday(stepsToday),
                new Expanded(child: StepsChart(stepsSeries))
              ],
            );
        },
      )
    );
  }
}