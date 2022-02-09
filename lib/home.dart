import 'package:flutter/material.dart';
import 'package:leg_barkr_app/steps.dart';
import 'package:leg_barkr_app/view/data.dart';
import 'package:leg_barkr_app/view/map.dart';
import 'package:leg_barkr_app/view/settings.dart';

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
      body: PageView(
        controller: _pageController,
        children: const <Widget>[
          DataPage(),
          StepsPage(),
          MapPage(),
          SettingsPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.data_usage), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
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


