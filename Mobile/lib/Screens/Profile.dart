import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text("LernLinge" , style: TextStyle(color: Color.fromRGBO(88, 101, 242, 0.9),
            fontSize: 30, fontFamily: 'Quicksand' , fontWeight: FontWeight.bold),),

      ),

    );;
  }
}
