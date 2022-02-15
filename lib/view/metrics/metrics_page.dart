import 'package:flutter/material.dart';
import 'package:leg_barkr_app/model/metrics_data.dart';
import 'package:leg_barkr_app/model/metrics_response.dart';
import 'package:leg_barkr_app/model/temp_series.dart';
import 'package:leg_barkr_app/service/metrics_service.dart';
import 'metrics_row.dart';
import 'package:leg_barkr_app/utils/constants.dart' as Constants;

import 'temp_chart.dart';

class MetricsPage extends StatefulWidget {
  const MetricsPage({ Key? key }) : super(key: key);

  @override
  _MetricsPageState createState() => _MetricsPageState();
}

class _MetricsPageState extends State<MetricsPage> {
  // Dummy data, will be removed
  /*
    final List<TempSeries> data = [
    TempSeries(DateTime.parse('2022-02-09 20:00:00Z'), 38.4),
    TempSeries(DateTime.parse('2022-02-09 19:30:00Z'), 38.8),
    TempSeries(DateTime.parse('2022-02-09 19:00:00Z'), 38.2),
    TempSeries(DateTime.parse('2022-02-09 18:30:00Z'), 39.2),
    TempSeries(DateTime.parse('2022-02-09 18:00:00Z'), 39.5),
    TempSeries(DateTime.parse('2022-02-09 17:30:00Z'), 37.8)
  ];
   */

  Future<MetricsResponse> onMetricsReceived() async{
    return await MetricsService().getMetricsSummary("132-567-001");
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
        child: FutureBuilder(
          future: onMetricsReceived(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            MetricsResponse metricsResponse;
            if (snapshot.hasData){
              metricsResponse = snapshot.data;
            } else {
              metricsResponse = MetricsResponse(0, 0, 0, 0, 0, 0, 0, 0, 0);
            }

            return ListView(
                    padding: EdgeInsets.all(5.0),
                    children: <Widget>[
                      Text("Today's summary", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 36, fontWeight: FontWeight.bold)),

                      // Dummy data
                      MetricsRow(new MetricsData(metricsResponse.lastSkinTemp, metricsResponse.minSkinTemp, metricsResponse.maxSkinTemp, Constants.MIN_SKIN_TEMP, Constants.MAX_SKIN_TEMP, Constants.LOW_SKIN_TEMP_DOG, Constants.HIGH_SKIN_TEMP_DOG, "Skin temperature", "°C"), Colors.white, Colors.green, true),
                      MetricsRow(new MetricsData(metricsResponse.lastHumidity, metricsResponse.minHumidity, metricsResponse.maxHumidity, Constants.MIN_HUMIDITY, Constants.MAX_HUMIDITY, Constants.LOW_HUMIDITY_DOG, Constants.HIGH_HUMIDITY_DOG, "Humidity", "%"), Colors.green, Colors.black, false),
                      MetricsRow(new MetricsData(metricsResponse.lastAirTemp, metricsResponse.minAirTemp, metricsResponse.maxAirTemp, Constants.MIN_AIR_TEMP, Constants.MAX_AIR_TEMP, Constants.LOW_AIR_TEMP_DOG, Constants.HIGH_AIR_TEMP_DOG, "Air temperature", "°C"), Colors.white, Colors.green, true),

                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                        child: Text("Today's temperature", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 36, fontWeight: FontWeight.bold)),
                      ),

                      //TempChart(data)

                    ]
            );
          }
        )
    );
  }
}