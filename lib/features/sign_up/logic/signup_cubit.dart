import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../../../core/helpers/constants.dart';
import '../data/user.dart';
import 'signup_state.dart';


class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(const SignupState.initial());
  //region fields

  FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  FirebaseFirestore fireStore=FirebaseFirestore.instance;
  final formKey =GlobalKey<FormState>();
  TextEditingController passwordController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  late FocusNode passwordFocusNode = FocusNode();
  late FocusNode phoneFocusNode = FocusNode();
  late FocusNode emailFocusNode = FocusNode();

  final passwordValidator = MultiValidator(
    [
      RequiredValidator(errorText: requiredField),
      MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
      // PatternValidator(r'(?=.*?[#?!@$%^&*-])',
      //     errorText: 'passwords must have at least one special character')
    ],
  );
  final nameValidator = MultiValidator(
    [
      RequiredValidator(errorText: requiredField),
      MinLengthValidator(3, errorText: 'Name must be at least 3 digits long'),
    ],
  );
  final emailValidator = MultiValidator(
    [
      RequiredValidator(errorText: requiredField),
      PatternValidator(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+", errorText: 'Please Enter Valid Email')
    ],
  );
  final phoneValidator = MultiValidator(
    [
      RequiredValidator(errorText: requiredField),
    ],
  );

  String verificationId='';
  String otp='';
  //endregion


  void validateThenDoSignup() {
    if (formKey.currentState!.validate()) {
      singUp();
    }
  }
  singUp()async{
    emit(const SignupState.loading());
      phoneFocusNode.unfocus();
      if(! await checkPhoneNumber('+2${phoneController.text}')){
        UserModel userModel = UserModel(
            name:  nameController.text
            ,phone:  '+2${phoneController.text}',email:  emailController.text.trim(),photo: 'https://firebasestorage.googleapis.com/v0/b/chat-6cf94.appspot.com/o/images%2Fdefualt_avater.png?alt=media&token=9125ad8d-e438-40f5-b6e3-7e12aa76d480');

          firebaseAuth.createUserWithEmailAndPassword(
              email: userModel.email!, password: passwordController.text)
              .then((value) {
            value.user!.updateDisplayName(userModel.name);
            userModel.uid = value.user!.uid;
            value.user!.updatePhotoURL('https://firebasestorage.googleapis.com/v0/b/chat-6cf94.appspot.com/o/images%2Fdefualt_avater.png?alt=media&token=9125ad8d-e438-40f5-b6e3-7e12aa76d480');
            addUserToFireStore(userModel);
            verifyPhoneNumber(userModel.phone);
          }).onError((error, stackTrace) {
            debugPrint('login Errroorrrrr:$error');
            emit(SignupState.error(error: error
                .toString()));
          },);
      }
      else{
        emit(const SignupState.error(error: 'this phone already exist'));
      }



  }
  verifyPhoneNumber(String phone) async{
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone ,
      verificationCompleted: (PhoneAuthCredential credential) {
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Errroorrrrr:${e.message}');
        emit(SignupState.error(error: e.message!));
      },
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId=verificationId;
        emit(SignupState.success(phone));

      },
      codeAutoRetrievalTimeout: (String verificationId) {
      },
    );
  }

  addUserToFireStore(UserModel user){
    fireStore.collection('users').doc(user.phone).set(user.toMap());
  }
  Future<bool> checkPhoneNumber(String phone) async{
    bool phoneFlag=false;
    await fireStore.collection('users').doc(phone).get().then((value){
      if(value.exists) {
        phoneFlag= true;
      }
    });
    return phoneFlag;
  }
  disposeControls(){
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();

  }
}
