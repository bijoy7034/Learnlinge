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
  String? _imageDownloadURL ='';
  bool _uploading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      setState(() {
        _image = imageFile;
      });
    }
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _uploading = true;
    });

    final metadata = firebase_storage.SettableMetadata(
      customMetadata: {'AppCheck': 'true'},
    );

    final storageRef = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('profile_pictures')
        .child('${FirebaseAuth.instance.currentUser!.uid}.jpg');
    await storageRef.putFile(_image!, metadata);

    String downloadURL = await storageRef.getDownloadURL();

    String description = descriptionController.text;

    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
      'profilePic': downloadURL,
      'description': description,
    });

    setState(() {
      _uploading = false;
    });

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
        title: Text('Set Your Profile', style: TextStyle(fontFamily: 'Quicksand')),
      ),
      body: _uploading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElasticIn(
              child: SpinKitWaveSpinner(
                color: Colors.amber,
                size: 100.0,
              ),
            ),
            Padding(padding: EdgeInsets.all(18)),
            ElasticIn(
              child: Text('Unlocking Minds, Empowering Futures: Join Our Learning Community!', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontFamily: 'Quicksand', fontWeight: FontWeight.bold)),
            )
          ],
        ),
      )
          : SingleChildScrollView(
        child: ElasticIn(
          child: Form(
            key: _formKey,
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
                            child: _image == null ? Icon(Icons.person, size: 50, color: Colors.amber,) : null,
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
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Description', style: TextStyle(color: Colors.white70)),
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
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15,),
                              fillColor: Colors.grey.shade800,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey.shade800),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.amber),
                              ),
                              border:  OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              labelStyle: TextStyle(color: Colors.grey.shade700,  fontFamily: 'Quicksand', fontWeight: FontWeight.bold),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('*You can provide a description about you where other people can find you easily', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
                        ),
                        SizedBox(height: 10),
                        Container(
                          child: SvgPicture.asset(
                            'Assets/undraw_scrum_board_re_wk7v.svg',
                            semanticsLabel: 'My SVG Image',
                            width: 200,
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Container(
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: _saveProfile,
                              child: Container(
                                width: 200,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.amber, Colors.amber.shade300],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Text(
                                    'Save Profile',
                                    style: TextStyle(
                                      fontFamily: 'Quicksand',
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
