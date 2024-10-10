import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:zego_zim/zego_zim.dart';
import '../../../core/helpers/constants.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState.initial());
  final formKey =GlobalKey<FormState>();
   TextEditingController passwordController=TextEditingController();
   TextEditingController emailController=TextEditingController();
   FocusNode passwordFocusNode = FocusNode();
  FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  FirebaseFirestore fireStore=FirebaseFirestore.instance;

  final passwordValidator = MultiValidator(
    [
      RequiredValidator(errorText: requiredField),
      MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
      // PatternValidator(r'(?=.*?[#?!@$%^&*-])',
      //     errorText: 'passwords must have at least one special character')
    ],
  );
  final emailValidator = MultiValidator(
    [
      RequiredValidator(errorText: requiredField),
      PatternValidator(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+", errorText: 'Please Enter Valid Email')
    ],
  );
  String verificationId='';
  String phone='';


  void validateThenDoLogin() {
    if (formKey.currentState!.validate()) {
      login();
    }
  }
  login() async{

      passwordFocusNode.unfocus();
      emit(const LoginState.loading());
        await firebaseAuth.signInWithEmailAndPassword(
            email: emailController.text.trim(), password: passwordController.text)
            .then((value) async{
          if(value.user!.phoneNumber!=null) {
            emit(const LoginState.success(true));//go to home Page
            // Navigator.pop(context);
            // goToHome(context);
          }else{
            await getPhone(value.user!.uid).then((phone){
              verifyPhoneNumber(phone);
            });
          }
        },).onError((error, stackTrace) {
          emit(LoginState.error(error: error.toString()));
        },);




  }

  verifyPhoneNumber(String phone) async{
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone ,
      verificationCompleted: (PhoneAuthCredential credential) {
      },
      verificationFailed: (FirebaseAuthException e) {
        emit(LoginState.error(error: e.message!));
      },
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId=verificationId;
        emit(const LoginState.success(false));

      },
      codeAutoRetrievalTimeout: (String verificationId) {
      },
    );
  }

  Future<String> getPhone(String uid) async{
    String phone='';
    await fireStore.collection('users').get().then((value){
      var snapShot= value.docChanges;
      for (var e in snapShot) {
        if(e.doc.data()!['uid']==uid) {
          phone=e.doc.data()!['phone'];
          this.phone=phone;
        }
      }});
    return phone;
  }
  disposeControls(){
    emailController.dispose();
    passwordController.dispose();
  }
}
