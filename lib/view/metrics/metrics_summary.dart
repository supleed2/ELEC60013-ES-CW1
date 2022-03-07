import 'package:flutter/material.dart';
import 'package:leg_barkr_app/model/metrics_data.dart';

class MetricsSummary extends StatelessWidget {
  MetricsData data;
  Color textColour;

  MetricsSummary(this.data, this.textColour);

  @override
  Widget build(BuildContext context) {
    Row metricMinMax = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 5.0, 10.0),
            child: Text("Minimum\n" + data.lowestReading.toString() + " " + data.units, textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold))
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(5.0, 10.0, 0.0, 10.0),
            child: Text("Maximum\n" + data.highestReading.toString() + " " + data.units, textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold))
        )
      ],
    );

    return Expanded(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Center(
              child: Column(
                children: [
                  Text(data.metric, textAlign: TextAlign.center, style: TextStyle(color: textColour, fontSize: 24, fontWeight: FontWeight.bold)),
                  metricMinMax
                ],
              )
          )
        )
    );
  }
}