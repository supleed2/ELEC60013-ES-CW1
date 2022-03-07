import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class StepsToday extends StatelessWidget {
  int count;

  StepsToday(this.count);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("Steps today", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center),
          Text(count.toString(), style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 40), textAlign: TextAlign.center)
        ],
      )
    );
  }

}