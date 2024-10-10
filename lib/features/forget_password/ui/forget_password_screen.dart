import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/features/forget_password/logic/forget_password_cubit.dart';
import 'package:chat_app/features/forget_password/ui/widgets/forget_password_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../core/theming/theming_const.dart';
import '../logic/forget_password_state.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
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
           context.pop();//CircularProgressIndicator
           context.pop();//to login
            showToast(data);
          },
          error: (error) {
            //to exit from CircularProgressIndicator
            context.pop();
            showToast(error);
          },
        );
      },
      child:const ForgetPasswordBody(),
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
