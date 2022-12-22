import 'package:chat_app/models/user.dart';
import 'package:chat_app/views/screens/chats/chats_screen.dart';
import 'package:chat_app/views/screens/forget_password/forget_password_screen.dart';
import 'package:chat_app/views/screens/otp/otp_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../helper/constants.dart';
import '../../../views/screens/sign_in/sign_in_screen.dart';
import '../../../views/screens/sign_up/sign_up_screen.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);
  //region fields
  FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  FirebaseFirestore fireStore=FirebaseFirestore.instance;
  final signInFormKey = GlobalKey<FormState>();
  final signUpFormKey = GlobalKey<FormState>();
  final forgetPasswordFormKey = GlobalKey<FormState>();


  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

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

  late FocusNode passwordFocusNode = FocusNode();
  late FocusNode phoneFocusNode = FocusNode();
  late FocusNode emailFocusNode = FocusNode();



  String verificationId='';
  String otp='';

  //endregion

  //region reset controller
  restSingIn(){
    emailController.clear();
    passwordController.clear();
  }
  restSingUp(){
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
    nameController.clear();
  }
  //endregion

  //region navigator
  pushToSignIn(BuildContext context){
    restSingIn();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>  const SignInScreen(),
          settings: RouteSettings(arguments: context)
      ),
    );
  }
  pushAndReplacementSignIn(BuildContext context,BuildContext cubitContext){
    restSingIn();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
        builder: (context) =>  const SignInScreen(),
    settings: RouteSettings(arguments: cubitContext)
    ));

  }
  pushToSignUp(BuildContext context){
    restSingUp();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>  const SignUpScreen(),
          settings: RouteSettings(arguments: context)
      ),
    );
  }
  pushAndReplacementSignUp(BuildContext context,BuildContext cubitContext){
    restSingUp();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>  const SignUpScreen(),
          settings: RouteSettings(arguments: cubitContext)
      ),
    );
  }
  goToOtpScreen(BuildContext context,BuildContext cubitContext,String phone,String state){
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) =>   OtpScreen(phone: phone,state: state),
        settings: RouteSettings(arguments: cubitContext)
    ));

  }
  goToHome(BuildContext context){
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>   const ChatsScreen(),

      ),
      (route) => false,
    );
    showToast('welcome');
  }
  goToForgetPassword(BuildContext context,BuildContext cubitContext){
    phoneController.clear();
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => const ForgetPasswordScreen(),
        settings: RouteSettings(arguments: cubitContext)
    ));
  }

  //endregion

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
  showCircularProgressDialog(BuildContext context){
    showDialog(context: context,
      builder: (context) => const Center(child: CircularProgressIndicator(color: primaryColor,)),barrierDismissible:false );

  }

  //region firebase
  signIn(BuildContext context, BuildContext cubitContext) async{
    if(signInFormKey.currentState!.validate()){
      passwordFocusNode.unfocus();
      signInFormKey.currentState!.save();
      showCircularProgressDialog(context);
      try {
        await firebaseAuth.signInWithEmailAndPassword(
            email: emailController.text.trim(), password: passwordController.text)
            .then((value) async{
              if(value.user!.phoneNumber!=null) {
                Navigator.pop(context);
                goToHome(context);
              }else{
           await getPhone(value.user!.uid).then((phone){
             showToast('please verify phone number' );
             verifyPhoneNumber(context, cubitContext,phone,'signIn');
           });
              }
        },);
      } on FirebaseAuthException catch (e){
        Navigator.pop(context);
        showToast(e.message!);
      }


    }
  }
  singUp(BuildContext context, BuildContext cubitContext)async{

    if(signUpFormKey.currentState!.validate()){
      phoneFocusNode.unfocus();
      signUpFormKey.currentState!.save();
      showCircularProgressDialog(context);
      if(! await checkPhoneNumber(phoneController.text)){
        UserModel userModel = UserModel(
            nameController.text, phoneController.text, emailController.text.trim());
        try {
          firebaseAuth.createUserWithEmailAndPassword(
              email: userModel.email, password: passwordController.text)
              .then((value) {
            value.user!.updateDisplayName(userModel.name);
            userModel.uid = value.user!.uid;
            addUserToFireStore(userModel);
            showToast('account created successfully');
            verifyPhoneNumber(context, cubitContext,phoneController.text,'singUp');
          });
        } on FirebaseAuthException catch (e) {
          Navigator.pop(context);
          showToast(e.message!);

        }
      }
    }


  }
  verifyPhoneNumber(BuildContext context, BuildContext cubitContext,String phone,String state) async{
    Navigator.pop(context);
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone ,
      verificationCompleted: (PhoneAuthCredential credential) {
      },
      verificationFailed: (FirebaseAuthException e) {
        showToast(e.message!);
      },
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId=verificationId;
        goToOtpScreen(context, cubitContext,phone,state);

      },
      codeAutoRetrievalTimeout: (String verificationId) {
      },
    );
  }
  addPhoneUser(BuildContext context,String state){
    if(verificationId.isNotEmpty&&otp.isNotEmpty){
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);
    try{
    firebaseAuth.currentUser!.linkWithCredential(credential)
        .then((value){
          if(state=='signIn') {
            goToHome(context);
          } else {
            Navigator.pop(context);
          }
    } );
    }on FirebaseAuthException catch(e){
      showToast(e.message!);
    }
    }
  }
  addUserToFireStore(UserModel user){
    fireStore.collection('users').doc(user.phone).set(user.toMap());
  }
  Future<bool> checkPhoneNumber(String phone) async{
    bool phoneFlag=false;
   await fireStore.collection('user').doc(phone).get().then((value){
      if(value.exists) {
        phoneFlag= true;
      }
    });
    return phoneFlag;
  }
  Future<String> getPhone(String uid) async{
    String phone='';
   await fireStore.collection('users').get().then((value){
     var snapShot= value.docChanges;
     for (var e in snapShot) {
       if(e.doc.data()!['uid']==uid) {
         phone=e.doc.data()!['phone'];
       }
     }});
    return phone;
  }
  forgetPassword(BuildContext context){
    if(forgetPasswordFormKey.currentState!.validate()) {
      emailFocusNode.unfocus();
      forgetPasswordFormKey.currentState!.save();
      showCircularProgressDialog(context);
      try {
        firebaseAuth.sendPasswordResetEmail(email: emailController.text.trim()).then((value){
          emailController.clear();
          Navigator.pop(context);
          Navigator.pop(context);
          showToast('Password rest email sent');
        });
      }on FirebaseAuthException catch(e){
        showToast(e.message!);
        Navigator.pop(context);
      }
    }
  }
//endregion
}
