

import 'package:chat_app/core/helpers/constants.dart';
import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/features/sign_up/data/otp_model.dart';
import 'package:chat_app/features/sign_up/logic/signup_cubit.dart';
import 'package:chat_app/features/sign_up/ui/widgets/signup_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../core/theming/theming_const.dart';
import '../logic/signup_state.dart';

class SignUpScreen extends StatelessWidget {
   const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocListener<SignupCubit, SignupState>(
      listenWhen: (previous, current) => current is Loading || current is Success || current is Error,
      listener: (context, state) {
        state.whenOrNull(
          loading: (){
            showDialog(
              context: context,
              builder: (context) => const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              ),
            );
          },
          success: (data) {
            final cubit=context.read<SignupCubit>();
            //to exit from CircularProgressIndicator
            context.pop();
            showToast('account created successfully');
            //go to otp screen
            sharedOtpModel=OtpModel(verificationId: cubit.verificationId,phone: cubit.phoneController.text);
            context.pushReplacementNamed(Routes.otpScreen);

            // context.pushNamedAndRemoveUntil(Routes.homeScreen,predicate: (route) => false,);
          },
          error: (error) {
            //to exit from CircularProgressIndicator
            context.pop();
            showToast(error);
          },
        );
      },
      child:const SignupBody(),
    );
  }
   showToast(String msg){
     Fluttertoast.showToast(
         msg:msg,
         toastLength: Toast.LENGTH_SHORT,
         gravity: ToastGravity.BOTTOM,
         backgroundColor: primaryColor,
         textColor: Colors.white,
         fontSize: 16.0
     );
   }
}
