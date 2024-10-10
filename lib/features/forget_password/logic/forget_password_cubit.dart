

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../core/helpers/constants.dart';
import 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(const ForgetPasswordState.initial());
  final forgetPasswordFormKey = GlobalKey<FormState>();
  late FocusNode emailFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  final emailValidator = MultiValidator(
    [
      RequiredValidator(errorText: requiredField),
      PatternValidator(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+", errorText: 'Please Enter Valid Email')
    ],
  );


  forgetPassword(){
    if(forgetPasswordFormKey.currentState!.validate()) {
      emit(const ForgetPasswordState.loading());
      emailFocusNode.unfocus();
      forgetPasswordFormKey.currentState!.save();

        FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim()).then((value){
          emailController.clear();
          emit(const ForgetPasswordState.success('Password rest email sent'));
        }).onError((error, stackTrace) {
          emit(ForgetPasswordState.error(error: error.toString()));
        },);

    }
  }

}
