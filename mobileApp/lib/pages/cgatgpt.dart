import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/feature_box.dart';

class AlChatBox extends StatefulWidget {
  const AlChatBox({super.key});

  @override
  State<AlChatBox> createState() => _AlChatBoxState();
}

class _AlChatBoxState extends State<AlChatBox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text('AI Assistant', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  child:  SvgPicture.asset(
                    'Assets/undraw_male_avatar_g98d.svg',
                    semanticsLabel: 'My SVG Image',
                    width: 100,
                  ),
                ),
              ),
            ),
            FadeInRight(
              child: Visibility(
                // visible: generatedImageUrl == null,
                child: Container(

                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 20).copyWith(
                    top: 30,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(30).copyWith(
                      topLeft: Radius.zero,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      'Good Morning, what task can I do for you?',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SlideInLeft(
              child: Visibility(
                //visible: generatedContent == null && generatedImageUrl == null,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 10, left: 22),
                  child: const Text(
                    'Here are a few features',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      color: Colors.white70,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),

            //features
            Visibility(
              //visible: generatedContent == null && generatedImageUrl == null,
              child: Column(
                children: [
                  SlideInLeft(
                    //delay: Duration(milliseconds: start),
                    child: FeatureBox(
                      color: Colors.grey.shade900,
                      headerText: 'AI Bot',
                      descriptionText:
                      'A smarter way to stay organized and informed with ChatGPT',
                    ),
                  ),
                  SlideInRight(
                    //delay: Duration(milliseconds: start + delay),
                    child: FeatureBox(
                      color: Colors.grey.shade900,
                      headerText: 'Image Generation',
                      descriptionText:
                      'Get inspired and stay creative with your personal assistant powered by Dall-E',
                    ),
                  ),
                  SlideInLeft(
                    //delay: Duration(milliseconds: start + 2 * delay),
                    child: FeatureBox(
                      color: Colors.grey.shade900,
                      headerText: 'Smart Voice Assistant',
                      descriptionText:
                      'Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT',
                    ),
                  ),
                ],
              ),
            )

          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        //delay: Duration(milliseconds: start + 3 * delay),
        child: FloatingActionButton(
          backgroundColor: Colors.amber,
          onPressed: () {  },
          child: Icon(
             Icons.mic,
          ),
        ),
      ),
    ) ;
  }
}
