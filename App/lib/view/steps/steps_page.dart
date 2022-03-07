import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:leg_barkr_app/model/steps_series.dart';
import 'package:leg_barkr_app/service/steps_service.dart';
import 'package:leg_barkr_app/view/steps/steps_chart.dart';
import 'package:leg_barkr_app/view/steps/steps_today.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepsPage extends StatefulWidget {
  const StepsPage({ Key? key }) : super(key: key);

  @override
  _StepsPageState createState() => _StepsPageState();
}

class _StepsPageState extends State<StepsPage> {

  Future<List<int>> onStepsRetrieved() async{
    final prefs = await SharedPreferences.getInstance();
    final String deviceId = prefs.getString("current_device") ?? "";
    final user = await FirebaseAuth.instance.currentUser!;
    final String token = await user.getIdToken();
    return await StepsService().getStepsLastFiveDays(deviceId, token);
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