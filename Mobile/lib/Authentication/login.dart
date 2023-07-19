import 'package:flutter/material.dart';
import 'package:learnlinge/Authentication/signup.dart';
import 'package:learnlinge/Screens/Navigation.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 120,),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(49.0),
                child: Container(
                  child:Column(
                    children: [
                      Text("LernLinge" , style: TextStyle(color: Color.fromRGBO(88, 101, 242, 0.9),
                          fontSize: 50, fontFamily: 'Quicksand' , fontWeight: FontWeight.bold),),
                      SizedBox(height: 30,),
                      TextFormField(
                        style: const TextStyle(
                          color: Colors.white, // Set the desired text color
                        ),
                        decoration: InputDecoration(filled: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                            fillColor: Colors.grey[900], labelText: "Email", focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color.fromRGBO(88, 101, 242, 0.9)),
                            ), border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange),
                            ), labelStyle: const TextStyle(color: Colors.white60)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a vale';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30,),
                      TextFormField(
                        obscureText: true,
                        style: const TextStyle(
                          color: Colors.white, // Set the desired text color
                        ),
                        decoration: InputDecoration(filled: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                            fillColor: Colors.grey[900], labelText: "Password", focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color.fromRGBO(88, 101, 242, 0.9)),
                            ), border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange),
                            ), labelStyle: const TextStyle(color: Colors.white60)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a vale';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30,),
                      Container(
                        color: Color.fromRGBO(88, 101, 242, 0.9) ,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(88, 101, 242, 0.9))
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 500), // Set the duration of the animation
                                pageBuilder: (_, __, ___) => BottomNavigationWidget(), // The new screen to navigate to
                                transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                                  // Define the custom animation for the transition
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Text("Login", style: TextStyle(color: Colors.white,
                                fontFamily: 'Quicksand', fontWeight: FontWeight.bold,
                                fontSize: 17),),
                          ),

                        ),
                      ) ,
                      SizedBox(height: 30,),
                      Text('Or', style: TextStyle(color: Colors.white),),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Not a user? ', style: TextStyle(color: Colors.white ,
                              fontSize: 14),),
                          InkWell(
                            onTap:(){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CreateAccount()));
                            },
                            child: Text('Create Account',
                              style: TextStyle(color:Color.fromRGBO(88, 101, 242, 0.9),
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
            )
          ],
        ),
      ),
    );
  }
}


//rgba(30, 42, 26, 0.8)
//rgba(44, 108, 23, 0.8)
