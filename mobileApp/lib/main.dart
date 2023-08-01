import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:learnlign/helper/helper_fuction.dart';
import 'package:learnlign/pages/auth/Login.dart';
import 'package:learnlign/pages/homePage.dart';
import 'package:learnlign/pages/shared/constants.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedIn();
  }

  getUserLoggedIn() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) => {
      if(value!=null){
        _isSignedIn = value
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Constants().primaryColor,
            scaffoldBackgroundColor: Colors.white),
        debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: _isSignedIn ? const HomePage() :const Login()
    );
  }
}


