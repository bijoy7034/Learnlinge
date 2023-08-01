import 'package:flutter/material.dart';
import 'package:learnlign/pages/Rooms.dart';
import 'package:learnlign/pages/explore.dart';
import 'package:learnlign/pages/profile.dart';

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
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.3,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        iconSize: 30,
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.blueAccent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.groups,),
            label: 'Rooms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore, size: 50,),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
