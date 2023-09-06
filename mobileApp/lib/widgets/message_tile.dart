import 'dart:math';

import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;

  const MessageTile(
      {Key? key,
        required this.message,
        required this.sender,
        required this.sentByMe})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {


  Color getRandomColor() {
    final List<Color> shades = [
      Colors.green,
      Colors.yellow,
      Colors.blueAccent,
      Colors.red,
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
          left: widget.sentByMe ? 0 : 24,
          right: widget.sentByMe ? 24 : 0),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sentByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding:
        const EdgeInsets.only(top: 7, bottom: 17, left: 20, right: 5),
        // constraints: BoxConstraints(
        //     maxWidth: MediaQuery.of(context).size.width * .6),
        decoration: BoxDecoration(
            borderRadius: widget.sentByMe
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
            color: widget.sentByMe
                ? Colors.amber.shade300
                : Colors.grey.shade800),
        child: Column(
          crossAxisAlignment: widget.sentByMe?  CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: widget.sentByMe ? const EdgeInsets.only(right: 8.0) : const EdgeInsets.only(right: 18.0),
              child: widget.sentByMe ? SizedBox(height: 1,) :Text(
                widget.sender,
                textAlign : widget.sentByMe ? TextAlign.start :TextAlign.start,
                style:  TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color : getRandomColor(),
                    letterSpacing: -0.5),
              )
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(widget.message,
                  textAlign : widget.sentByMe ? TextAlign.justify :TextAlign.justify,
                  style : widget.sentByMe ? const TextStyle(fontSize:13, color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Quicksand')
                      :  TextStyle(fontSize:13, color: Colors.white,fontWeight: FontWeight.bold, fontFamily: 'Quicksand')),
            )
          ],
        ),
      ),
    );
  }
}
