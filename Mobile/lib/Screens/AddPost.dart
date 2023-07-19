import 'package:flutter/material.dart';

class PostNewDialog extends StatefulWidget {
  const PostNewDialog({super.key});

  @override
  State<PostNewDialog> createState() => _PostNewDialogState();
}

class _PostNewDialogState extends State<PostNewDialog> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [Colors.blue, Color.fromRGBO(88, 101, 242, 0.9)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds);
              },
              child:Text(
                "Add Post",
                style: TextStyle(
                    color: Color.fromRGBO(88, 101, 242, 0.9),
                    fontSize: 20,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 10,),
            Icon(Icons.group, color: Colors.white,size: 15,),
          ],
        ),
        content: Container(
          height: 400,
          width: 450,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Type somtheing..', style: TextStyle(color: Colors.white),),
              ),
              TextFormField(
                maxLines: 5,
                style: const TextStyle(
                  color: Colors.white, // Set the desired text color
                ),
                decoration: InputDecoration(filled: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                    fillColor: Colors.black87, focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(88, 101, 242, 0.9)),
                    ), border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ), labelStyle: const TextStyle(color: Colors.white60)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a vale';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                IconButton(onPressed: (){}, icon: Icon(Icons.photo_camera,
                  color: Colors.white,)),
                IconButton(onPressed: (){}, icon: Icon(Icons.add_photo_alternate,
                  color: Colors.white,)),
                IconButton(onPressed: (){}, icon: Icon(Icons.video_camera_back_sharp,
                  color: Colors.white,)),
                IconButton(onPressed: (){}, icon: Icon(Icons.more_vert,
                  color: Colors.white,))
              ],)
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(Colors.grey.shade900)
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel', style: TextStyle(color: Colors.white),),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(88, 101, 242, 0.9))
            ),
            onPressed: () {
              String postDetails = _textEditingController.text;
              // Do something with post details
              print('Post details: $postDetails');
              Navigator.of(context).pop();
            },
            child: Text('Add', style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }
}
