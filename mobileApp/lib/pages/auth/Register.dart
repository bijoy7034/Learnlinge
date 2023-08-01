import 'package:flutter/material.dart';
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
      body:_isLoading
          ? Center(
          child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor))
          : Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.blueAccent], // Replace with your desired colors
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 300,
                child: Center(
                  child: Container(
                      width: 200,
                      child: Image.asset('Assets/—Pngtree—pile of books 3d icon_7457105.png')),
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
                    child: Form(
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
                              "Sign Up",
                              style: TextStyle(
                                  color: Color.fromRGBO(88, 101, 242, 0.9),
                                  fontSize: 30,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 30,),
                          TextFormField(
                            controller: _nameController,
                            style: const TextStyle(
                              color: Colors.black54, // Set the desired text color
                            ),
                            decoration: InputDecoration(filled: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15,),
                                fillColor: Color.fromRGBO(233, 230, 244,0.9), labelText: "Name",
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
                              color: Colors.black54, // Set the desired text color
                            ),
                            decoration: InputDecoration(filled: true,
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
                                ), labelStyle: TextStyle(color: Colors.grey.shade700, fontFamily: 'Quicksand', fontWeight: FontWeight.bold)),

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
                            obscureText: true,
                            style: const TextStyle(
                              color: Colors.black54, // Set the desired text color
                            ),
                            decoration: InputDecoration(filled: true,
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
                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(
                              color: Colors.black54, // Set the desired text color
                            ),
                            decoration: InputDecoration(filled: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15,),
                                fillColor: Color.fromRGBO(233, 230, 244,0.9), labelText: "Re-enter password",
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
                                    colors: [Colors.blue, Color.fromRGBO(88, 101, 242, 0.9)], // Replace with your desired gradient colors
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
                          Text('Or', style: TextStyle(color: Colors.black54),),
                          SizedBox(height: 30,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already a user? ', style: TextStyle(color: Colors.black54 ,
                                  fontSize: 14),),
                              InkWell(
                                onTap:(){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Login()));
                                },
                                child: Text('Login',
                                  style: TextStyle(color:Colors.blueAccent,
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
