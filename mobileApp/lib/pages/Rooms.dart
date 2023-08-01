import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:learnlign/pages/search_page.dart';

import '../helper/helper_fuction.dart';
import '../service/database_services.dart';
import '../widgets/group_tile.dart';
import '../widgets/widgets.dart';

class Rooms extends StatefulWidget {
  const Rooms({super.key});

  @override
  State<Rooms> createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  bool _isSearching = true;
  String userName = "";
  String email = "";
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";
  String desc = "";
  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
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
      });
    });
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }



  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearching ? _buildDefaultAppBar() :_buildSearchAppBar() ,

      drawer: Drawer(
        backgroundColor: Colors.grey[900],
      ),




      //body


      body:grouplist(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            popUpDialog(context);
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),

    );
  }
  AppBar _buildDefaultAppBar() {
    return AppBar(
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.white, // Set the color of the drawer icon
      ),
      actions: [
        IconButton(onPressed: () {
            nextScreen(context, const SearchPage());
        }, icon: Icon(Icons.search)),

      ],
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
          "Chats",
          style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
  AppBar _buildSearchAppBar() {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      iconTheme: IconThemeData(
        color: Colors.white, // Set the color of the drawer icon
      ),
      title: TextField(
        style: const TextStyle(
          color: Colors.white, // Set the desired text color
        ),
        decoration: InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54, fontFamily: 'Quicksand')
        ),
        onChanged: (value) {
          // Handle the search query here
          // You can use the value parameter to get the current search query text.
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            _toggleSearch(); // Toggle the search state to go back to the default app bar
          },
        ),
      ],
    );
  }

  grouplist() {
    return StreamBuilder(
    stream: groups,
    builder: (context, AsyncSnapshot snapshot) {
      // make some checks
      if (snapshot.hasData) {
        if (snapshot.data['groups'] != null) {
          if (snapshot.data['groups'].length != 0) {
            return ListView.builder(
              itemCount: snapshot.data['groups'].length,
              itemBuilder: (context, index) {
                int reverseIndex = snapshot.data['groups'].length - index - 1;
                return GroupTile(
                    groupId: getId(snapshot.data['groups'][reverseIndex]),
                    groupName: getName(snapshot.data['groups'][reverseIndex]),
                    userName: snapshot.data['fullName']);
              },
            );
          } else {
            return noGroupWidget();
          }
        } else {
          return noGroupWidget();
        }
      } else {
        return Center(
          child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor),
        );
      }
    },
     );
  }

  popUpDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        builder: (context) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 8,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              height: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          // Close the popup when the close icon is pressed
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  Text('Add Room', style: TextStyle(color: Colors.blueAccent, fontFamily: "Quicksand", fontWeight: FontWeight.bold, fontSize: 20),),
                  _isLoading == true
                      ? Center(
                    child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor),
                  )
                      : Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextField(
                    onChanged: (val) {
                        setState(() {
                          groupName = val;
                        });
                    },
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(filled: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15,),
                          fillColor: Color.fromRGBO(233, 230, 244,0.9), labelText: "Name",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.circular(10.0), // Set the same border radius here
                          ), focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color.fromRGBO(88, 101, 242, 0.9)),
                          ), border:  OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.orange),
                          ), labelStyle: TextStyle(color: Colors.grey.shade700,  fontFamily: 'Quicksand', fontWeight: FontWeight.bold)),
                  ),
                      ),
                  const SizedBox(height: 3,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Description', style: TextStyle(color: Colors.black54),),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2,),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          desc = val;
                        });
                      },
                      maxLines: 4,
                      style: const TextStyle(
                        color: Colors.black, // Set the desired text color
                      ),
                      decoration: InputDecoration(filled: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15,),
                          fillColor: Color.fromRGBO(233, 230, 244,0.9),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.circular(10.0), // Set the same border radius here
                          ), focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color.fromRGBO(88, 101, 242, 0.9)),
                          ), border:  OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.orange),
                          ), labelStyle: TextStyle(color: Colors.grey.shade700,  fontFamily: 'Quicksand', fontWeight: FontWeight.bold)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a vale';
                        }
                        return null;
                      },
                    ),
                  ),
                  Text('*You can provide a description about your room', style: TextStyle(color: Colors.black54),),
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ElevatedButton(
                      //   onPressed: () {
                      //     Navigator.of(context).pop();
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //       primary: Theme.of(context).primaryColor),
                      //   child: const Text("CANCEL"),
                      // ),
                      ElevatedButton(
                        onPressed: () async {
                          if (groupName != "") {
                            setState(() {
                              _isLoading = true;
                            });
                            DatabaseService(
                                uid: FirebaseAuth.instance.currentUser!.uid)
                                .createGroup(userName,
                                FirebaseAuth.instance.currentUser!.uid, groupName,desc)
                                .whenComplete(() {
                              _isLoading = false;
                            });
                            Navigator.of(context).pop();
                            showSnackbar(
                                context, Colors.green, "Group created successfully.");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                        child: const Text("CREATE"),
                      )
                    ],
                  )
                ],
              ),
            );
        });
  }
  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
