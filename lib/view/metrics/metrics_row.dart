import 'package:flutter/material.dart';
import 'package:leg_barkr_app/model/metrics_data.dart';
import 'metrics_now.dart';
import 'metrics_summary.dart';

class MetricsRow extends StatelessWidget {
  MetricsData data;
  Color backgroundColour;
  Color textColour;
  bool showGauge;

  MetricsRow(this.data, this.backgroundColour, this.textColour, this.showGauge);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10,
        shadowColor: Colors.black,
        color: backgroundColour,
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Row(
            children: [
              MetricsNow(data, textColour, showGauge),
              MetricsSummary(data, textColour)
            ],
          ),
        ),
    );
  }

}