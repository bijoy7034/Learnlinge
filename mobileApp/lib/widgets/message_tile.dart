import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final String messageType;

  const MessageTile({
    Key? key,
    required this.message,
    required this.sender,
    required this.sentByMe,
    required this.messageType,
  }) : super(key: key);

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
        bottom: 2,
        left: sentByMe ? 0 : 24,
        right: sentByMe ? 24 : 0,
      ),
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sentByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 10),
        padding: EdgeInsets.only(
          top: 7,
          bottom: sentByMe
              ? (messageType == 'image' ? 5 : 15)
              : (messageType == 'image' ? 5 : 15),
          left: sentByMe
              ? (messageType == 'image' ? 0 : 15)
              : (messageType == 'image' ? 0 : 15),
          right: sentByMe
              ? (messageType == 'image' ? 0 : 15)
              : (messageType == 'image' ? 0 : 15),
        ),
        decoration: BoxDecoration(
          borderRadius: sentByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(messageType == 'image' ? 5 : 20),
                  topRight: Radius.circular(messageType == 'image' ? 5 : 20),
                  bottomLeft: Radius.circular(messageType == 'image' ? 5 : 20),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(messageType == 'image' ? 5 : 20),
                  topRight: Radius.circular(messageType == 'image' ? 5 : 20),
                  bottomRight: Radius.circular(messageType == 'image' ? 5 : 20),
                ),
          color: sentByMe
              ? (messageType == 'image'
                  ? Colors.transparent
                  : Colors.amber.shade300)
              : (messageType == 'image'
                  ? Colors.transparent
                  : Colors.grey.shade800),
        ),
        child: Column(
          crossAxisAlignment:
              sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Padding(
                padding: sentByMe
                    ? const EdgeInsets.only(right: 8.0)
                    : const EdgeInsets.only(right: 18.0),
                child: sentByMe
                    ? SizedBox(
                        height: 1,
                      )
                    : Text(
                        sender,
                        textAlign: sentByMe ? TextAlign.start : TextAlign.start,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: getRandomColor(),
                            letterSpacing: -0.5),
                      )),
            if (messageType == 'image')
              Image.network(
                message,
                width: 210,
                height: 210,
              )
            else if (messageType == 'doc')
              Container(
                width: 140,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PdfViewerScreen(
                        pfdUrl: message,
                      ),
                    ));
                    print(message);
                  },
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Align to the left
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Icon(
                          Icons.save_alt,
                          size: 30,
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
                          color: sentByMe ? Colors.black : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Text(
                message,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 13,
                  color: sentByMe ? Colors.black : Colors.white,
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
