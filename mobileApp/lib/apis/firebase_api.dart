import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseApi {
  final firebasseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async{
    await firebasseMessaging.requestPermission();
    final fCMToken = await firebasseMessaging.getToken();
    print("Token : ${fCMToken}");
  }
}