import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/helpers/spacing.dart';
import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/features/sign_up/ui/widgets/form_signup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/theming/theming_const.dart';
class SignupBody extends StatelessWidget {
  const SignupBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  verticalSpace(20),
                  Image.asset(
                    MediaQuery.of(context).platformBrightness == Brightness.light
                        ? "assets/images/Logo_light.png"
                        : "assets/images/Logo_dark.png",
                    height: 146,
                  ),
                  verticalSpace(20),
                  const Text('Sign Up',style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold)),
                  verticalSpace(20),
                  const FormSignup(),
                  verticalSpace(20),
                  RichText(text:   TextSpan(
                      text: "Already have an account? ",
                      style:TextStyle(color:Theme.of(context).textTheme.bodyMedium?.color ),
                      children: [
                        TextSpan(text: 'Sign in',
                            style: TextStyle(color: Theme.of(context).colorScheme.primary),
                            recognizer:TapGestureRecognizer()..onTap= () =>context.pushReplacementNamed(Routes.loginScreen)
                        )
                      ]),),
                  verticalSpace(20),


                ],),
            ),
          )),
    );
  }
}
