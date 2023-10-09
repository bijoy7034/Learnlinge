import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {super.key,
      required this.text,
      required this.sender,
      this.isImage = false});

  final String text;
  final String sender;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    return isImage
        ? AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              text,
              loadingBuilder: (context, child, loadingProgress) =>
                  loadingProgress == null
                      ? child
                      : const CircularProgressIndicator.adaptive(),
            ),
          )
        : sender == 'user' ?
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 20),
            child: Container(
              decoration : BoxDecoration(
                  color: Colors.amber.shade300,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  text.trim(),
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Quicksand'),
                ),
              ),
            ),
          ),
        ),
      ],
    )
        : Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          'Assets/undraw_male_avatar_g98d.svg',
          semanticsLabel: 'My SVG Image',
          width: 35,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 20, top: 6),
            child: Container(
              decoration : BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  text.trim(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    ).py8();
  }
}
