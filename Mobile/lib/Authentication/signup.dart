import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:learnlinge/Authentication/login.dart';
import 'package:http/http.dart' as http;
class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {


  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String err_msg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100,),
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
                        controller: _nameController,
                        style: const TextStyle(
                          color: Colors.white, // Set the desired text color
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[900],
                          labelText: "Fullname",
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10), // Adjust the vertical padding
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromRGBO(88, 101, 242, 0.9)),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          labelStyle: const TextStyle(color: Colors.white60),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a value';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: _usernameController,
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
                      SizedBox(height: 20,),
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
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(
                          color: Colors.white, // Set the desired text color
                        ),
                        decoration: InputDecoration(filled: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                            fillColor: Colors.grey[900], labelText: "Re-enterPassword", focusedBorder: const OutlineInputBorder(
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
                      SizedBox(height: 20,),
                      Container(
                        color: Color.fromRGBO(88, 101, 242, 0.9) ,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(88, 101, 242, 0.9))
                          ),
                          onPressed: authenticateUser,
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Text("Create Account", style: TextStyle(color: Colors.white,
                                fontFamily: 'Quicksand', fontWeight: FontWeight.bold,
                                fontSize: 16),),
                          ),

                        ),
                      ) ,
                      SizedBox(height: 30,),
                      Text('Or', style: TextStyle(color: Colors.white),),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already a user? ', style: TextStyle(color: Colors.white ,
                              fontSize: 14),),
                          InkWell(
                            onTap:(){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Login()));
                            },
                            child: Text('Login',
                              style: TextStyle(color:Color.fromRGBO(88, 101, 242, 0.9),
                                  fontSize: 15  ),),
                          )
                        ],
                      ),
                      SizedBox(height: 20,),

                      SizedBox(height: 80,),

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
  void authenticateUser() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String name = _passwordController.text;

    const url = 'http://localhost:5500/api/users/create'; // Replace with your API endpoint
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, String> body = {
      'name':name,
      'email': username,
      'password': password,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
    String jsonResponse = response.body;

// Parse the JSON string into a Map object
    Map<String, dynamic> jsonMap = jsonDecode(jsonResponse);

// Extract the 'username' field from the Map

    if (response.statusCode == 200) {
      err_msg =' ';
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      setState(() {
        err_msg = 'Login Error';
      });
    }

  }


  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
