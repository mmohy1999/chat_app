import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theming/theming_const.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../logic/forget_password_cubit.dart';

class ForgetPasswordBody extends StatelessWidget {
  const ForgetPasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgetPasswordCubit>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Form(
            key: cubit.forgetPasswordFormKey,
            child: Column(
              children: [
                const Spacer(flex: 2,),
                Image.asset(
                  MediaQuery.of(context).platformBrightness == Brightness.light
                      ? "assets/images/Logo_light.png"
                      : "assets/images/Logo_dark.png",
                  height: 146,
                ),
                const Spacer(),
                const Text('Forget Password?',style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold)),
                const SizedBox(height: 10,),
                const Text('Integer quis dictum tellus, a auctoriorem,\n Cras in blandit leo suspendiss',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey)),
                const Spacer(),
                TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: cubit.emailValidator,
                    controller: cubit.emailController,
                    decoration: const InputDecoration(hintText: 'Email')
                ),
                const SizedBox(height: 24,),
                PrimaryButton(
                  text: "Next",
                  press: () => cubit.forgetPassword(),
                ),
                const Spacer(flex: 3,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
