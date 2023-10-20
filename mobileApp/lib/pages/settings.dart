import 'package:animate_do/animate_do.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: FadeInRight(child: Text('Settings', style: TextStyle(color: Colors.amber, fontFamily: 'Quicksand', fontWeight: FontWeight.bold),)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: FadeInUp(
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(FluentIcons.person_32_regular, color: Colors.amber,),
                title: Text('Account Settings', style: TextStyle(color: Colors.white, fontFamily: 'Quicksand', fontWeight: FontWeight.bold),),
                onTap: () {
                  // Navigate to the profile settings screen.
                  // You can implement this navigation using Navigator.
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Divider( color: Colors.grey.shade700,),
              ),
              ListTile(
                leading: Icon(FluentIcons.shield_lock_24_regular, color: Colors.amber,),
                title: Text('Privacy Settings',  style: TextStyle(color: Colors.white, fontFamily: 'Quicksand', fontWeight: FontWeight.bold),),
                onTap: () {
                  // Navigate to the privacy settings screen.
                  // You can implement this navigation using Navigator.
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Divider( color: Colors.grey.shade700,),
              ),
              ListTile(
                leading: Icon(FluentIcons.lock_closed_20_regular, color: Colors.amber,),
                title: Text('Security Settings',  style: TextStyle(color: Colors.white, fontFamily: 'Quicksand', fontWeight: FontWeight.bold),),
                onTap: () {
                  // Navigate to the security settings screen.
                  // You can implement this navigation using Navigator.
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Divider( color: Colors.grey.shade700,),
              ),
              ListTile(
                leading: Icon(FluentIcons.alert_24_regular, color: Colors.amber,),
                title: Text('Notification Settings',  style: TextStyle(color: Colors.white, fontFamily: 'Quicksand', fontWeight: FontWeight.bold),),
                onTap: () {
                  // Navigate to the notification settings screen.
                  // You can implement this navigation using Navigator.
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Divider( color: Colors.grey.shade700,),
              ),
              ListTile(
                leading: Icon(FluentIcons.arrow_exit_20_regular, color: Colors.amber,),
                title: Text('Logout',  style: TextStyle(color: Colors.white, fontFamily: 'Quicksand', fontWeight: FontWeight.bold),),
                onTap: () {
                  // Implement the logout logic here.
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Divider( color: Colors.grey.shade700,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

