import 'package:flutter/material.dart';
import 'package:leg_barkr_app/home.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        home: HomeScreen()
    );
  }
}

