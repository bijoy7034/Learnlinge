import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:learnlign/widgets/widgets.dart';
import '../postDetails.dart';

class DiscussionForum extends StatefulWidget {
  const DiscussionForum({super.key});

  @override
  State<DiscussionForum> createState() => _DiscussionForumState();
}

class _DiscussionForumState extends State<DiscussionForum>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  List<TextEditingController> optionControllers = [];

  Future<String?> _getUserProfilePicUrl(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc['profilePic'];
  }

  Future<void> _createPost(String postText, String title) async {
    if (formKey.currentState!.validate()) {
      final user = _auth.currentUser;
      if (user != null) {
        final CollectionReference posts =
            FirebaseFirestore.instance.collection('posts');
        final profilePicUrl = await _getUserProfilePicUrl(user.uid);
        final postDoc = await posts.add({
          "title": title,
          'text': postText,
          'timestamp': FieldValue.serverTimestamp(),
          'userId': user.uid,
          'likes': 0,
          'comments': [],
          'profilePic': profilePicUrl,
        });
        await postDoc.collection('likes').doc(user.uid).set({'liked': false});
      }
    }
  }

  void _toggleLike(String postId) async {
    final user = _auth.currentUser;
    if (user != null) {
      final postRef =
          FirebaseFirestore.instance.collection('posts').doc(postId);
      final likeRef = postRef.collection('likes').doc(user.uid);

      final likeDoc = await likeRef.get();
      if (likeDoc.exists) {
        final isLiked = likeDoc['liked'] as bool;
        if (isLiked) {
          await likeRef.delete();
          postRef.update({'likesCount': FieldValue.increment(-1)});
        } else {
          await likeRef.set({'liked': true});
          postRef.update({'likesCount': FieldValue.increment(1)});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.filter_alt)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
        title: ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [Colors.white, Colors.white70],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds);
          },
          child: Text(
            "Discussion Forum",
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: SpinKitChasingDots(
              color: Colors.amber,
            ));
          }
          final posts = snapshot.data!.docs;

          if (posts.length == 0) {
            return Center(
              child: ElasticIn(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'Assets/undraw_font_re_efri.svg',
                      width: 220,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'No Posts',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final profilePicUrl = post['profilePic'];
              final postText = post['text'];
              final title = post['title'];
              final num_com = post['comments'].length;
              final displayedText = postText.length > 80
                  ? '${postText.substring(0, 80)}...'
                  : postText;
              final likes = post['likes'];
              var userStream = FirebaseFirestore.instance
                  .collection('users') // Replace with your collection name
                  .doc(post['userId'])
                  .snapshots();

              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: FadeInRight(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(27, 28, 28, 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            nextScreen(context,
                                PostDetailsPage(postRef: post.reference));
                          },
                          title: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: profilePicUrl != null
                                    ? CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(profilePicUrl))
                                    : Icon(
                                        Icons.account_circle,
                                        color: Colors.amber,
                                      ),
                              ),
                              SizedBox(
                                width: 5,
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
                                    return Text('Unkown.');
                                  }
                                  var userProfile = snapshot.data!.data()
                                      as Map<String, dynamic>;
                                  var fullName = userProfile[
                                      'fullName']; // Replace with the actual field nameReplace with the actual field name

                                  return Text(
                                    fullName,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.bold),
                                  );
                                },
                              ),
                              Spacer(),
                            ],
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  title,
                                  style: TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Quicksand'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  displayedText,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "${likes}",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          _toggleLike(post.id);
                                        },
                                        icon: Icon(
                                          Icons.thumb_up_off_alt_rounded,
                                          color: Colors.white70,
                                        )),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      "${num_com}",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.comment,
                                          color: Colors.white70,
                                        )),
                                    Spacer(),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.bookmark_border,
                                          color: Colors.white70,
                                        )),
                                  ],
                                ),
                              )
                            ],
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

      floatingActionButton: FadeIn(
        delay: Duration(milliseconds: 500),
        child: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: Colors.amber,
          overlayColor: Colors.black,
          overlayOpacity: 0.3,
          animationDuration: Duration(milliseconds: 500),
          children: [
            SpeedDialChild(
                child: Icon(Icons.poll),
                onTap: () {
                  popUpDialogPoll(context);
                }),
            SpeedDialChild(
              child: Icon(Icons.image),
            ),
            SpeedDialChild(
                child: Icon(Icons.post_add),
                onTap: () {
                  popUpDialog(context);
                })
          ],
        ),
      ),
    );
  }

  popUpDialogPoll(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.grey.shade900,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(35.0),
          ),
        ),
        builder: (context) {
          return SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            // Close the popup when the close icon is pressed
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    Text(
                      'Add Poll',
                      style: TextStyle(
                          color: Colors.amber.shade300,
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextFormField(
                        validator: (val) {
                          if (val!.length < 6) {
                            return "Title must be at least 6 characters";
                          } else {
                            return null;
                          }
                        },
                        controller: _titleController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 15,
                          ),
                          fillColor: Colors.grey.shade800,
                          labelText: "Title",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade800),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.white70,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Poll Options',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 18.0, right: 18.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: optionControllers.length + 1,
                        itemBuilder: (context, index) {
                          if (index == optionControllers.length) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  backgroundColor: Colors.grey.shade900),
                              onPressed: () {
                                setState(() {
                                  optionControllers
                                      .add(TextEditingController());
                                });
                              },
                              child: Text(
                                "Add Option",
                                style: TextStyle(color: Colors.amber),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 15,
                                  ),
                                  fillColor: Colors.grey.shade800,
                                  labelText: "Option ${index + 1}",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade800),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(color: Colors.amber),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide:
                                        BorderSide(color: Colors.orange),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.white70,
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                controller: optionControllers[index],
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Poll option cannot be empty";
                                  }
                                  return null;
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '*You can provide multiple poll options',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 300,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                // Create the poll using title and options
                                List<String> pollOptions = [];
                                for (var controller in optionControllers) {
                                  pollOptions.add(controller.text);
                                }
                                // Now you can use _createPost or similar method to save the poll to the database
                                //_createPoll(_titleController.text, pollOptions);
                                Navigator.of(context).pop();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              primary: Theme.of(context).primaryColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: const Text("Create Poll"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          );
        });
  }

  popUpDialog(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.grey.shade900,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          // Set the shape for rounded corners
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(35.0), // Customize the radius as needed
          ),
        ),
        builder: (context) {
          return Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          // Close the popup when the close icon is pressed
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  Text(
                    'Add Post',
                    style: TextStyle(
                        color: Colors.amber.shade300,
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextFormField(
                      validator: (val) {
                        if (val!.length < 6) {
                          return "Title must be at least 6 characters";
                        } else {
                          return null;
                        }
                      },
                      controller: _titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 15,
                          ),
                          fillColor: Colors.grey.shade800,
                          labelText: "Title",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade800),
                            borderRadius: BorderRadius.circular(
                                10.0), // Set the same border radius here
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
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
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Post',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                    child: TextFormField(
                      controller: _postController,
                      maxLines: 4,
                      style: const TextStyle(
                        color: Colors.white, // Set the desired text color
                      ),
                      decoration: InputDecoration(
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 15,
                          ),
                          fillColor: Colors.grey.shade800,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade800),
                            borderRadius: BorderRadius.circular(
                                10.0), // Set the same border radius here
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          labelStyle: TextStyle(
                              color: Colors.grey.shade700,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold)),
                      validator: (val) {
                        if (val!.length < 2) {
                          return "Post cant be empty";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '*You can provide a description about your discussion',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
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
                          onPressed: () {
                            _createPost(
                                _postController.text, _titleController.text);
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                // Set the shape for rounded corners
                                borderRadius: BorderRadius.circular(
                                    20.0), // Customize the radius as needed
                              ),
                              primary: Theme.of(context).primaryColor),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: const Text("Post"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          );
        });
  }
}
