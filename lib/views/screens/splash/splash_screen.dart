import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../welcome/welcome_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>_SplashScreenState();


}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 1),
      () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          MediaQuery.of(context).platformBrightness == Brightness.dark
              ? "assets/icons/Logo_dark_theme.svg"
              : "assets/icons/Logo_light_theme.svg",
        ),
      ),
    );
  }
}
