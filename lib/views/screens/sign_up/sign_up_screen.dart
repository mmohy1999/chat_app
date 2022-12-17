import 'package:chat_app/controllers/cubit/auth/auth_cubit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../helper/constants.dart';
import '../../components/primary_button.dart';
import '../sign_in/sign_in_screen.dart';
import '../sign_in_or_sign_up/sign_in_or_sign_up_screen.dart';

class SignUpScreen extends StatelessWidget {
   const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubitContext =
    ModalRoute.of(context)!.settings.arguments as BuildContext;
    AuthCubit cubit=AuthCubit.get(cubitContext);
    return BlocProvider.value(
      value:cubit,
      child: Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Form(
              key: cubit.signUpFormKey,
              child: Column(
                children: [
                  const Spacer(),
                  Image.asset(
                    MediaQuery.of(context).platformBrightness == Brightness.light
                        ? "assets/images/Logo_light.png"
                        : "assets/images/Logo_dark.png",
                    height: 146,
                  ),
                  const Spacer(flex: 3),
                  const Text('Sign Up',style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold)),
                  const Spacer(flex: 2,),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    validator: cubit.nameValidator,
                    controller: cubit.nameController,
                    decoration: const InputDecoration(hintText: 'Full Name'),
                  ),
                  const Spacer(),
                  TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: cubit.emailValidator,
                      controller: cubit.emailController,
                      decoration: const InputDecoration(hintText: 'Email')
                  ),
                  const Spacer(),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    validator: cubit.passwordValidator,
                    controller: cubit.passwordController,
                    obscureText: true,
                      decoration: const InputDecoration(hintText: 'password'),
                  ),
                  const Spacer(),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    validator: cubit.phoneValidator,
                    controller: cubit.phoneController,
                    focusNode: cubit.phoneFocusNode,
                    decoration: const InputDecoration(hintText: 'Phone'),
                  ),

                  const Spacer(),
                  PrimaryButton(
                    text: "Sign Up",
                    press: () => cubit.singUp(context, cubitContext),
                  ),
                  const Spacer(),
                  RichText(text:   TextSpan(text: "Already have an account? ",
                      children: [
                        TextSpan(text: 'Sign in',
                            style: TextStyle(color: Theme.of(context).colorScheme.primary),
                            recognizer:TapGestureRecognizer()..onTap= () =>cubit.pushAndReplacementSignIn(context, cubitContext) )
                      ]),),
                  const Spacer(flex: 2,),

                ],),
            ),
          )),
    ),);
  }
}
