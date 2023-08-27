import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class PostDetailsPage extends StatefulWidget {
  final DocumentReference postRef;

  PostDetailsPage({required this.postRef});

  @override
  _PostDetailsPageState createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  final TextEditingController _commentController = TextEditingController();

  Future<void> _addComment() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final newComment = {
        'text': _commentController.text,
        'userId': user.uid,
        'timestamp': DateFormat("EEEEE, dd, yyyy").format(DateTime.now()),
      };

      final postSnapshot = await widget.postRef.get();
      final data = postSnapshot.data() as Map<String, dynamic>;
      final List<dynamic> comments = data['comments'] ?? [];
      comments.add(newComment);

      await widget.postRef.update({'comments': comments});
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: widget.postRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator(color: Colors.amber,),);
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;
                final profilePicUrl = data['profilePic'] as String?;
                final title = data['title'] as String?;
                final postText = data['text'] as String? ?? '';
                final username = data['userId'] as String? ?? 'Unknown';
                final likes = data['likes'] as int? ?? 0;
                final List<dynamic> comments = data['comments'] ?? [];
                var userStream = FirebaseFirestore.instance
                    .collection('users')
                    .doc(data['userId'])
                    .snapshots();

                return ListView(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(27, 28, 28, 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  profilePicUrl != null
                                      ? CircleAvatar(
                                      backgroundImage:
                                      NetworkImage(profilePicUrl))
                                      : Icon(Icons.account_circle),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  StreamBuilder<DocumentSnapshot>(
                                    stream: userStream,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return SpinKitDoubleBounce(
                                          color: Colors.grey,
                                        );
                                      }

                                      if (!snapshot.hasData) {
                                        return Text('Unknown.');
                                      }
                                      var userProfile =
                                      snapshot.data!.data()
                                      as Map<String, dynamic>;
                                      var fullName = userProfile['fullName'];

                                      return Text(
                                        fullName,
                                        style: TextStyle(
                                            color: Colors.amber,
                                            fontFamily: 'Quicksand',
                                            fontWeight: FontWeight.bold),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title!,
                                  style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 16,
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  postText,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text("${likes}",
                                          style:
                                          TextStyle(color: Colors.white70)),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                              Icons.thumb_up_off_alt_rounded,
                                              color: Colors.white70)),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text("${comments.length}",
                                          style:
                                          TextStyle(color: Colors.white70)),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.comment,
                                              color: Colors.white70)),
                                      Spacer(),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.bookmark_border,
                                              color: Colors.white70)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    FadeIn(
                      child: Center(
                        child: Text(
                          'Suggestions',
                          style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Quicksand',
                              fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      stream: widget.postRef.snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }

                        final data =
                        snapshot.data!.data() as Map<String, dynamic>;
                        final List<dynamic> comments = data['comments'] ?? [];

                        if (comments.isEmpty) {
                          return Center(
                            child: Text('No comments yet.',
                                style: TextStyle(color: Colors.white70)),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final comment =
                            comments[index] as Map<String, dynamic>;
                            final commentText = comment['text'] as String?;
                            final username =
                                comment['userId'] as String? ?? 'Unknown';
                            var userStream2 = FirebaseFirestore.instance
                                .collection('users')
                                .doc(username)
                                .snapshots();
                            final timestamp = comment['timestamp'];

                            return FadeInUp(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(27, 28, 28, 1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      ListTile(
                                        title: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                StreamBuilder<DocumentSnapshot>(
                                                  stream: userStream2,
                                                  builder:
                                                      (context, snapshot) {
                                                    if (snapshot.connectionState ==
                                                        ConnectionState.waiting) {
                                                      return SpinKitDoubleBounce(
                                                        color: Colors.grey,
                                                      );
                                                    }

                                                    if (!snapshot.hasData) {
                                                      return Text('Unknown.');
                                                    }
                                                    var userProfile =
                                                    snapshot.data!.data()
                                                    as Map<String, dynamic>;
                                                    var fullName =
                                                    userProfile['fullName'];
                                                    var profilePic =
                                                    userProfile['profilePic'];

                                                    return Row(
                                                      children: [
                                                        profilePic != null
                                                            ? CircleAvatar(
                                                          backgroundImage:
                                                          NetworkImage(
                                                              profilePic),
                                                          radius: 12,
                                                        )
                                                            : Icon(
                                                            Icons.account_circle),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Text(
                                                              fullName,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .amber,
                                                                  fontFamily:
                                                                  'Quicksand',
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                            ),
                                                            SizedBox(
                                                              height: 3,
                                                            ),
                                                            Text(
                                                              "${timestamp}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white70,
                                                                  fontSize: 8),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.all(13.0),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(commentText ?? '',
                                                  style: TextStyle(
                                                      color: Colors.white70)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          FadeInUp(
            delay: Duration(milliseconds: 700),
            child: Padding(
              padding: EdgeInsets.all(6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15),
                          fillColor: Colors.grey.shade800,
                          labelText: "Add comment",
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.grey.shade800),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          labelStyle: TextStyle(
                              color: Colors.white70,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(30)),
                      child: IconButton(
                        onPressed: _addComment,
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
