import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learnlign/pages/homePage.dart';
import 'package:learnlign/widgets/widgets.dart';


class ProfileSetup extends StatefulWidget {

  const ProfileSetup({Key? key}) : super(key: key);

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  final TextEditingController descriptionController = TextEditingController();
  File? _image;
  String? _imageDownloadURL;
  bool _uploading = false;

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);

      // Include the App Check token along with the user's authentication token
      setState(() {
        _image = imageFile;
        // _imageDownloadURL = downloadURL;
      });
    }
  }


  void _saveProfile() async {
    setState(() {
      _uploading  = true; // Start uploading
    });

    final metadata = firebase_storage.SettableMetadata(
      customMetadata: {
        'AppCheck': 'true',
      },
    );

    // Upload the image to Firebase Storage
    final storageRef = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('profile_pictures')
        .child('${FirebaseAuth.instance.currentUser!.uid}.jpg');
    await storageRef.putFile(_image!, metadata);

    // Get the download URL
    String downloadURL = await storageRef.getDownloadURL();

    String description = descriptionController.text;
    print(description);

    // Update the user document in Firestore
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
      'profilePic': downloadURL,
      'description': description,
    });

    setState(() {
      _uploading = false; // Uploading complete
    });
    // Navigate to the next page or perform any other action
    nextScreenReplace(context, HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        title: Text('Set Your Profile', style: TextStyle(fontFamily: 'Quicksand'),),
      ),
      body: _uploading? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElasticIn(
              child: SpinKitWaveSpinner(// Replace SpinKitCircle with any other available spinner
                color: Colors.amber,  // Set the color of the spinner
                size: 100.0,          // Set the size of the spinner
              ),
            ),
            Padding(padding: EdgeInsets.all(18)),
            ElasticIn(child: Text('Unlocking Minds, Empowering Futures: Join Our Learning Community!', textAlign: TextAlign.center , style: TextStyle(color: Colors.white70, fontFamily: 'Quicksand', fontWeight: FontWeight.bold),))
          ],
        ),
      ): SingleChildScrollView(
        child: ElasticIn(
          child: Container(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    GestureDetector(
                      onTap: _uploadImage,
                      child: SizedBox(
                        width: 100,
                        child: CircleAvatar(
                          backgroundColor: _image == null ? Colors.grey.shade800 : null,
                          radius: 50,
                          backgroundImage: _image != null ? FileImage(_image!) : null,
                          child: _image == null
                              ? Icon(Icons.person, size: 50, color: Colors.amber,) // Display the profile icon
                              : null, // Display the selected profile picture
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 60,
                      child: IconButton(
                        onPressed: _uploadImage,
                        icon: Icon(
                          Icons.add_circle,
                          size: 30,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(27, 28, 28, 1),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50.0),
                      bottomRight: Radius.circular(50.0),
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      // Padding(
                      //   padding: const EdgeInsets.all(16.0),
                      //   child: TextField(
                      //     controller: descriptionController,
                      //     decoration: InputDecoration(labelText: 'Description'),
                      //   ),
                      // ),
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
                      controller: descriptionController,
                      maxLines: 6,
                      style: const TextStyle(
                        color: Colors.white, // Set the desired text color
                      ),
                      decoration: InputDecoration(filled: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15,),
                          fillColor: Colors.grey.shade800,
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
                        child: Text('*You can provide a description about you where other people can find you easily', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70),),
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
                        padding: const EdgeInsets.all(28.0),
                        child: Container(
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: _saveProfile,
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
                      SizedBox(height: 20),
                      // ElevatedButton(
                      //   onPressed: _saveProfile,
                      //   child: Text('Save Profile'),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
