import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskDetails extends StatefulWidget {
  final List<dynamic> userUIDs;
  final String taskName;

  TaskDetails({required this.userUIDs, required this.taskName});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<TaskDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          '${widget.taskName}',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 38.0),
              child: Center(
                child: Text(
                  'Completed',
                  style: TextStyle(
                      color: Colors.amber,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Quicksand'),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: widget.userUIDs.length,
                  itemBuilder: (context, index) {
                    return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.userUIDs[index])
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator(
                            color: Colors.amber,
                          ); // Loading indicator
                        }

                        // Assuming your user documents have a "name" field
                        final user = snapshot.data?.data();
                        final userName = user?['fullName'];

                        return ListTile(
                          title: Text(
                            '- ${userName}',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

