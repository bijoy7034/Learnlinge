import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:learnlign/pages/homePage.dart';

import '../service/database_services.dart';
import '../widgets/widgets.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  const GroupInfo(
      {Key? key,
        required this.adminName,
        required this.groupName,
        required this.groupId})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  @override
  void initState() {
    getMembers();
    super.initState();
  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  Future<bool> isConnectionRequestSent(String targetUserId) async {
    final currentUserDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(targetUserId)
        .get();

    if (currentUserDoc.exists) {
      final pendingRequests =
      currentUserDoc.data()?['pendingRequests'] as List<dynamic>;
      return pendingRequests.contains(FirebaseAuth.instance.currentUser!.uid) ;
    }
    return false;
  }
  Future<bool> isConnected(String targetUserId) async {
    final currentUserDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(targetUserId)
        .get();

    if (currentUserDoc.exists) {
      final pendingRequests =
      currentUserDoc.data()?['connections'] as List<dynamic>;
      return pendingRequests.contains(FirebaseAuth.instance.currentUser!.uid) ;
    }
    return false;
  }

  Future<void> sendConnectionRequest(String currentUserId, String targetUserId) async {
    await FirebaseFirestore.instance.collection('users').doc(targetUserId).update({
      'pendingRequests': FieldValue.arrayUnion([currentUserId]),
    });
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        //title: Text("Group Info", style: TextStyle(fontFamily: 'Quicksand',color: Colors.amber.shade300, fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder( // Set the shape for rounded corners
                          borderRadius: BorderRadius.circular(10),
                        ),
                        title:  Text("Exit", style: TextStyle(color: Colors.amber.shade300),),
                        content:
                        const Text("Are you sure you exit the group? "),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              DatabaseService(
                                  uid: FirebaseAuth
                                      .instance.currentUser!.uid)
                                  .toggleGroupJoin(
                                  widget.groupId,
                                  getName(widget.adminName),
                                  widget.groupName)
                                  .whenComplete(() {
                                nextScreenReplace(context, const HomePage());
                              });
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 150,
          child:  Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.amber.shade300,
                child: Text(
                  widget.groupName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.white, fontSize: 29,),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10,),
                  Text(
                    "${widget.groupName}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white,fontFamily: 'Quicksand',),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("Admin: ${getName(widget.adminName)}", style: TextStyle(color: Colors.white70),)
                ],
              )
            ],
          ),),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Text('Members', style: TextStyle(fontSize: 20, fontFamily: 'Quicksand', fontWeight: FontWeight.bold, color: Colors.white70),),
                  memberList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  memberList() {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final memberId = snapshot.data['members'][index];
                  return FutureBuilder<bool>(
                    future: isConnectionRequestSent(getId(memberId)),
                    builder: (context, AsyncSnapshot<bool> connectedSnapshot) {
                      if (connectedSnapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      } else if (connectedSnapshot.hasData) {
                        final bool connected = connectedSnapshot.data!;
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          child: Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Theme.of(context).primaryColor,
                                  child: Text(
                                    getName(memberId)
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                trailing: PopupMenuButton(
                                  icon: Icon(Icons.more_vert, color: Colors.white,),
                                  color : Colors.grey.shade800,
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: Text(
                                        'Details',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Quicksand',
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      enabled: !connected,
                                      onTap: () {
                                        if (!connected) {
                                          sendConnectionRequest(
                                            FirebaseAuth.instance.currentUser!.uid,
                                            getId(memberId),
                                          );
                                        }
                                      },
                                      child: Text(
                                        connected ? 'Request Send' : 'Connect',
                                        style: TextStyle(
                                          color: connected? Colors.white54: Colors.white,
                                          fontFamily: 'Quicksand',
                                        ),
                                      ),
                                    ),
// ... Other popup menu items ...
                                  ],
                                ),
                                title: Text(
                                  getName(memberId),
                                  style: TextStyle(
                                    fontFamily: 'Quicksand',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 28.0, right: 28),
                                child: Divider(
                                  thickness: 0.5,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                },
              );
            } else {
              return const Center(
                child: Text("NO MEMBERS"),
              );
            }
          } else {
            return const Center(
              child: Text("NO MEMBERS"),
            );
          }
        } else {
          return Center(
              child: SpinKitFoldingCube(   // Replace SpinKitCircle with any other available spinner
                color: Colors.amber,  // Set the color of the spinner
                size: 50.0,          // Set the size of the spinner
              ),);
        }
      },
    );
  }
}