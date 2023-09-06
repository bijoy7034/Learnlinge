import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
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
        title: InkWell(
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
                        colors: [Colors.white70, Colors.white],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds);
                    },
                    child: Text(
                      widget.groupName,
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 20,
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
        backgroundColor: Colors.black,
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.more_vert, color: Colors.white,),
              color : Colors.grey.shade800,
              itemBuilder: (context)=> [
                PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.check_circle),
                        SizedBox(width: 10,),
                        Text('Add Tasks',
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

              ]),

        ],
      ),
      body: Container(
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

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 78.0),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return MessageTile(
                          message: snapshot.data.docs[index]['message'],
                          sender: snapshot.data.docs[index]['sender'],
                          sentByMe:
                          widget.userName == snapshot.data.docs[index]['sender'],
                        );
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
                                icon: Icon(Icons.face),
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
                                icon: Icon(Icons.photo_camera),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.attach_file),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          sendMessage();
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
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }

  // Method to scroll to the bottom of the ListView
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds:200),
      curve: Curves.easeInOut,
    );
  }
}
