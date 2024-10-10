import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/helpers/spacing.dart';
import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/features/login/ui/widgets/form_login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../core/theming/theming_const.dart';
class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    verticalSpace(30),
                    Image.asset(
                      MediaQuery.of(context).platformBrightness == Brightness.light
                          ? "assets/images/Logo_light.png"
                          : "assets/images/Logo_dark.png",
                      height: 146,
                    ),
                    verticalSpace(100),
                    const FormLogin(),
                    verticalSpace(30),
                    GestureDetector(onTap: () => context.pushNamed(Routes.forgetScreen),
                        child: const Text('forget Password?')),
                    const SizedBox(height: 20),
                    RichText(text:  TextSpan(text: "Don't have account? ",
                        style:TextStyle(color:Theme.of(context).textTheme.bodyMedium?.color ),
                        children: [
                          TextSpan(text: 'SignUp',
                            style: TextStyle(color: Theme.of(context).colorScheme.primary),
                            recognizer:TapGestureRecognizer()..onTap= () => context.pushReplacementNamed(Routes.signUpScreen),
                          )
                        ]),),

                  ],
                ),
              )




          )),

    );
  }
}
