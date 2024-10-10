import 'package:chat_app/core/helpers/constants.dart';
import 'package:chat_app/features/otp/logic/otp_state.dart';
import 'package:chat_app/features/sign_up/data/otp_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(const OtpState.initial());
  final OtpModel otpModel=sharedOtpModel;
  late String otp;
  FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  FirebaseFirestore fireStore=FirebaseFirestore.instance;


  addPhoneUser(){
    emit(const OtpState.loading());
    if(otpModel.verificationId.isNotEmpty&&otp.isNotEmpty&&otp.length==6){
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: otpModel.verificationId, smsCode: otp);

        firebaseAuth.currentUser!.linkWithCredential(credential)
            .then((value){
              emit(OtpState.success(value));
        } ).onError((error, stackTrace) {
          emit(OtpState.error(error: error.toString()));

        },);

    }else{
      emit(const OtpState.error(error: 'enter a valid otp'));
    }
  }

}