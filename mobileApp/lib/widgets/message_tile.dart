import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnlign/pages/taskDone.dart';
import 'package:learnlign/widgets/widgets.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String groupId;
  final List<dynamic> completed;
  final List<dynamic> completedNames;
  final String messageId;
  final String sender;
  final bool sentByMe;
  final String messageType;
  final String date;
  final String description;
  final String link;

  const MessageTile({
    Key? key,
    required this.message,
    required this.sender,
    required this.sentByMe,
    required this.messageType,
    required this.date,
    required this.description,
    required this.link,
    required this.groupId,
    required this.completed,
    required this.messageId, required this.completedNames,
  }) : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  bool isButtonEnble = true;
  @override
  void initState() {
    super.initState();
    checkIfValueExists();
  }

  final user = FirebaseAuth.instance.currentUser;

  Future<void> checkIfValueExists() async {
    if (widget.messageType == 'task') {
      try {
        final DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection('groups')
            .doc(widget.groupId)
            .collection('messages')
            .doc(widget.messageId)
            .get();

        if (docSnapshot.exists) {
          final Map<String, dynamic>? data =
              docSnapshot.data() as Map<String, dynamic>?;
          final List<dynamic>? itemsArray = data?['completed'];

          // Check if the item exists in the array
          if (itemsArray!.contains(user!.uid)) {
            setState(() {
              isButtonEnble = false;
            });
          }
        } else {
          setState(() {
            isButtonEnble = true;
          });
        }
      } catch (e) {
        print('Error checking if item exists: $e'); // Error occurred
      }
    }
  }

  Color getRandomColor() {
    final List<Color> shades = [
      Colors.green.shade300,
      Colors.yellow,
      Colors.blueAccent.shade200,
      Colors.red.shade400,
    ];

    Color selectedShade = shades[Random().nextInt(shades.length)];
    int red = selectedShade.red;
    int green = selectedShade.green;
    int blue = selectedShade.blue;

    final int colorRange = 100; // Adjust this value to control the color range

    red += Random().nextInt(colorRange) - (colorRange ~/ 2);
    green += Random().nextInt(colorRange) - (colorRange ~/ 2);
    blue += Random().nextInt(colorRange) - (colorRange ~/ 2);

    red = red.clamp(0, 255);
    green = green.clamp(0, 255);
    blue = blue.clamp(0, 255);

    return Color.fromARGB(255, red, green, blue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 2,
        bottom: 0,
        left: widget.sentByMe ? 0 : 24,
        right: widget.sentByMe ? 24 : 0,
      ),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sentByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 10),
        padding: EdgeInsets.only(
          top: 7,
          bottom: widget.sentByMe
              ? (widget.messageType == 'image' ? 5 : 15)
              : (widget.messageType == 'image' ? 5 : 15),
          left: widget.sentByMe
              ? (widget.messageType == 'image' ? 0 : 15)
              : (widget.messageType == 'image' ? 0 : 15),
          right: widget.sentByMe
              ? (widget.messageType == 'image' ? 0 : 15)
              : (widget.messageType == 'image' ? 0 : 15),
        ),
        decoration: BoxDecoration(
          borderRadius: widget.sentByMe
              ? BorderRadius.only(
                  topLeft:
                      Radius.circular(widget.messageType == 'image' ? 5 : 20),
                  topRight:
                      Radius.circular(widget.messageType == 'image' ? 5 : 20),
                  bottomLeft:
                      Radius.circular(widget.messageType == 'image' ? 5 : 20),
                )
              : BorderRadius.only(
                  topLeft:
                      Radius.circular(widget.messageType == 'image' ? 5 : 20),
                  topRight:
                      Radius.circular(widget.messageType == 'image' ? 5 : 20),
                  bottomRight:
                      Radius.circular(widget.messageType == 'image' ? 5 : 20),
                ),
          color: widget.sentByMe
              ? (widget.messageType == 'image'
                  ? Colors.transparent
                  : Colors.amber.shade300)
              : (widget.messageType == 'image'
                  ? Colors.transparent
                  : Colors.grey.shade800),
        ),
        child: Column(
          crossAxisAlignment: widget.sentByMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Padding(
                padding: widget.sentByMe
                    ? const EdgeInsets.only(right: 8.0)
                    : const EdgeInsets.only(right: 18.0),
                child: widget.sentByMe
                    ? SizedBox(
                        height: 1,
                      )
                    : Text(
                        widget.sender,
                        textAlign:
                            widget.sentByMe ? TextAlign.start : TextAlign.start,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: getRandomColor(),
                            letterSpacing: -0.5),
                      )),
            if (widget.messageType == 'image')
              Image.network(
                widget.message,
                width: 210,
                height: 210,
              )
            else if (widget.messageType == 'doc')
              Container(
                width: 140,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PdfViewerScreen(
                        pfdUrl: widget.message,
                      ),
                    ));
                    print(widget.message);
                  },
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Align to the left
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Icon(
                          FluentIcons.document_save_24_regular,
                          size: 30,
                          color: widget.sentByMe ? Colors.black : Colors.white,
                        ), // Replace with your PDF icon
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'PDF file',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Quicksand',
                          color: widget.sentByMe ? Colors.black : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (widget.messageType == 'event')
              Column(
                children: [
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    color: Colors.white,
                    width: 270,
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'Assets/undraw_personal_info_re_ur1n.svg',
                          width: 170,
                        ),
                        Text(
                          widget.message,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: Colors.amber,
                              fontFamily: 'Quicksand'),
                        ),
                        Container(
                          // width: 200,
                          child: Divider(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      width: 270,
                      child: Text(
                        '${widget.description}',
                        style: TextStyle(
                            fontSize: 12,
                            color:
                                widget.sentByMe ? Colors.black : Colors.white,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 270,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.date,
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 250,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: widget.sentByMe
                              ? Colors.grey.shade800
                              : Colors.amber, // Background color
                        ),
                        onPressed: () {
                          launchUrl(widget.link as Uri);
                        },
                        child: Text('Link')),
                  )
                ],
              )
            else if (widget.messageType == 'task')
              Column(
                children: [
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    width: 270,
                    child: Column(
                      children: [
                        Text(
                          'TASK',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color:
                                  widget.sentByMe ? Colors.white : Colors.amber,
                              fontFamily: 'Quicksand'),
                        ),
                        Container(
                          // width: 200,
                          child: Divider(color: Colors.white),
                        ),
                        Center(
                            child: Text(
                          widget.message,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: widget.sentByMe
                                  ? Colors.blueAccent
                                  : Colors.amber,
                              fontFamily: 'Quicksand'),
                        )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      width: 270,
                      child: Text(
                        '${widget.description}',
                        style: TextStyle(
                            fontSize: 12,
                            color:
                                widget.sentByMe ? Colors.black : Colors.white,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      width: 250,
                      child: Center(
                        child: Row(
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: widget.sentByMe
                                      ? Colors.grey.shade800
                                      : Colors.blueAccent, // Background color
                                ),
                                onPressed: () {
                                  launchUrl(Uri.parse(widget.link));
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(FluentIcons
                                        .checkbox_checked_24_regular),
                                    Text('Open Link'),
                                  ],
                                )),
                            SizedBox(
                              width: 2,
                            ),
                            widget.sentByMe
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: widget.sentByMe
                                          ? Colors.grey.shade800
                                          : Colors.amber, // Background color
                                    ),
                                    onPressed: () {
                                      nextScreen(
                                          context,
                                          TaskDetails(
                                            taskName: widget.message, userUIDs: widget.completed,
                                          ));
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(FluentIcons.open_12_regular),
                                        Text('View'),
                                      ],
                                    ))
                                : isButtonEnble
                                    ? ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: widget.sentByMe
                                              ? Colors.grey.shade800
                                              : Colors
                                                  .amber, // Background color
                                        ),
                                        onPressed: () {
                                          _addDataArray(widget.groupId,
                                              widget.messageId, user!.uid);
                                          setState(() {
                                            isButtonEnble = false;
                                          });
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(FluentIcons
                                                .checkbox_checked_24_regular),
                                            Text('Complete'),
                                          ],
                                        ))
                                    : Container(
                                        color: Colors.green,
                                        child: Padding(
                                          padding: EdgeInsets.all(6),
                                          child: Row(
                                            children: [
                                              Icon(FluentIcons
                                                  .checkbox_checked_24_regular, color: Colors.white,),
                                              Text(
                                                'Completed',
                                                style:
                                                    TextStyle(color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                          ],
                        ),
                      ))
                ],
              )
            else
              Text(
                widget.message,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 12,
                  color: widget.sentByMe ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Future<void> _addDataArray(
    String groupId, String messageID, String value) async {
  final firestoreInstance = FirebaseFirestore.instance;
  firestoreInstance
      .collection('groups')
      .doc(groupId)
      .collection('messages')
      .doc(messageID)
      .update({
    'completed': FieldValue.arrayUnion([value])
  }).then((_) {
    print('Value added to the array successfully');
  }).catchError((error) {
    print('Error adding value to the array: $error');
  });
}

Future<void> _launchUrl(Uri _url) async {
  if (!await launchUrl(
    _url,
    mode: LaunchMode.inAppWebView,
    webViewConfiguration: const WebViewConfiguration(
        headers: <String, String>{'my_header_key': 'my_header_value'}),
  )) {
    throw Exception('Could not launch $_url');
  }
}

class PdfViewerScreen extends StatefulWidget {
  final String pfdUrl;
  const PdfViewerScreen({Key? key, required this.pfdUrl}) : super(key: key);
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<PdfViewerScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('PDF Viewer'),
        elevation: 0,
      ),
      body: Container(
        color: Colors.black,
        child: SfPdfViewer.network(
          widget.pfdUrl, // Replace with the PDF URL you want to display
        ),
      ),
    );
  }
}
