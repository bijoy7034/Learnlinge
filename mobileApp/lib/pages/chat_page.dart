import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:learnlign/pages/events.dart';
import 'package:learnlign/pages/scanner.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import '../service/database_services.dart';
import '../widgets/message_tile.dart';
import '../widgets/widgets.dart';
import 'group_info.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

  const ChatPage({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ScrollController _scrollController = ScrollController();
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        title: FadeInRight(
          child: Row(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: Colors.grey.shade800,
                child: Text(
                  widget.groupName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.amber, fontSize: 13,),
                ),
              ),
              SizedBox(width: 10,),
              InkWell(
                onTap: () {
                  nextScreen(
                    context,
                    GroupInfo(
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                      adminName: admin,
                    ),
                  );
                },
                child: Row(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [Colors.white, Colors.white],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ).createShader(bounds);
                          },
                          child: Text(
                            widget.groupName,
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(onPressed: (){}, icon:Icon(FluentIcons.video_32_regular)),
          PopupMenuButton(
              icon: Icon(Icons.more_vert, color: Colors.white,),
              color : Colors.grey.shade800,
              itemBuilder: (context)=> [
                PopupMenuItem(
                  onTap: (){
                    nextScreen(context, EventCreator(userName: widget.userName, groupId: widget.groupId, groupName: widget.groupName,));
                  },
                    child: Row(
                      children: [
                        Icon(Icons.check_circle),
                        SizedBox(width: 10,),
                        Text('Add Events',
                          style: TextStyle(color: Colors.white, fontFamily: 'Quicksand'),),
                      ],
                    )),
                PopupMenuItem(
                    onTap: (){
                    },
                    child: Row(
                      children: [
                        Icon(Icons.video_camera_front_outlined),
                        SizedBox(width: 10,),
                        Text('Meet Schedule',
                          style: TextStyle(color: Colors.white, fontFamily: 'Quicksand'),),
                      ],
                    )),

                PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.multitrack_audio_outlined),
                        SizedBox(width: 10,),
                        Text('Audio Call',
                          style: TextStyle(color: Colors.white, fontFamily: 'Quicksand'),),
                      ],
                    )),
                PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.poll),
                        SizedBox(width: 10,),
                        Text('Poll',
                          style: TextStyle(color: Colors.white, fontFamily: 'Quicksand'),),
                      ],
                    )),

              ]),

        ],
      ),
      body: FadeInUp(
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(27, 28, 28, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Stack(
              children: <Widget>[
                StreamBuilder(
                  stream: chats,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SpinKitFoldingCube(   // Replace SpinKitCircle with any other available spinner
                          color: Colors.amber,  // Set the color of the spinner
                          size: 50.0,          // Set the size of the spinner
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                      return Center(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'Assets/undraw_respond_re_iph2.svg',
                            semanticsLabel: 'My SVG Image',
                            width: 200,
                          ),
                          SizedBox(height: 15,),
                          Padding(
                            padding: const EdgeInsets.only(left: 32, right: 32),
                            child: Text('No messages yet', style: TextStyle(color: Colors.white70, fontFamily: 'Quicksand', fontWeight: FontWeight.bold,), textAlign: TextAlign.center,),
                          ),
                          SizedBox(height: 55,),
                        ],
                      ),);
                    }

                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });

                    // return Padding(
                    //   padding: const EdgeInsets.only(bottom: 78.0),
                    //   child: ListView.builder(
                    //     controller: _scrollController,
                    //     itemCount: snapshot.data.docs.length,
                    //     itemBuilder: (context, index) {
                    //       return MessageTile(
                    //         message: snapshot.data.docs[index]['message'],
                    //         sender: snapshot.data.docs[index]['sender'],
                    //         sentByMe: widget.userName == snapshot.data.docs[index]['sender'],
                    //         messageType: snapshot.data.docs[index]['type'],
                    //       );
                    //     },
                    //   ),
                    // );
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 78.0),
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          final messageType = snapshot.data.docs[index]['type'];
                          if (messageType == 'event') {
                            // Render an event widget here with date, description, etc.
                            return MessageTile(
                              message: snapshot.data.docs[index]['message'],
                              sender: snapshot.data.docs[index]['sender'],
                              date: snapshot.data.docs[index]['date'],
                              description: snapshot.data.docs[index]['description'],
                              link: snapshot.data.docs[index]['link'],
                              sentByMe: widget.userName == snapshot.data.docs[index]['sender'],
                              messageType: messageType,
                            );
                          } else {
                            // Render a regular message tile
                            return MessageTile(
                              message: snapshot.data.docs[index]['message'],
                              sender: snapshot.data.docs[index]['sender'],
                              sentByMe: widget.userName == snapshot.data.docs[index]['sender'],
                              messageType: messageType,
                              date: '',
                              description: '',
                              link: '',
                            );
                          }
                        },
                      ),
                    );

                  },
                ),
                SizedBox(height:10),
                Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(FluentIcons.emoji_28_regular),
                                  onPressed: () {},
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: messageController,
                                    decoration: InputDecoration(
                                      hintText: "Type Something...",
                                      hintStyle: TextStyle(fontFamily: 'Quicksand'),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),

                                IconButton(
                                  icon: Icon(FluentIcons.attach_24_regular),
                                  onPressed: () async {
                                    final pickedFile =
                                    await ImagePicker().pickImage(source: ImageSource.gallery);
                                    if (pickedFile != null) {
                                      String imageUrl = pickedFile.path;
                                      sendMessage('image', imageUrl);
                                    }
                                  },
                                ),
                                IconButton(
                                    onPressed: (){
                                      nextScreen(context, Scanner(userName: widget.userName, groupId: widget.groupId, groupName: widget.groupName,));
                                    },
                                    icon: Icon(FluentIcons.camera_add_48_regular))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            sendMessage('text', '');
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  void sendMessage(String type, String content) async {
    if (messageController.text.isNotEmpty || content.isNotEmpty) {
      if (type == 'image') {
        print(content);
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('chat_images')
            .child(basename(content));

        UploadTask uploadTask = storageReference.putFile(File(content));
        TaskSnapshot taskSnapshot = await uploadTask;
        String imageUrl = await storageReference.getDownloadURL();

        Map<String, dynamic> chatMessageMap = {
          "message": imageUrl,
          "sender": widget.userName,
          "timestamp": DateTime.now().millisecondsSinceEpoch,
          "type": type,
        };
        DatabaseService().sendMessage(widget.groupId, chatMessageMap);
            setState(() {
              messageController.clear();
            });

      } else {
        print(messageController.text);
        Map<String, dynamic> chatMessageMap = {
          "message": messageController.text,
          "sender": widget.userName,
          "timestamp": DateTime.now().millisecondsSinceEpoch,
          "type": type,
        };

        DatabaseService().sendMessage(widget.groupId, chatMessageMap);
            setState(() {
              messageController.clear();
            });
      }
      messageController.clear();
    }
  }

  // sendMessage(String type, String url) {
  //   if (messageController.text.isNotEmpty) {
  //     Map<String, dynamic> chatMessageMap = {
  //       "message": messageController.text,
  //       "sender": widget.userName,
  //       "time": DateTime.now().millisecondsSinceEpoch,
  //       "type": type
  //     };
  //
  //     DatabaseService().sendMessage(widget.groupId, chatMessageMap);
  //     setState(() {
  //       messageController.clear();
  //     });
  //   }
  // }

  // Method to scroll to the bottom of the ListView
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds:200),
      curve: Curves.easeInOut,
    );
  }
}
