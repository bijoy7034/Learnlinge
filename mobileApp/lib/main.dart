import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:learnlign/apis/firebase_api.dart';
import 'package:learnlign/helper/helper_fuction.dart';
import 'package:learnlign/pages/auth/Login.dart';
import 'package:learnlign/pages/homePage.dart';
import 'package:learnlign/pages/shared/constants.dart';
import 'package:page_transition/page_transition.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();
  runApp(const Splash());
}



class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
        title: 'Clean Code',
        home: AnimatedSplashScreen(
            duration: 3000,
            splash: Text('LEARNLINGE', style: TextStyle(letterSpacing: 2, color: Colors.amber.shade400, fontSize: 37, fontWeight: FontWeight.bold),),
            nextScreen: MyApp(),
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.fade,
            backgroundColor: Colors.black));
  }
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
      home: _isSignedIn ?  HomePage() :const Login()
    );
  }
}


