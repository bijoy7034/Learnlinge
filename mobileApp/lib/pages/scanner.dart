import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:learnlign/pages/chat_page.dart';
import 'package:learnlign/widgets/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Scanner extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;

  const Scanner({Key? key, required this.userName, required this.groupId, required this.groupName}) : super(key: key);

  @override
  State<Scanner> createState() => _MyAppState();
}

class _MyAppState extends State<Scanner> {
  List<String> _pictures = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    onPressed();
  }

  Future<void> initPlatformState() async {
    await Firebase.initializeApp(); // Initialize Firebase if not already done
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.amber,
          elevation: 0,
          title: const Text(
            'Document Scanner',
            style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var picture in _pictures) Image.file(File(picture)),
            if (_pictures.isNotEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child : FutureBuilder<void>(
                    future: isLoading ? convertUploadAndSendToFirestore() : null,
                    builder: (context, snapshot) {
                      if (isLoading) {
                        return SpinKitThreeBounce(color: Colors.amber,); // Display loading indicator
                      } else {
                        return ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.amber),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.transparent),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              isLoading = true; // Set loading state to true when button is pressed
                            });
                          },
                          child: const Text(
                            "Convert to PDF and Upload",
                            style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void onPressed() async {
    List<String> pictures;
    try {
      pictures = await CunningDocumentScanner.getPictures() ?? [];
      if (!mounted) return;
      setState(() {
        _pictures = pictures;
      });
    } catch (exception) {
      // Handle exception here
    }
  }

  Future<void> convertUploadAndSendToFirestore() async {
    try {
      final pdf = pdfWidgets.Document();

      for (var imagePath in _pictures) {
        final image = pdfWidgets.MemoryImage(
          File(imagePath).readAsBytesSync(),
        );

        pdf.addPage(
          pdfWidgets.Page(
            build: (pdfWidgets.Context context) {
              return pdfWidgets.Center(
                child: pdfWidgets.Image(image, fit: pdfWidgets.BoxFit.contain),
              );
            },
          ),
        );
      }

      final appDocDir = await getApplicationDocumentsDirectory();
      final uniqueId = DateTime.now().millisecondsSinceEpoch.toString() +
          '_' +
          UniqueKey().toString(); // Generate a unique ID once
      final pdfFile = File('${appDocDir.path}/$uniqueId.pdf');
      await pdfFile.writeAsBytes(await pdf.save());

      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('chat_docs/$uniqueId.pdf'); // Use the unique ID as the file name

      final UploadTask uploadTask = storageReference.putFile(pdfFile);

      await uploadTask.whenComplete(() async {
        // Once the file is uploaded to storage, get the download URL
        final pdfUrl = await storageReference.getDownloadURL();

        // Add the PDF message to Firestore
        final firestore = FirebaseFirestore.instance;
        final groupDocRef = firestore.collection('groups').doc(widget.groupId);
        await groupDocRef.collection('messages').add({
          "message": pdfUrl,
          "sender": widget.userName,
          "timestamp": DateTime.now().millisecondsSinceEpoch,
          "type": 'doc', // Assuming it's a PDF
        });

        print('PDF message added to Firestore');

        setState(() {
          _pictures.clear(); // Clear the image list after sending the PDF
        });
      });

      print('File Uploaded');
    } catch (e) {
      // Handle exceptions here
      print('Error: $e');
    }
  }
}
