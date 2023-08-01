import 'dart:math';

import 'package:flutter/material.dart';
import 'package:learnlign/widgets/widgets.dart';

import '../pages/chat_page.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const GroupTile(
      {Key? key,
        required this.groupId,
        required this.groupName,
        required this.userName})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  final List<Color> iconColors = [
    Color.fromRGBO(255,197,196,1),
    Color.fromRGBO(203,171,254,1),
    Colors.green.shade200
    // Add more colors as needed.
  ];

  Color getRandomIconColor() {
    final Random random = Random();
    final int randomIndex = random.nextInt(iconColors.length);
    return iconColors[randomIndex];
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            ChatPage(
              groupId: widget.groupId,
              groupName: widget.groupName,
              userName: widget.userName,
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Column(
          children: [
            ListTile(
              trailing: IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: (){},
              ),
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: getRandomIconColor(),
                child: Text(
                  widget.groupName.substring(0, 1).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold , fontFamily: 'Quicksand'),
                ),
              ),
              title: Text(
                widget.groupName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Quicksand'),
              ),
              subtitle: Text(
                "Join the conversation as ${widget.userName}",
                style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 13, fontFamily: 'Quicksand'),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 28.0, right: 28),
                child: Divider(
                  thickness: 0.5,
                ))

          ],
        ),
      ),
    );
  }
}