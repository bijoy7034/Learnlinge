import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:learnlign/pages/personal_chat.dart';
import 'package:learnlign/pages/search_page.dart';
import '../helper/helper_fuction.dart';
import '../service/database_services.dart';
import '../widgets/group_tile.dart';
import '../widgets/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Rooms extends StatefulWidget {
  const Rooms({super.key});

  @override
  State<Rooms> createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSearching = true;
  String userName = "";
  String email = "";
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";
  String desc = "";
  late FirebaseAuth _auth;
  late FirebaseFirestore _firestore;
  late User _currentUser;
  List<Map<String, dynamic>> _connectedUsers = []; // List of connected user details

  @override
  void initState() {
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    _currentUser = _auth.currentUser!;
    _fetchConnections();
    gettingUserData();
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  Future<void> _fetchConnections() async {
    // Fetch the user's connection list from Firestore
    DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(_currentUser.uid).get();
    List<dynamic> connectionUIDs = userSnapshot['connections'];

    // Fetch details of connected users
    List<Future<DocumentSnapshot>> userFutures = connectionUIDs.map((uid) => _firestore.collection('users').doc(uid).get()).toList();
    List<DocumentSnapshot> userSnapshots = await Future.wait(userFutures);

    // Store connected user details
    _connectedUsers = userSnapshots.map((snapshot) => snapshot.data() as Map<String, dynamic>).toList();

    setState(() {});
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

  //connections


  Stream<List<String>> getConnectedUsers() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return (snapshot.data()?['connections'] as List<dynamic>)
            .cast<String>();
      } else {
        return [];
      }
    });
  }



  //request handiling
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<String> getUserName(String userId) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (userDoc.exists) {
      return userDoc.data()?['fullName'] ?? '';
    } else {
      return '';
    }
  }


  Stream<List<String>> getPendingRequests() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return (snapshot.data()?['pendingRequests'] as List<dynamic>)
            .cast<String>();
      } else {
        return [];
      }
    });
  }

  Future<void> acceptRequest(String senderUserId) async {
    final currentUserRef =
    FirebaseFirestore.instance.collection('users').doc(userId);
    final senderUserRef =
    FirebaseFirestore.instance.collection('users').doc(senderUserId);

    final currentUserDoc = await currentUserRef.get();
    final senderUserDoc = await senderUserRef.get();

    if (currentUserDoc.exists && senderUserDoc.exists) {
      final currentUserConnections =
      currentUserDoc.data()?['connections'] as List<dynamic>;
      final senderConnections =
      senderUserDoc.data()?['connections'] as List<dynamic>;

      // Add the sender's ID to the current user's connections list
      if (!currentUserConnections.contains(senderUserId)) {
        currentUserConnections.add(senderUserId);
      }

      // Add the current user's ID to the sender's connections list
      if (!senderConnections.contains(userId)) {
        senderConnections.add(userId);
      }

      // Update the current user's connections list
      await currentUserRef.update({
        'connections': currentUserConnections,
        'pendingRequests': FieldValue.arrayRemove([senderUserId]),
      });

      // Update the sender's connections list
      await senderUserRef.update({
        'connections': senderConnections,
      });

      // You may also show a snackbar or toast to indicate that the request was accepted.
    }
  }

  Future<void> removeConnection(String targetUserId) async {
    final currentUserRef =
    FirebaseFirestore.instance.collection('users').doc(userId);
    final targetUserRef =
    FirebaseFirestore.instance.collection('users').doc(targetUserId);

    final currentUserDoc = await currentUserRef.get();
    final targetUserDoc = await targetUserRef.get();

    if (currentUserDoc.exists && targetUserDoc.exists) {
      final currentUserConnections =
      currentUserDoc.data()?['connections'] as List<dynamic>;
      final targetUserConnections =
      targetUserDoc.data()?['connections'] as List<dynamic>;

      // Remove the target user's ID from the current user's connections list
      if (currentUserConnections.contains(targetUserId)) {
        currentUserConnections.remove(targetUserId);
      }

      // Remove the current user's ID from the target user's connections list
      if (targetUserConnections.contains(userId)) {
        targetUserConnections.remove(userId);
      }

      // Update the current user's connections list
      await currentUserRef.update({
        'connections': currentUserConnections,
      });

      // Update the target user's connections list
      await targetUserRef.update({
        'connections': targetUserConnections,
      });

      // You may also show a snackbar or toast to indicate that the connection was removed.
    }
  }



  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _isSearching ? _buildDefaultAppBar() :_buildSearchAppBar() ,

      drawer: Drawer(
        backgroundColor: Color.fromRGBO(27, 28, 28, 1),
        child: Column(
          children: [
            SizedBox(height: 60,),
            Text('LearnLinge', style: TextStyle(color: Colors.amber.shade400, fontFamily: 'Quicksand', fontWeight: FontWeight.bold, fontSize: 30),),
            Text('A Learning Community', style: TextStyle(color: Colors.white70, fontFamily: 'Quicksand', fontWeight: FontWeight.bold, fontSize: 10) ,),
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: ListTile(
                  leading: Icon(Icons.settings, color: Colors.white,),
                 title: Text ('Settings', style: TextStyle(color: Colors.white, fontFamily: 'Quicksand', fontWeight: FontWeight.bold),),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.amber.shade400,),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: ListTile(
                  leading: Icon(Icons.info, color: Colors.white,),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.amber.shade400,),
                  title: Text ('About', style: TextStyle(color: Colors.white, fontFamily: 'Quicksand', fontWeight: FontWeight.bold),),
                ),
              ),
            ),
            Spacer(),
            Container(
              child: SvgPicture.asset(
                'Assets/undraw_scrum_board_re_wk7v.svg',
                width: 220,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Copyrigth 2023 @ LearnLinge', style: TextStyle(color: Colors.white70),),
            ),
            SizedBox(height: 60,)
          ],
        ),
      ),

      body:SlideInUp(
        duration: Duration(milliseconds: 400),
        child: Container(
          decoration: BoxDecoration(
            color:Color.fromRGBO(27, 28, 28, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 28.0, right: 28),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: TabBar(
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Colors.amber.shade400),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white,
                      controller: _tabController,
                      tabs: const [
                        Tab(
                          child: Row(
                            children: [
                              Icon(FluentIcons.people_12_filled, size: 23,),
                              SizedBox(width: 5,),
                              Text('Rooms', style: TextStyle(color: Colors.white, fontFamily: 'Quicksand' , fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            children: [
                              Icon(FluentIcons.chat_12_filled, size: 23,),
                              SizedBox(width: 5,),
                              Text('Chats', style: TextStyle(color: Colors.white, fontFamily: 'Quicksand', fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            children: [
                              Icon(FluentIcons.branch_request_20_filled, size: 23,),
                              SizedBox(width: 3,),
                              Text('Requests', style: TextStyle(color: Colors.white, fontFamily: 'Quicksand', fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children:  [
                      grouplist(),
                      connectionlist(),
                      pendingList()
                    ],
                  ),
                ),
              ],
            ),
          )
        ),
      ),
        floatingActionButton: FadeIn(
          delay: Duration(milliseconds: 700),
          child: FloatingActionButton(
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
        ),

    );
  }
  AppBar _buildDefaultAppBar() {
    return AppBar(
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(
              FluentIcons.list_28_filled
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.white, // Set the color of the drawer icon
      ),
      actions: [
        IconButton(onPressed: () {
            nextScreen(context, const SearchPage());
        }, icon: Icon(Icons.search)),

      ],
      backgroundColor: Colors.black,
      title: ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: const [Colors.white, Colors.white],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds);
        },
        child:Text(
          "Rooms",
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

  pendingList(){
    return StreamBuilder<List<String>>(
      stream: getPendingRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        List<String> pendingRequests = snapshot.data ?? [];

        if (pendingRequests.isEmpty) {
          return Center(child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'Assets/undraw_begin_chat_re_v0lw.svg',
                semanticsLabel: 'My SVG Image',
                width: 200,
              ),
              SizedBox(height: 15,),
              Text('No requests', style: TextStyle(color: Colors.white, fontFamily: 'Quicksand', fontWeight: FontWeight.bold),)
            ],
          ),);
        }

        return ListView.builder(

          itemCount: pendingRequests.length,
          itemBuilder: (context, index) {
            String senderUserId = pendingRequests[index];

            return FutureBuilder<String>(
              future: getUserName(senderUserId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.amber,),
                  );
                }

                String userName = snapshot.data ?? '';

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        userName
                            .substring(0, 1)
                            .toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text('$userName', style: TextStyle(fontFamily: 'Quicksand',color: Colors.white, fontWeight: FontWeight.bold),),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () {
                            acceptRequest(senderUserId);
                          },
                          child: Text('Accept', style: TextStyle(color: Colors.amber),),
                        ),
                        TextButton(
                          onPressed: () {
                            // Implement a function to reject the request if needed.
                            // For example: rejectRequest(senderUserId);
                          },
                          child: Text('Reject',style: TextStyle(color: Colors.redAccent)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  connectionlist(){
    return _connectedUsers.length == 0 ?
    Center(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'Assets/undraw_respond_re_iph2.svg',
                    semanticsLabel: 'My SVG Image',
                    width: 250,
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.only(left: 32, right: 32),
                    child: Text('No chats and no connections ! \n You can connect people within your rooms', style: TextStyle(color: Colors.white70, fontFamily: 'Quicksand', fontWeight: FontWeight.bold,), textAlign: TextAlign.center,),
                  )
                ],
              ),)
        :
      ListView.builder(
      itemCount: _connectedUsers.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> user = _connectedUsers[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                onTap: (){
                  nextScreen(context, OneToOneChatScreen(receiverId: user['uid'], receiverName: user['fullName'], userName: FirebaseAuth.instance.currentUser!.uid, pic: user['profilePic'], ));
                },
                title: Text(user['fullName'], style: TextStyle(fontFamily: 'Quicksand',color: Colors.white, fontWeight: FontWeight.bold),),
                trailing:  PopupMenuButton(
                    icon: Icon(Icons.more_vert, color: Colors.white,),
                    color : Colors.grey.shade800,
                    itemBuilder: (context)=> [
                      PopupMenuItem(
                          child: Text('Details',
                            style: TextStyle(color: Colors.white, fontFamily: 'Quicksand'),)),
                      PopupMenuItem(
                          onTap: (){
                            removeConnection(user['uid']);
                          },
                          child: Text('Remove',
                            style: TextStyle(color: Colors.white, fontFamily: 'Quicksand'),)),

                      PopupMenuItem(
                          child: Text('Block',
                            style: TextStyle(color: Colors.white, fontFamily: 'Quicksand'),))
                    ]),

                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey.shade800,
                  backgroundImage: NetworkImage(user['profilePic']),
                ),
              ),
              SizedBox(height: 2,),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Divider(color: Colors.amber.shade400,thickness: 0.1,),
              )
            ],
          ),
        );
      },
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
                return Slidable(
                  startActionPane: ActionPane(
                    motion: const StretchMotion() ,
                    children: [
                      SlidableAction(
                        onPressed: _removegroup(),
                        backgroundColor: Colors.redAccent,
                        icon: Icons.delete_outline,
                      ),
                      SlidableAction(
                        onPressed: _removegroup(),
                        backgroundColor: Colors.amber.shade400,
                        icon: Icons.notifications_off_rounded,
                      )
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: _removegroup(),
                        backgroundColor: Colors.green.shade400,
                        icon: Icons.archive,
                      )
                    ],
                  ),
                  child: GroupTile(
                      groupId: getId(snapshot.data['groups'][reverseIndex]),
                      groupName: getName(snapshot.data['groups'][reverseIndex]),
                      userName: snapshot.data['fullName']),
                );
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
          child: SpinKitFoldingCube(   // Replace SpinKitCircle with any other available spinner
            color: Colors.amber,  // Set the color of the spinner
            size: 50.0,          // Set the size of the spinner
          ),
        );
      }
    },
     );
  }

  popUpDialog(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.grey.shade900,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder( // Set the shape for rounded corners
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(35.0), // Customize the radius as needed
          ),
        ),
        builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white70,),
                        onPressed: () {
                          // Close the popup when the close icon is pressed
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  Text('Add Room', style: TextStyle(color: Colors.amber.shade300, fontFamily: "Quicksand", fontWeight: FontWeight.bold, fontSize: 20),),
                  Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextField(
                    onChanged: (val) {
                        setState(() {
                          groupName = val;
                        });
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(filled: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15,),
                          fillColor: Colors.grey.shade800, labelText: "Name",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade800),
                            borderRadius: BorderRadius.circular(10.0), // Set the same border radius here
                          ), focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.amber),
                          ), border:  OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.orange),
                          ), labelStyle: TextStyle(color: Colors.white70,  fontFamily: 'Quicksand', fontWeight: FontWeight.bold)),
                  ),
                      ),
                  const SizedBox(height: 3,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Description', style: TextStyle(color: Colors.white70),),
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
                        color: Colors.white, // Set the desired text color
                      ),
                      decoration: InputDecoration(filled: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15,),
                          fillColor: Colors.grey.shade800,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade800),
                            borderRadius: BorderRadius.circular(10.0), // Set the same border radius here
                          ), focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.amber),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('*You can provide a description about your room', style: TextStyle(color: Colors.white70),),
                  ),
                  SizedBox(height: 30,),
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
                        SizedBox(
                          width: 300,
                          child: ElevatedButton(
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
                              elevation: 0,
                                shape: RoundedRectangleBorder( // Set the shape for rounded corners
                                  borderRadius: BorderRadius.circular(20.0), // Customize the radius as needed
                                ),
                                primary: Theme.of(context).primaryColor),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: const Text("CREATE"),
                            ),
                          ),
                        ),

                    ],
                  ),
                  SizedBox(height: 50,)
                ],
              ),
            );
        });

  }
  noGroupWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 400,
              child: SvgPicture.asset(
                'Assets/undraw_book_lover_re_rwjy.svg',
                semanticsLabel: 'My SVG Image',
                width: 200,
              ),
          ),
          SizedBox(height: 20,),
          Text('No Rooms Joined', style: TextStyle(color: Colors.white70, fontFamily: 'Quicksand', fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }

  _removegroup() {}
}
