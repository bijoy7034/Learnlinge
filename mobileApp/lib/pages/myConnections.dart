import 'package:flutter/material.dart';

class MyConnecctions extends StatefulWidget {
  const MyConnecctions({super.key});

  @override
  State<MyConnecctions> createState() => _MyConnecctionsState();
}

class _MyConnecctionsState extends State<MyConnecctions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('My Connection list', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold),),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                borderRadius:  BorderRadius.all(Radius.circular(10))
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person, color: Colors.amber, ),
                    backgroundColor: Colors.black,
                    radius: 30,
                  ),
                  title: Text('Aksa Kuruvila', style: TextStyle(color: Colors.white),),
                  trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert, color: Colors.white,),
                      color : Colors.grey.shade800,
                      itemBuilder: (context)=> [
                        PopupMenuItem(
                            child: Text('Details',
                              style: TextStyle(color: Colors.white, fontFamily: 'Quicksand'),)),
                        PopupMenuItem(
                            onTap: (){
                              //removeConnection(user['uid']);
                            },
                            child: Text('Remove',
                              style: TextStyle(color: Colors.white, fontFamily: 'Quicksand'),)),

                        PopupMenuItem(
                            child: Text('Block',
                              style: TextStyle(color: Colors.white, fontFamily: 'Quicksand'),))
                      ]),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius:  BorderRadius.all(Radius.circular(10))
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person, color: Colors.amber, ),
                    backgroundColor: Colors.black,
                    radius: 30,
                  ),
                  title: Text('Bijoy Anil', style: TextStyle(color: Colors.white),),
                  trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert, color: Colors.white,),
                      color : Colors.grey.shade800,
                      itemBuilder: (context)=> [
                        PopupMenuItem(
                            child: Text('Details',
                              style: TextStyle(color: Colors.white, fontFamily: 'Quicksand'),)),
                        PopupMenuItem(
                            onTap: (){
                              //removeConnection(user['uid']);
                            },
                            child: Text('Remove',
                              style: TextStyle(color: Colors.white, fontFamily: 'Quicksand'),)),

                        PopupMenuItem(
                            child: Text('Block',
                              style: TextStyle(color: Colors.white, fontFamily: 'Quicksand'),))
                      ]),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
