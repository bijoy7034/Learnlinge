import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnlign/pages/Rooms.dart';
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

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Group Info", style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Exit"),
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
                backgroundColor: Colors.green.shade200,
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
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Text('Members', style: TextStyle(fontSize: 20, fontFamily: 'Quicksand', fontWeight: FontWeight.bold, color: Colors.blueAccent),),
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
                  return Container(
                    padding:
                    const EdgeInsets.symmetric( vertical: 1),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              getName(snapshot.data['members'][index])
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          trailing:  PopupMenuButton(
                              icon: Icon(Icons.more_vert, color: Colors.black54,),
                              color : Colors.white,
                              itemBuilder: (context)=> [
                                PopupMenuItem(
                                    child: Text('Details',
                                      style: TextStyle(color: Colors.black, fontFamily: 'Quicksand'),)),
                                PopupMenuItem(
                                    child: Text('Block',
                                      style: TextStyle(color: Colors.black, fontFamily: 'Quicksand'),))
                              ]),
                          title: Text(getName(snapshot.data['members'][index]), style: TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.bold),),
                          // subtitle: Text(getId(snapshot.data['members'][index])),
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
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ));
        }
      },
    );
  }
}