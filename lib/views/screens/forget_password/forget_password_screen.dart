import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controllers/cubit/auth/auth_cubit.dart';
import '../../../helper/constants.dart';
import '../../components/primary_button.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubitContext = ModalRoute.of(context)!.settings.arguments as BuildContext;
    AuthCubit cubit=AuthCubit.get(cubitContext);
    return BlocProvider.value(value: cubit,
    child: Scaffold(
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
                  press: () => cubit.forgetPassword(context),
                ),
                const Spacer(flex: 3,),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
