import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(88, 101, 242, 0.13),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                          fillColor: Colors.grey[850], labelText: "Email", focusedBorder: const OutlineInputBorder(
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
                          fillColor: Colors.grey[850], labelText: "Password", focusedBorder: const OutlineInputBorder(
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
                        onPressed: () {  },
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
                            fontSize: 18),),
                        InkWell(
                          onTap: (){},
                          child: Text('Create Account',
                            style: TextStyle(color:Color.fromRGBO(88, 101, 242, 0.9),
                                fontSize: 18  ),),
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
    );
  }
}


//rgba(30, 42, 26, 0.8)
//rgba(44, 108, 23, 0.8)
