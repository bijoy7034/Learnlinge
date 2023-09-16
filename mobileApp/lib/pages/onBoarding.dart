import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:learnlign/pages/auth/profilesetup.dart';


class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (_) => const ProfileSetup()
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 16.0, color: Colors.white, fontFamily: 'Quicksand');

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700,fontFamily: 'Quicksand', color: Colors.amber),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.black,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.black,
      allowImplicitScrolling: true,
      autoScrollDuration: 10000,
      infiniteAutoScroll: true,
      pages: [
        PageViewModel(
          title: "Chat with Peers",
          body:
          "Connect with fellow learners in real-time! Chat, discuss, and share knowledge with a diverse community of students and educators. Whether you're seeking help or sharing your expertise, our chat feature makes learning collaborative and engaging.",
          image: SvgPicture.asset(
            'Assets/undraw_upload_image_re_svxx.svg',
            fit: BoxFit.cover,
            height: 200,
            alignment: Alignment.center,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "AI Assistance",
          body:
          "Our AI-powered tutor is here to assist you 24/7. Get instant answers to your questions, personalized study recommendations, and feedback on your progress. Learning has never been this accessible and convenient.",
          image: SvgPicture.asset(
            'Assets/undraw_respond_re_iph2.svg',
            fit: BoxFit.cover,
            height: 200,
            alignment: Alignment.center,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Build a network!!",
          body:
          "Expand your network and learn from the best! Connect with experts, mentors, and like-minded individuals who share your interests.",
          image: SvgPicture.asset(
            'Assets/undraw_scrum_board_re_wk7v.svg',
            fit: BoxFit.cover,
            height: 200,
            alignment: Alignment.center,
          ),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back, color: Colors.amber,),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.amber)),
      next: const Icon(Icons.arrow_forward, color: Colors.amber,),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.amber)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
