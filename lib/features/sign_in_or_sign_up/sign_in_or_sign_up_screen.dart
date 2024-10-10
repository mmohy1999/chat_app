import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/routing/routes.dart';
import 'package:flutter/material.dart';
import '../../core/theming/theming_const.dart';
import '../../core/widgets/primary_button.dart';

class LoginOrSignupScreen extends StatelessWidget {
  const LoginOrSignupScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Image.asset(
                MediaQuery.of(context).platformBrightness == Brightness.light
                    ? "assets/images/Logo_light.png"
                    : "assets/images/Logo_dark.png",
                height: 146,
              ),
              const Spacer(),
              PrimaryButton(
                  text: "Sign In",
                  press: () => context.pushNamed(Routes.loginScreen)
              ),
              const SizedBox(height: defaultPadding * 1.5),
              PrimaryButton(
                  color: Theme.of(context).colorScheme.secondary,
                  text: "Sign Up",
                  press: () =>context.pushNamed(Routes.signUpScreen)
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );

  }
}
