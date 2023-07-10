import 'package:flutter/material.dart';
import 'package:learnlinge/Screens/Explore.dart';
import 'package:learnlinge/Screens/Home.dart';
import 'package:learnlinge/Screens/Profile.dart';

class BottomNavigationWidget extends StatefulWidget {
  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _selectedIndex = 0;

  // Define your screens here
  List<Widget> _screens = [
    ChatGroup(),
    Explore(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: false,
        backgroundColor: Colors.grey[900],
        iconSize: 30,
        unselectedItemColor: Colors.white,
        selectedItemColor: Color.fromRGBO(88, 101, 242, 0.9),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.groups,),
            label: 'Chats',
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
