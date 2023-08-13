import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _selectedImage;
  String? _currentName = "";
  String? _currentDescription = "";
  String? _currentProfilePic = "";
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    setState(() {
      _currentName = userSnapshot['fullName'];
      _currentDescription = userSnapshot['description'];
      _currentProfilePic = userSnapshot['profilePic'];
    });
  }

  Future<void> _updateProfile() async {
    setState(() {
      _uploading = true; // Uploading complete
    });
    String uid = FirebaseAuth.instance.currentUser!.uid;

    if (_selectedImage != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('$uid.jpg');
      await storageRef.putFile(_selectedImage!);

      String downloadURL = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'profilePic': downloadURL,
      });
    }

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'fullName': nameController.text,
      'description': descriptionController.text,
    });
    setState(() {
      _uploading = false; // Uploading complete
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Edit Profile', style: TextStyle(color: Colors.amber, fontFamily: 'Quicksand', fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body:_uploading? Center(
        child: SpinKitWaveSpinner(   // Replace SpinKitCircle with any other available spinner
          color: Colors.amber,  // Set the color of the spinner
          size: 100.0,          // Set the size of the spinner
        ),
      ):  SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _uploadImage,
              child: _selectedImage != null
                  ? ClipOval(
                child: Image.file(
                  _selectedImage!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              )
                  : _currentProfilePic != null
                  ? ClipOval(
                child: Image.network(
                  _currentProfilePic!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              )
                  : CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: nameController..text = _currentName!,
                decoration: InputDecoration(filled: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15,),
                    fillColor: Colors.grey.shade900, labelText: "Name",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade800),
                      borderRadius: BorderRadius.circular(10.0), // Set the same border radius here
                    ), focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.amber),
                    ), border:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: Colors.orange),
                    ), labelStyle: TextStyle(color: Colors.white70,  fontFamily: 'Quicksand', fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 3,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Description', style: TextStyle(color: Colors.white70),),
                ],
              ),
            ),
            const SizedBox(height: 2,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: TextFormField(
                controller: descriptionController..text = _currentDescription!,
                maxLines: 8,
                style: const TextStyle(
                  color: Colors.white, // Set the desired text color
                ),
                decoration: InputDecoration(
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20,),
                    fillColor: Colors.grey.shade900,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade800),
                      borderRadius: BorderRadius.circular(10.0), // Set the same border radius here
                    ), focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.amber),
                    ), border:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: Colors.orange),
                    ), labelStyle: TextStyle(color: Colors.grey.shade700,  fontFamily: 'Quicksand', fontWeight: FontWeight.bold)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a vale';
                  }
                  return null;
                },
              ),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('*You can edit the description about you where other people can find you easily', textAlign: TextAlign.center , style: TextStyle(color: Colors.white70, fontFamily: 'Quicksand', fontWeight: FontWeight.bold, fontSize: 10),),
            ),
            SizedBox(height: 10,),
            Container(
              child: SvgPicture.asset(
                'Assets/undraw_scrum_board_re_wk7v.svg',
                semanticsLabel: 'My SVG Image',
                width: 200,
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                child: GestureDetector(
                  onTap:_updateProfile,
                  child: Container(
                    width: 200, // Set the desired width of the button
                    height: 50, // Set the desired height of the button
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.amber, Colors.amber.shade300], // Replace with your desired gradient colors
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25), // Set the desired border radius
                    ),
                    child: Center(
                      child: Text(
                        'Save Profile',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          color: Colors.white, // Set the text color
                          fontSize: 16, // Set the font size
                          fontWeight: FontWeight.bold, // Set the font weight
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ) ,
            // TextField(
            //   controller: descriptionController..text = _currentDescription!,
            //   decoration: InputDecoration(labelText: 'Description'),
            // ),
            // SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: _updateProfile,
            //   child: Text('Save Profile'),
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);

      setState(() {
        _selectedImage = imageFile;
      });
    }
  }
}
