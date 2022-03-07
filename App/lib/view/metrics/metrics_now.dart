import 'package:flutter/material.dart';
import 'package:leg_barkr_app/model/metrics_data.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MetricsNow extends StatelessWidget {
  MetricsData data;
  Color textColor;
  bool showGauge;

  MetricsNow(this.data, this.textColor, this.showGauge);

  @override
  Widget build(BuildContext context) {
    if (showGauge) {
      return SizedBox(
          height: 150,
          width: 150,
          child: SfRadialGauge(
              axes: [
                RadialAxis(
                    minimum: data.minimumPossible,
                    maximum: data.maximumPossible,
                    ranges: [
                      GaugeRange(
                          startValue: data.minimumPossible,
                          endValue: data.lowCutOff,
                          color: Colors.blue,
                          startWidth: 10,
                          endWidth: 10
                      ),
                      GaugeRange(
                          startValue: data.lowCutOff,
                          endValue: data.highCutOff,
                          color: textColor,
                          startWidth: 10,
                          endWidth: 10
                      ),
                      GaugeRange(
                          startValue: data.highCutOff,
                          endValue: data.maximumPossible,
                          color: Colors.red,
                          startWidth: 10,
                          endWidth: 10
                      )
                    ],
                    pointers: [
                      MarkerPointer(
                          value: data.currentReading,
                          color: Colors.black,
                          markerWidth: 20
                      )
                    ],
                    annotations: [
                      GaugeAnnotation(
                          angle: 90,
                          positionFactor: 0.75,
                          widget: Column(
                            children: [
                              Text(data.currentReading.toString(),
                                  style: TextStyle(fontSize: 26,
                                      color: textColor,
                                      fontWeight: FontWeight.bold)),
                              Text(data.units, style: TextStyle(fontSize: 16,
                                  color: textColor,
                                  fontWeight: FontWeight.bold)),
                            ],
                          )
                      )
                    ]
                )
              ]
          )
      );
    } else {
      return ElevatedButton(
        onPressed: () {},
        child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(data.currentReading.toString(),
                    style: TextStyle(fontSize: 32,
                        color: textColor,
                        fontWeight: FontWeight.bold)),
                Text(data.units, style: TextStyle(fontSize: 18,
                    color: textColor,
                    fontWeight: FontWeight.bold)),
              ],
        ),
        style: ElevatedButton.styleFrom(
          alignment: Alignment.center,
          side: BorderSide(width: 15.0, color: textColor),
          shape: CircleBorder(),
          padding: EdgeInsets.all(25),
          primary: Colors.green,
          minimumSize: Size(150, 150),
          maximumSize: Size(150, 150)
        ),
      );
    }
  }
}