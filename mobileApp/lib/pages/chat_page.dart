import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../service/database_services.dart';
import '../widgets/message_tile.dart';
import '../widgets/widgets.dart';
import 'group_info.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatPage(
      {Key? key,
        required this.groupId,
        required this.groupName,
        required this.userName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
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
      backgroundColor: Colors.blueAccent,
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
                ));
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
              child:Text(
                widget.groupName,
                style: TextStyle( fontFamily: 'Quicksand', fontSize: 20, fontWeight: FontWeight.bold ),
                overflow: TextOverflow.clip,
              ),
            ),

          ],
        )
        ],
      ),),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          // IconButton(
          //     onPressed: () {
          //       nextScreen(
          //           context,
          //           GroupInfo(
          //             groupId: widget.groupId,
          //             groupName: widget.groupName,
          //             adminName: admin,
          //           ));
          //     },
          //     icon: const Icon(Icons.info)),
          IconButton(onPressed: (){}, icon: Icon(Icons.video_call, color: Colors.white,)),
          IconButton(onPressed: (){}, icon: Icon(Icons.add_ic_call_outlined, color: Colors.white,)),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top:18.0),
          child: Stack(
            children: <Widget>[
              // chat messages here
              chatMessages(),
              Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  width: MediaQuery.of(context).size.width,
                  child: Row(children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color:  Color.fromRGBO(233, 230, 244,0.9),
                          borderRadius: BorderRadius.circular(35.0),
                          // boxShadow: [
                          //   BoxShadow(
                          //       offset: Offset(0, 3),
                          //       blurRadius: 5,
                          //       color: Colors.grey)
                          // ],
                        ),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.face), onPressed: () {}),
                            Expanded(
                              child: TextField(
                                controller: messageController,
                                decoration: InputDecoration(
                                    hintText: "Type Something...",
                                    hintStyle: TextStyle(fontFamily: 'Quicksand'),
                                    border: InputBorder.none),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.photo_camera),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(Icons.attach_file),
                              onPressed: () {},
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
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
                            )),
                      ),
                    )
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            return MessageTile(
                message: snapshot.data.docs[index]['message'],
                sender: snapshot.data.docs[index]['sender'],
                sentByMe: widget.userName ==
                    snapshot.data.docs[index]['sender']);
          },
        )
            : Container();
      },
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
}