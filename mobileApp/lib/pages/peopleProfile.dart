import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnlign/pages/connectionHome.dart';
import 'package:learnlign/widgets/widgets.dart';

class People extends StatefulWidget {
  final String userName;
  final String userId;
  final int con_no;
  final String pic;
  final String desc;
  const People(
      {Key? key,
        required this.userName,
        required this.userId,
        required this.con_no,
        required this.pic,
        required this.desc})
      : super(key: key);
  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  late bool isConnected = false;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  bool isConnectionRequestPending = false;

  @override
  void initState() {
    super.initState();
    checkConnectionStatus();
    checkConnectionRequestStatus();// Check the connection status when the screen initializes
  }

  Future<void> checkConnectionRequestStatus() async {
    bool isRequestSent = await isConnectionRequestSent(widget.userId);

    setState(() {
      isConnectionRequestPending = isRequestSent;
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
      return pendingRequests.contains(FirebaseAuth.instance.currentUser!.uid);
    }
    return false;
  }


  Future<void> sendConnectionRequest(String currentUserId, String targetUserId) async {
    await FirebaseFirestore.instance.collection('users').doc(targetUserId).update({
      'pendingRequests': FieldValue.arrayUnion([currentUserId]),
    });
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


  Future<void> checkConnectionStatus() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();
    List<dynamic> connections = userSnapshot['connections'];

    setState(() {
      isConnected = connections.contains(widget.userId);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Container(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 56,
                backgroundImage: NetworkImage(widget.pic), // Replace with the actual field name
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10,),
                Text(
                  "${widget.userName.toUpperCase()}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 27, color: Colors.amber,fontFamily: 'Quicksand',),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text("Connections: ${widget.con_no}", style: TextStyle(color: Colors.white70),),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade900 ,
                      borderRadius: BorderRadius.circular(10)
                    ),
                      width: double.infinity,

                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Text(widget.desc, style: TextStyle(color: Colors.white70),),
                      )
                  ),
                )
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(26.0),
              child: Container(
                width: double.infinity,
                child: GestureDetector(
                  onTap: isConnected?(){
                    removeConnection(widget.userId);
                    showSnackbar(context, Colors.green, 'Removed collection');
                    nextScreen(context, UsersListScreen());

                  } :   () {
                    if (!isConnected && !isConnectionRequestPending) {
                      sendConnectionRequest(
                        FirebaseAuth.instance.currentUser!.uid,
                        widget.userId,
                      );
                      showSnackbar(context, Colors.green, 'Request sent');
                      setState(() {
                        isConnectionRequestPending = false;
                      });
                      checkConnectionRequestStatus();
                    }
                  },
                  child: Container(
                    width: 200, // Set the desired width of the button
                    height: 50, // Set the desired height of the button
                    decoration: BoxDecoration(
                      gradient: isConnected // Use the connection status to determine the gradient colors
                          ? LinearGradient(
                        colors: [Colors.redAccent, Colors.red.shade300],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ) : isConnectionRequestPending
                          ? LinearGradient(
                        colors: [Colors.grey.shade900, Colors.grey.shade800],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                          : LinearGradient(
                        colors: [Colors.amber, Colors.amber.shade300],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25), // Set the desired border radius
                    ),
                    child: Center(
                      child: Text(
                        isConnected
                            ? 'Remove Connection'
                            : isConnectionRequestPending
                            ? 'Connection Request Sent'
                            : 'Connect',
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
              ),
            )

          ],
        ),
      ),
    );
  }
}
