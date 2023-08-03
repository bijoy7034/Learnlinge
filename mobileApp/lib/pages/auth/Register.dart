import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:learnlign/pages/auth/Login.dart';
import 'package:learnlign/pages/homePage.dart';
import '../../service/auth_services.dart';
import '../../helper/helper_fuction.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  AuthService authService = AuthService();
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade300,
      body:_isLoading
          ? Center(
          child: SpinKitFoldingCube(   // Replace SpinKitCircle with any other available spinner
            color: Colors.amber,  // Set the color of the spinner
            size: 100.0,          // Set the size of the spinner
          ),)
          : Container(
        decoration: BoxDecoration(
          color: Colors.black),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 350,
                child: Center(
                  child: Container(
                      width: 200,
                      child: SvgPicture.asset(
                        'Assets/undraw_authentication_re_svpt.svg',
                        semanticsLabel: 'My SVG Image',
                        width: 400,
                      ),
                  ),
                ),),
              Container(
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
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.amber.shade300,
                                fontSize: 30,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 30,),
                          TextFormField(
                            controller: _nameController,
                            style: const TextStyle(
                              color: Colors.white, // Set the desired text color
                            ),
                            decoration: InputDecoration(filled: true,
                                prefixIcon: Icon(Icons.person),
                                prefixIconColor: Colors.white70,

                                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15,),
                                fillColor: Colors.grey.shade800, labelText: "Name",
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


                            onChanged: (val) {
                              setState(() {
                                fullName = val;
                              });
                            },
                            validator: (val) {
                              if (val!.isNotEmpty) {
                                return null;
                              } else {
                                return "Name cannot be empty";
                              }
                            },
                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: _usernameController,
                            style: const TextStyle(
                                color: Colors.white,//ext color
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

                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },

                            // check tha validation
                            validator: (val) {
                              return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)
                                  ? null
                                  : "Please enter a valid email";
                            },
                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                            style: const TextStyle(
                              color: Colors.white, // Set the desired text color
                            ),
                            decoration: InputDecoration(filled: true,
                                prefixIcon: Icon(Icons.key),
                                prefixIconColor: Colors.white70,

                                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15,),
                                fillColor: Colors.grey.shade800, labelText: "Pasword",
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
                              if (val!.length < 6) {
                                return "Password must be at least 6 characters";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(
                                color: Colors.white, // Set the desired text color
                            ),
                            decoration: InputDecoration(filled: true,
                                prefixIcon: Icon(Icons.password_outlined),
                                prefixIconColor: Colors.white70,

                                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15,),
                                fillColor: Colors.grey.shade800, labelText: "Re-enter password",
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
                          SizedBox(height: 20,),
                          Container(
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: register,
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
                                    'Create Account',
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
                          SizedBox(height: 30,),
                          Text('Or', style: TextStyle(color: Colors.white70),),
                          SizedBox(height: 30,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already a user? ', style: TextStyle(color: Colors.white70 ,
                                  fontSize: 14),),
                              InkWell(
                                onTap:(){
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => Login()));
                                },
                                child: Text('Login',
                                  style: TextStyle(color:Colors.amber.shade300,
                                      fontSize: 15  ),),
                              )
                            ],
                          ),
                          SizedBox(height: 20,),

                          SizedBox(height: 40,),

                        ],
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
  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          // saving the shared preference state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Account Created',
                style: const TextStyle(fontSize: 14),
              ),
              backgroundColor: Colors.green,
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
