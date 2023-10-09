import 'package:animate_do/animate_do.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnlign/secrets.dart';
import 'package:learnlign/widgets/feature_box.dart';
import 'package:velocity_x/velocity_x.dart';

import 'chatmessage.dart';
import 'threedots.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  late OpenAI? chatGPT;
  bool _isImageSearch = false;
  bool generating = true;

  bool _isTyping = false;

  @override
  void initState() {
    chatGPT = OpenAI.instance.build(
        token: openAIAPIKey,
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
        isLogger: true);
    super.initState();
  }

  @override
  void dispose() {
    chatGPT?.close();
    chatGPT?.genImgClose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;
    ChatMessage message = ChatMessage(
      text: _controller.text,
      sender: "user",
      isImage: false,
    );

    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });

    _controller.clear();

    if (_isImageSearch) {
      final request = GenerateImage(message.text, 1, size: "256x256");

      final response = await chatGPT!.generateImage(request);
      Vx.log(response!.data!.last!.url!);
      insertNewData(response.data!.last!.url!, isImage: true);
    } else {
      final request = CompleteText(
          prompt: message.text, model: kTextDavinci2, maxTokens: 200);

      final response = await chatGPT!.onCompletion(request: request);
      Vx.log(response!.choices[0].text);
      insertNewData(response.choices[0].text, isImage: false);
    }
  }

  void insertNewData(String response, {bool isImage = false}) {
    ChatMessage botMessage = ChatMessage(
      text: response,
      sender: "bot",
      isImage: isImage,
    );

    setState(() {
      _isTyping = false;
      _messages.insert(0, botMessage);
    });
  }

  Widget _buildTextComposer() {
    return Container(
      color: Colors.black,
      alignment: Alignment.bottomCenter,
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Flexible(
              // Wrap the Row with Flexible
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35.0),
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (value) => _sendMessage(),
                        decoration: InputDecoration(
                          hintText: "Type Something...",
                          hintStyle: TextStyle(fontFamily: 'Quicksand'),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                _isImageSearch = false;
                setState(() {
                  generating = false;
                });
                _sendMessage();
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Icon(Icons.settings),
              )
            ],
            backgroundColor: Colors.black,
            centerTitle: true,
            title: const Text(
              "AI Assistant",
              style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  color: Colors.amber),
            )),
        body: Column(
          children: [
            generating == true
                ? Column(
                    children: [
                      ZoomIn(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Container(
                              child: SvgPicture.asset(
                                'Assets/undraw_male_avatar_g98d.svg',
                                semanticsLabel: 'My SVG Image',
                                width: 100,
                              ),
                            ),
                          ),
                        ),
                      ),
                      FadeIn(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 20)
                              .copyWith(
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
                      SizedBox(
                        height: 10,
                      ),
                      // features list
                      Visibility(
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
                  )
                : Text(''),
            Flexible(
                child: ListView.builder(
              reverse: true,
              padding: Vx.m8,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            )),
              if (_isTyping) ThreeDots(),
            const Divider(
              height: 1.0,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: generating
                  ? FadeInUp(
                      delay: Duration(milliseconds: 700),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.amber, // Background color
                          ),
                          onPressed: () {
                            setState(() {
                              generating = false;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text(
                              'Start Chat',
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                    )
                  : _buildTextComposer(),
            )
          ],
        ));
  }
}
