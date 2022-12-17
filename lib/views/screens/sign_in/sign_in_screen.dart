import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../helper/constants.dart';
import '../../../controllers/cubit/auth/auth_cubit.dart';
import '../../components/primary_button.dart';

class SignInScreen extends StatelessWidget {
   const SignInScreen({super.key});
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
               key: cubit.signInFormKey,
               child: Column(
                children: [
                  const Spacer(flex:3),
                  Image.asset(
                    MediaQuery.of(context).platformBrightness == Brightness.light
                        ? "assets/images/Logo_light.png"
                        : "assets/images/Logo_dark.png",
                    height: 146,
                  ),
                  const Spacer(flex: 3),
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
                    focusNode: cubit.passwordFocusNode,
                    decoration: const InputDecoration(hintText: 'password'),
                  ),
                  const Spacer(),
                  PrimaryButton(
                    text: "Sign In",
                    press: () => cubit.signIn(context, cubitContext),
                  ),
                  const Spacer(),
                  GestureDetector(onTap: () => cubit.goToForgetPassword(context, cubitContext),
                      child: const Text('forget Password?')),
                  const SizedBox(height: 20),
                  RichText(text:   TextSpan(text: "Don't have account? ",
                      children: [
                        TextSpan(text: 'SignUp',
                          style: TextStyle(color: Theme.of(context).colorScheme.primary),
                          recognizer:TapGestureRecognizer()..onTap= () => cubit.pushAndReplacementSignUp(context, cubitContext),
                        )
                      ]),),
                  const Spacer(flex: 4,),

                ],),
             ),
          )),

    ),

    );

  }
}
