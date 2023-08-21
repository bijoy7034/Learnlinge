import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome to MyApp",
          body: "Discover the amazing features of MyApp.",
          image: Image.asset("assets/onboarding_image_1.png"),
        ),
        PageViewModel(
          title: "Explore",
          body: "Explore the app's different sections and functionalities.",
          image: Image.asset("assets/onboarding_image_2.png"),
        ),
        // Add more pages as needed
      ],
      onDone: () {
        // Handle when the user taps the "Done" button
        // For example, navigate to the home screen q
        Navigator.of(context).pushReplacementNamed('/home');
      },
      onSkip: () {
        // Handle when the user taps the "Skip" button
        // For example, navigate to the home screen
        Navigator.of(context).pushReplacementNamed('/home');
      },
      showSkipButton: true,
      showDoneButton: true,
      skip: const Text("Skip"),
      done: const Text("Done"),
    );
  }
}
