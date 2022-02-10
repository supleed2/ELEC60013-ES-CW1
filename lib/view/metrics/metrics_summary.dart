import 'package:flutter/material.dart';
import 'package:leg_barkr_app/model/metrics_data.dart';
import 'metrics_min_max.dart';

class MetricsSummary extends StatelessWidget {
  MetricsData data;
  Color textColour;

  MetricsSummary(this.data, this.textColour);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Center(
              child: Column(
                children: [
                  Text(data.metric, textAlign: TextAlign.center, style: TextStyle(color: textColour, fontSize: 24, fontWeight: FontWeight.bold)),
                  MetricsMinMax(data.lowestReading, data.highestReading, data.units)
                ],
              )
          )
        )
    );
  }
}