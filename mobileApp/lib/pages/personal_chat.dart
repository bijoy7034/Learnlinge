import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

class OneToOneChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String userName;

  const OneToOneChatScreen({
    required this.receiverId,
    required this.receiverName,
    required this.userName,
  });

  @override
  State<OneToOneChatScreen> createState() => _OneToOneChatScreenState();
}

class _OneToOneChatScreenState extends State<OneToOneChatScreen> {
  ScrollController _scrollController = ScrollController();
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getChatMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void getChatMessages() {
    String chatId = widget.userName.compareTo(widget.receiverId) < 0
        ? '${widget.userName}-${widget.receiverId}'
        : '${widget.receiverId}-${widget.userName}';

    chats = FirebaseFirestore.instance
        .collection('one_to_one_chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      String chatId = widget.userName.compareTo(widget.receiverId) < 0
          ? '${widget.userName}-${widget.receiverId}'
          : '${widget.receiverId}-${widget.userName}';

      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "timestamp": FieldValue.serverTimestamp(),
      };

      FirebaseFirestore.instance
          .collection('one_to_one_chats')
          .doc(chatId)
          .collection('messages')
          .add(chatMessageMap);

      messageController.clear();
    }
  }

  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.receiverName, style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold),),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 20,),
            Expanded(
              child: StreamBuilder(
                stream: chats,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitFoldingCube(
                        color: Colors.amber,
                        size: 50.0,
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                    return Center(
                      child: Column(
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
                            child: Text(
                              'No messages yet',
                              style: TextStyle(
                                color: Colors.white70,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 55,),
                        ],
                      ),
                    );
                  }

                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    scrollToBottom();
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      var messageData = snapshot.data.docs[index].data();
                      var sender = messageData['sender'];
                      var message = messageData['message'];

                      bool sentByMe = widget.userName == sender;

                      return MessageTile(
                        message: message,
                        sender: sender,
                        sentByMe: sentByMe,
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey.shade900,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white70,
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
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final String sender;
  final bool sentByMe;

  const MessageTile({
    Key? key,
    required this.message,
    required this.sender,
    required this.sentByMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 2,
        bottom: 2,
        left: sentByMe ? 0 : 24,
        right: sentByMe ? 24 : 0,
      ),
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sentByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.only(top: 7, bottom: 17, left: 20, right: 5),
        decoration: BoxDecoration(
          borderRadius: sentByMe
              ? const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          )
              : const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          color: sentByMe ? Colors.amber.shade300 : Colors.grey.shade800,
        ),
        child: Column(
          crossAxisAlignment: sentByMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(right: 8.0),
            //   child: Text(
            //     sentByMe ? 'You' : sender.toUpperCase(),
            //     textAlign: sentByMe ? TextAlign.start : TextAlign.start,
            //     style: TextStyle(
            //       fontSize: 13,
            //       fontWeight: FontWeight.bold,
            //       color: sentByMe ? Colors.amber : Colors.amber,
            //       letterSpacing: -0.5,
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                message,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 13,
                  color: sentByMe ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
