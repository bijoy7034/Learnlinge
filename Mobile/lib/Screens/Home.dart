import 'package:flutter/material.dart';
import 'package:learnlinge/Authentication/login.dart';

class ChatGroup extends StatefulWidget {
  const ChatGroup({super.key});

  @override
  State<ChatGroup> createState() => _ChatGroupState();
}

class _ChatGroupState extends State<ChatGroup> {
  List<Group> _groups = [
    Group('Mern Stack Development', '32'),
    Group('Maths Fundementals', '44'),
    Group('DBMS', '54'),
    Group('Big Data', '22'),
    Group('Group 5', '33'),
    Group('Group 1','102'),
    Group('Group 2', '223'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.black87,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Set the color of the drawer icon
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
              icon: Icon(
                Icons.logout,
              ))
        ],
        backgroundColor: Colors.black,
        title: ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [Colors.blue, Color.fromRGBO(88, 101, 242, 0.9)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds);
          },
          child:Text(
            "LernLinge",
            style: TextStyle(
                color: Color.fromRGBO(88, 101, 242, 0.9),
                fontSize: 30,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(

          children: [

            Container(
              height: 800,
              child: ListView.builder(
                itemCount: _groups.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 200,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius:
                            BorderRadius.circular(18.0), // Set the border radius value
                      ),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        leading: Container(
                          width: 80,
                          height: 80,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 70,
                                child: Icon(Icons.groups, color: Color.fromRGBO(88, 101, 242, 0.9),),
                                backgroundColor: Colors.black87,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Transform.scale(
                                  scale: 0.9,
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      _groups[index].notification,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        title: Text(
                          _groups[index].name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Description of group ${index + 1}',
                          style:
                              TextStyle(color: Colors.white70, fontFamily: 'Quicksand'),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(onPressed: (){}, icon: Icon(Icons.info, color: Colors.white,)),
                            Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        onTap: () {
                          // Handle group tile tap here
                          // Navigate to the chat screen or perform any action
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Group {
  final String name;
  final String notification;

  Group(this.name, this.notification);
}
