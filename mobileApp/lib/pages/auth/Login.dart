import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnlign/pages/auth/Register.dart';
import 'package:learnlign/pages/homePage.dart';
import 'package:learnlign/service/auth_services.dart';

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
      // backgroundColor: Color.fromRGBO(110, 158, 254, 0.9),
      body:_isLoading
          ? Center(
        child: CircularProgressIndicator(
            color: Colors.blueAccent),
      )
          :
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.blueAccent], // Replace with your desired colors
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
                      child: Image.asset('Assets/5293-removebg.png')),
                ),),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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
                            ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                  colors: [Colors.blueAccent, Colors.blueAccent],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(bounds);
                              },
                              child:Text(
                                "Login",
                                style: TextStyle(
                                    color: Color.fromRGBO(88, 101, 242, 0.9),
                                    fontSize: 38,
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                            SizedBox(height: 30,),
                            TextFormField(
                              style: const TextStyle(
                                color: Colors.black54, // Set the desired text color
                              ),
                              decoration: InputDecoration(filled: true,
                                  prefixIcon: Icon(Icons.mail),
                                  prefixIconColor: Colors.grey.shade700,

                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15,),
                                  fillColor: Color.fromRGBO(233, 230, 244,0.9), labelText: "Email",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white70),
                                    borderRadius: BorderRadius.circular(20.0), // Set the same border radius here
                                  ), focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(color: Color.fromRGBO(88, 101, 242, 0.9)),
                                  ), border:  OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(color: Colors.orange),
                                  ), labelStyle: TextStyle(color: Colors.grey.shade700,  fontFamily: 'Quicksand', fontWeight: FontWeight.bold)),
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
                                color: Colors.black54, // Set the desired text color
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.key),
                                  prefixIconColor: Colors.grey.shade700,
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15,),
                                  fillColor: Color.fromRGBO(233, 230, 244,0.9), labelText: "Password",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white70),
                                    borderRadius: BorderRadius.circular(20.0), // Set the same border radius here
                                  ), focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(color: Color.fromRGBO(88, 101, 242, 0.9)),
                                  ), border:  OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(color: Colors.orange),
                                  ), labelStyle: TextStyle(color: Colors.grey.shade700, fontFamily: 'Quicksand', fontWeight: FontWeight.bold)),
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
                                      colors: [Colors.blue, Color.fromRGBO(88, 101, 242, 0.9)], // Replace with your desired gradient colors
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
                            const Text('Or', style: TextStyle(color: Colors.black54),),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Not a user? ', style: TextStyle(color: Colors.black54 ,
                                    fontSize: 14),),
                                InkWell(
                                  onTap:(){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => RegisterPage()));

                                  },
                                  child: Text('Create Account',
                                    style: TextStyle(color:Colors.blueAccent,
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
