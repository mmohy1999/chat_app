import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../controllers/cubit/auth/auth_cubit.dart';
import '../../../helper/constants.dart';
import '../../components/primary_button.dart';
import '../sign_in/sign_in_screen.dart';
import '../sign_up/sign_up_screen.dart';

class SignInOrSignUpScreen extends StatelessWidget {
  const SignInOrSignUpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AuthCubit(),
        child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          AuthCubit cubit=AuthCubit.get(context);
          return SafeArea(
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
                press: () => cubit.pushToSignIn(context)
              ),
              const SizedBox(height: defaultPadding * 1.5),
              PrimaryButton(
                color: Theme.of(context).colorScheme.secondary,
                text: "Sign Up",
                press: () =>cubit.pushToSignUp(context)
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      );
  },
),
      ),
    );

  }
}
