import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnlign/pages/chat_page.dart';
import 'package:learnlign/service/database_services.dart';
import 'package:learnlign/widgets/widgets.dart';

class Tasks extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const Tasks({super.key, required this.userName, required this.groupId, required this.groupName});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {

  final formKey = GlobalKey<FormState>();
  DateTime? startDate;
  DateTime? endDate;
  String? eventName;
  String? eventDescription;
  String? eventLink;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        title: FadeInRight(child: Text('Tasks')),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: FadeInUp(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                )),
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Task Title',
                        style:
                        TextStyle(color: Colors.white, fontFamily: 'Quicksand'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: nameController,
                    style: TextStyle(color: Colors.white),
                    validator: (val) {
                      if (val!.length < 6) {
                        return "Title must be at least 6 characters";
                      } else {
                        return null;
                      }
                    },

                    decoration: InputDecoration(
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 20,
                        ),
                        fillColor: Colors.grey.shade900,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade900),
                          borderRadius: BorderRadius.circular(
                              10.0), // Set the same border radius here
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.amber),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                        labelStyle: TextStyle(
                            color: Colors.grey.shade700,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Description',
                        style:
                        TextStyle(color: Colors.white, fontFamily: 'Quicksand'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    style: TextStyle(color: Colors.white),
                    maxLines: 5,
                    decoration: InputDecoration(
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 20,
                        ),
                        fillColor: Colors.grey.shade900,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade900),
                          borderRadius: BorderRadius.circular(
                              10.0), // Set the same border radius here
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.amber),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                        labelStyle: TextStyle(
                            color: Colors.grey.shade700,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Task Link (optional)',
                        style:
                        TextStyle(color: Colors.white, fontFamily: 'Quicksand'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: linkController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 20,
                        ),
                        fillColor: Colors.grey.shade900,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade900),
                          borderRadius: BorderRadius.circular(
                              10.0), // Set the same border radius here
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.amber),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                        labelStyle: TextStyle(
                            color: Colors.grey.shade700,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold)),
                  ),
                  // SizedBox(
                  //   height: 205,
                  // ),
                  FadeIn(
                    delay: Duration(milliseconds: 1000),
                    child: Padding(
                      padding: const EdgeInsets.all(38.0),
                      child: SvgPicture.asset(
                        'Assets/voidImg.svg',
                        height: 200,
                      ),
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      child: FloatingActionButton.extended(
                          backgroundColor: Colors.grey.shade900,
                          onPressed: () {
                            uploadEvent();
                          }, label: Row(
                        children: [
                          Text('Save', style: TextStyle(color: Colors.amber),),
                        ],
                      ))),
                  SizedBox(height: 5,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> uploadEvent()async {
    if (nameController.text.isNotEmpty && descriptionController.text.isNotEmpty){
      Map<String, dynamic> chatMessageMap = {
        "description": descriptionController.text,
        "link":linkController.text,
        "message": nameController.text,
        "sender": widget.userName,
        'completed': [],
        'completedNames' : [],
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "type": 'task'
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      nextScreen(context, ChatPage(groupId: widget.groupId, groupName: widget.groupName, userName: widget.userName,));
      setState(() {
        nameController.clear();
        linkController.clear();
        descriptionController.clear();
      });
    }
  }
}
