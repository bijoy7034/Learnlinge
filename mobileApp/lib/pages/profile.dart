import 'package:flutter/material.dart';
import 'package:learnlign/pages/auth/Login.dart';

import '../helper/helper_fuction.dart';
import '../service/auth_services.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }


  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.settings)),
          IconButton(onPressed: (){}, icon: Icon(Icons.dark_mode)),
        ],
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.blueAccent,
        title: ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [Colors.white70, Colors.white],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds);
          },
          child:Text(
            'LearnLinge',
            style: TextStyle(color:Color.fromRGBO(88, 101, 242, 0.9), fontFamily: 'Quicksand', fontSize: 30, fontWeight: FontWeight.bold ),
            overflow: TextOverflow.clip,
          ),
        ),
      ),

      body: _isLoading ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Container(
              height: 900,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        CircleAvatar(
                          radius: 35,
                          child: Image.asset('Assets/avatar_147142.png'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(userName, style: TextStyle(color: Colors.blueAccent ,fontWeight: FontWeight.bold, fontFamily: "Quicksand", fontSize: 30),),
                        ),
                        Text(email , style: TextStyle(color: Colors.black54,fontWeight : FontWeight.bold, fontSize: 15,fontFamily: "Quicksand"),),
                        SizedBox(height: 20,),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255,197,196,0.99),
                            borderRadius:
                            BorderRadius.circular(20.0), // Set the border radius value
                          ),

                          child:   Padding(
                            padding: EdgeInsets.only(left :8.0, right: 8.0),
                            child: ListTile(
                              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20,),
                              onTap: (){
                              //   Navigator.push(
                              //       context as BuildContext, MaterialPageRoute(builder: (context) => MyRooms()));
                              //
                              },
                              contentPadding: EdgeInsets.only(left: 10, right: 10),
                              leading: Icon(Icons.groups, color: Colors.white,),
                              title: Text('My Rooms', style: TextStyle(color:Colors.white, fontFamily: 'Quicksand', fontWeight: FontWeight.bold )),

                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255,221,183, 0.99),
                            borderRadius:
                            BorderRadius.circular(20.0), // Set the border radius value
                          ),

                          child:   Padding(
                            padding: EdgeInsets.only(left :8.0, right: 8.0),
                            child: ListTile(
                              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20,),
                              onTap: (){

                              },
                              contentPadding: EdgeInsets.only(left: 10, right: 10),
                              leading: Icon(Icons.edit, color: Colors.white,),
                              title: Text('Edit Profile', style: TextStyle(color:Colors.white, fontFamily: 'Quicksand', fontWeight: FontWeight.bold )),

                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          decoration: BoxDecoration(

                            color: Color.fromRGBO(187,195,247,0.99),
                            borderRadius:
                            BorderRadius.circular(20.0), // Set the border radius value
                          ),

                          child:  const Padding(
                            padding: EdgeInsets.only(left :8.0, right: 8.0),
                            child: ListTile(
                              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20,),
                              contentPadding: EdgeInsets.only(left: 10, right: 10),
                              leading: Icon(Icons.settings, color: Colors.white,),
                              title: Text('Settings', style: TextStyle(color:Colors.white, fontFamily: 'Quicksand', fontWeight: FontWeight.bold ),),

                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(203,171,254,1),
                            borderRadius:
                            BorderRadius.circular(20.0), // Set the border radius value
                          ),
                          child:  Padding(
                            padding: EdgeInsets.only(left :8.0, right: 8.0),
                            child: ListTile(
                              onTap: ()async{
                                await authService.signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => const Login()),
                                        (route) => false);
                              },
                              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20,),
                              contentPadding: EdgeInsets.only(left: 10, right: 10),
                              leading: Icon(Icons.logout, color: Colors.white,),
                              title: Text('Logout', style: TextStyle(color:Colors.white, fontFamily: 'Quicksand', fontWeight: FontWeight.bold ),),

                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
