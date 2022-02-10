import 'package:flutter/material.dart';
import 'package:leg_barkr_app/view/metrics/metrics_page.dart';
import 'package:leg_barkr_app/view/steps/steps_page.dart';
import 'package:leg_barkr_app/view/map_page.dart';
import 'package:leg_barkr_app/view/settings_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  PageController _pageController = PageController();

  void onBottomBarPressed(int page) {
    setState(() {
      _page = page;
    });
    _pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        children: const <Widget>[
          MetricsPage(),
          StepsPage(),
          MapPage(),
          SettingsPage()
        ],
        onPageChanged: (page) {
          setState(() {
            _page = page;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.data_usage), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Steps'),
            BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: 'Location'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
          currentIndex: _page,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        onTap: onBottomBarPressed,
        type: BottomNavigationBarType.fixed,
      )
    );
  }
}


