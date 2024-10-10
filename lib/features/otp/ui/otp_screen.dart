import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/features/otp/logic/otp_cubit.dart';
import 'package:chat_app/features/otp/ui/widgets/otp_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../core/routing/routes.dart';
import '../../../core/theming/theming_const.dart';
import '../logic/otp_state.dart';


class OtpScreen extends StatelessWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocListener<OtpCubit, OtpState>(
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
            //to exit from CircularProgressIndicator
            context.pop();
            showToast('phone verified successfully');
            // //go to login screen
             context.pushReplacementNamed(Routes.loginScreen);

            // context.pushNamedAndRemoveUntil(Routes.homeScreen,predicate: (route) => false,);
          },
          error: (error) {
            //to exit from CircularProgressIndicator
            context.pop();
            showToast(error);
          },
        );
      },
      child:const OtpBody(),
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
