import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/features/login/logic/login_cubit.dart';
import 'package:chat_app/features/login/ui/widgets/login_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../core/helpers/constants.dart';
import '../../../core/theming/theming_const.dart';
import '../../sign_up/data/otp_model.dart';
import '../logic/login_state.dart';

class LoginScreen extends StatelessWidget {
   const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
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
            if(data){
              context.pushNamedAndRemoveUntil(Routes.navigationScreen, predicate: (route) => false,);
            }else{
              final cubit=context.read<LoginCubit>();

              showToast('please verify phone number' );
              sharedOtpModel=OtpModel(verificationId: cubit.verificationId,phone: cubit.phone);
              context.pushReplacementNamed(Routes.otpScreen);

            }
          },
          error: (error) {
            //to exit from CircularProgressIndicator
            context.pop();
            showToast(error);
          },
        );
      },
      child:const LoginBody(),
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
