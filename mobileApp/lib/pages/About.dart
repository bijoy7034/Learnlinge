import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: SlideInRight(
          child: Text(
            'About',
            style:
                TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: FadeInUp(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'LearnLinge',
                  style: TextStyle(
                      color: Colors.amber.shade400,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                      fontSize: 40),
                ),
                Text(
                  'A Learning Community',
                  style: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                      fontSize: 10),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                    child: Text(
                  "The Virtual Study Group app represents an innovative and comprehensive collaborativelearning platform specifically designed to enhance the educational experience for students intoday's digital age. This platform provides students with a virtual environment where theycan seamlessly connect, communicate, and collaborate with peers, regardless of geographicalconstraints.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold),
                )),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ), // Background color
                        ),
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            'Contact Us',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )),
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
