import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:dishio/wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Container(
        child: Image.asset(
          'assets/images/dishio-logo.png',
        ),
      ),
      nextScreen: const Wrapper(),
      splashIconSize: 250,
      duration: 2000,
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
