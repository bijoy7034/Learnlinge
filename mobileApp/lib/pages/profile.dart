
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:learnlign/pages/auth/Login.dart';
import 'package:learnlign/pages/edditPage.dart';
import 'package:learnlign/widgets/widgets.dart';

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
  late String fieldValue;
  late Stream<DocumentSnapshot> userStream;
  @override
  void initState() {
    super.initState();
    userStream = FirebaseFirestore.instance
        .collection('users') // Replace with your collection name
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    gettingUserData();
  }


  Future<void> fetchField() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users') // Replace with your collection name
          .doc(FirebaseAuth.instance.currentUser!.uid) // Replace with the document ID
          .get();

      // Get the value of the specific field
      fieldValue = snapshot.get('profilePic'); // Replace with the field name you want to fetch

      setState(() {
        _isLoading = false;
      }); // Update the UI to display the fetched value
    } catch (error) {
      print('Error fetching field: $error');
    }
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.settings)),
          IconButton(onPressed: (){}, icon: Icon(Icons.dark_mode)),
        ],
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.black,
        title: ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [Colors.white70, Colors.white],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds);
          },
          child:Row(
            children: [
              SizedBox(width: 20,),
              Text(
                  'Profile',
                style: TextStyle(color:Color.fromRGBO(88, 101, 242, 0.9), fontFamily: 'Quicksand', fontSize: 30, fontWeight: FontWeight.bold ),
                overflow: TextOverflow.clip,
              ),
            ],
          ),
        ),
      ),

      body: _isLoading ? Center(
        child: SpinKitFoldingCube(   // Replace SpinKitCircle with any other available spinner
          color: Colors.amber,  // Set the color of the spinner
          size: 50.0,          // Set the size of the spinner
        ),
      )
          : SlideInUp(
            child: SingleChildScrollView(
        child: Column(
            children: [
              SizedBox(height: 10,),
              Container(
                height: 900,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(27, 28, 28, 1),
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
                          StreamBuilder<DocumentSnapshot>(
                            stream: userStream,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return SpinKitDoubleBounce(
                                  color: Colors.amber,
                                );
                              }

                              if (!snapshot.hasData) {
                                return Text('User not found.');
                              }

                              // Access the user profile data
                              var userProfile = snapshot.data!.data() as Map<String, dynamic>;
                              var fullName = userProfile['fullName']; // Replace with the actual field name
                              var email = userProfile['email'];
                              var profilePicUrl =  userProfile['profilePic'];// Replace with the actual field name

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  profilePicUrl != null
                                      ? FadeIn(
                                        child: CircleAvatar(
                                          backgroundColor : Colors.amber,
                                          backgroundImage:
                                        NetworkImage(profilePicUrl), radius: 50,),
                                      )
                                      : Icon(Icons.account_circle),
                                  SizedBox(height: 10),
                                  Text(
                                    '$fullName',
                                    style: TextStyle(fontSize: 28, color: Colors.amber, fontFamily: 'Quicksand', fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '$email',
                                      style: TextStyle(fontSize: 15, color: Colors.white70),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),SizedBox(height: 20,),
                          Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(47, 48, 48, 1),
                              borderRadius:
                              BorderRadius.circular(20.0), // Set the border radius value
                            ),

                            child:   Padding(
                              padding: EdgeInsets.only(left :8.0, right: 8.0),
                              child: ListTile(
                                trailing: Icon(Icons.arrow_forward_ios, color: Colors.amber, size: 20,),
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
                              color:  Color.fromRGBO(47, 48, 48, 1),
                              borderRadius:
                              BorderRadius.circular(20.0), // Set the border radius value
                            ),

                            child:   Padding(
                              padding: EdgeInsets.only(left :8.0, right: 8.0),
                              child: ListTile(
                                trailing: Icon(Icons.arrow_forward_ios, color: Colors.amber, size: 20,),
                                onTap: (){
                                  nextScreen(context, EditProfilePage());
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

                              color: Color.fromRGBO(47, 48, 48, 1),
                              borderRadius:
                              BorderRadius.circular(20.0), // Set the border radius value
                            ),

                            child:  const Padding(
                              padding: EdgeInsets.only(left :8.0, right: 8.0),
                              child: ListTile(
                                trailing: Icon(Icons.arrow_forward_ios, color: Colors.amber, size: 20,),
                                contentPadding: EdgeInsets.only(left: 10, right: 10),
                                leading: Icon(Icons.dashboard, color: Colors.white,),
                                title: Text('My Posts', style: TextStyle(color:Colors.white, fontFamily: 'Quicksand', fontWeight: FontWeight.bold ),),

                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(47, 48, 48, 1),
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
                                trailing: Icon(Icons.arrow_forward_ios, color: Colors.amber, size: 20,),
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
          ),

    );
  }
}
