import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:leg_barkr_app/model/temp_series.dart';
import 'package:leg_barkr_app/utils/constants.dart' as Constants;

class TempChart extends StatelessWidget {
  List<TempSeries> tempData;

  TempChart(this.tempData);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<TempSeries, DateTime>> series = [
      charts.Series(
          id: "Temperature",
          data: tempData,
          domainFn: (TempSeries series, _) => series.date,
          measureFn: (TempSeries series, _) => series.temperature,
          colorFn: (TempSeries series, _) => charts.ColorUtil.fromDartColor(Colors.green)
      )
    ];

    return Container(
        height: 600,
        width: double.infinity,
        child: charts.TimeSeriesChart(
          series,
          animate: true,
          primaryMeasureAxis: const charts.NumericAxisSpec(
            tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false),
            viewport: charts.NumericExtents(Constants.MIN_SKIN_TEMP, Constants.MAX_SKIN_TEMP),
          ),)
    );
  }

}