import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:learnlign/pages/Rooms.dart';
import 'package:learnlign/pages/explore.dart';
import 'package:learnlign/pages/profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Define your screens here
  List<Widget> _screens = [
    Rooms(),
    Explore(),
    Profile()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        //color: Color.fromRGBO(31,35, 33, 1),
        color: Color.fromRGBO(37, 38, 38, 1),
        buttonBackgroundColor: Colors.amber.shade400,
        backgroundColor: Color.fromRGBO(27, 28, 28, 1),
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        height: 60.0,
        onTap: _onItemTapped,
        items: [
          Icon(FluentIcons.people_32_regular, color: Colors.white,),
          Icon(FluentIcons.compass_northwest_24_filled,color: Colors.white, size: 40,),
          Icon(FluentIcons.person_circle_32_regular, color: Colors.white,),
        ],
      ),
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
