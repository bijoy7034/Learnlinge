import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:learnlign/pages/auth/Register.dart';
import 'package:learnlign/pages/homePage.dart';
import 'package:learnlign/service/auth_services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../helper/helper_fuction.dart';
import '../../service/database_services.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:_isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElasticIn(
              child: SpinKitWaveSpinner(// Replace SpinKitCircle with any other available spinner
                color: Colors.amber,  // Set the color of the spinner
                size: 100.0,          // Set the size of the spinner
              ),
            ),
            Padding(padding: EdgeInsets.all(18)),
            ElasticIn(child: Text('Welcome back!!', style: TextStyle(color: Colors.white, fontFamily: 'Quicksand', fontWeight: FontWeight.bold),))
          ],
        ),
      )
          :
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black], // Replace with your desired colors
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // color: Color.fromRGBO(94,148,255, 0.9),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 340,
                child: Center(
                  child: Container(
                      child: SvgPicture.asset(
                        'Assets/undraw_personal_info_re_ur1n.svg',
                        semanticsLabel: 'My SVG Image',
                        width: 300,
                      ),),
                ),),
              SlideInUp(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(70.0),
                      topRight: Radius.circular(70.0),
                    ),
                  ),

                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(49.0),
                      child: Container(
                        child:Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.amber.shade300,
                                    fontSize: 38,
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.w900),
                              ),
                              SizedBox(height: 30,),
                              TextFormField(
                                style: const TextStyle(
                                  color: Colors.white, // Set the desired text color
                                ),
                                decoration: InputDecoration(filled: true,
                                    prefixIcon: Icon(Icons.mail),
                                    prefixIconColor: Colors.white70,

                                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15,),
                                    fillColor: Colors.grey.shade800, labelText: "Email",
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey.shade800),
                                      borderRadius: BorderRadius.circular(20.0), // Set the same border radius here
                                    ), focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide(color: Colors.amber),
                                    ), border:  OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide(color: Colors.orange),
                                    ), labelStyle: TextStyle(color: Colors.white70,  fontFamily: 'Quicksand', fontWeight: FontWeight.bold)),
                                validator: (val) {
                                  return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                      ? null
                                      : "Please enter a valid email";
                                },
                                onChanged: (val) {
                                  setState(() {
                                    email = val;
                                  });
                                },

                              ),
                              SizedBox(height: 30,),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                style: const TextStyle(
                                  color: Colors.white, // Set the desired text color
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.key),
                                    prefixIconColor: Colors.white,
                                    filled: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15,),
                                    fillColor: Colors.grey.shade800, labelText: "Password",
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey.shade800),
                                      borderRadius: BorderRadius.circular(20.0), // Set the same border radius here
                                    ), focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide(color: Colors.amber),
                                    ), border:  OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide(color: Colors.orange),
                                    ), labelStyle: TextStyle(color: Colors.white70, fontFamily: 'Quicksand', fontWeight: FontWeight.bold)),
                                validator: (val) {
                                  if (val!.length < 6) {
                                    return "Password must be at least 6 characters";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (val) {
                                  setState(() {
                                    password = val;
                                  });
                                },
                              ),
                              SizedBox(height: 30,),
                              Container(
                                width: double.infinity,
                                child: GestureDetector(
                                  onTap: login,
                                  child: Container(
                                    width: 200, // Set the desired width of the button
                                    height: 50, // Set the desired height of the button
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.amber, Colors.amber.shade300], // Replace with your desired gradient colors
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(25), // Set the desired border radius
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                          fontFamily: 'Quicksand',
                                          color: Colors.white, // Set the text color
                                          fontSize: 16, // Set the font size
                                          fontWeight: FontWeight.bold, // Set the font weight
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ) ,
                              SizedBox(height: 20,),
                              const Text('Or', style: TextStyle(color: Colors.white70),),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Not a user? ', style: TextStyle(color: Colors.white70 ,
                                      fontSize: 14),),
                                  InkWell(
                                    onTap:(){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => RegisterPage()));

                                    },
                                    child: Text('Create Account',
                                      style: TextStyle(color:Colors.amber.shade300,
                                          fontSize: 15  ),),
                                  )
                                ],
                              ),
                              SizedBox(height: 20,),

                              SizedBox(height: 140,),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserNameandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
          await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .gettingUserData(email);
          // saving the values to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${value}',
                style: const TextStyle(fontSize: 14),
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: "OK",
                onPressed: () {},
                textColor: Colors.white,
              ),
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
