import 'package:flutter/material.dart';

class MetricsMinMax extends StatelessWidget {
  double lowest, highest;
  String units;

  MetricsMinMax(this.lowest, this.highest, this.units);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 5.0, 10.0),
              child: Text("Minimum\n" + lowest.toString() + " " + units, textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold))
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(5.0, 10.0, 0.0, 10.0),
              child: Text("Maximum\n" + highest.toString() + " " + units, textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold))
          )
        ],
    );
  }
}