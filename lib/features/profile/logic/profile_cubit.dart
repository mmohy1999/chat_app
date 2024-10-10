import 'dart:io';
import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/features/profile/logic/profile_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState.initial());
  File? imageFile;
  User user=FirebaseAuth.instance.currentUser!;
  FirebaseFirestore firestore= FirebaseFirestore.instance;
  pickFromGallery() async {
      final pickedImage = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      emit(const ProfileState.loadingProfilePic());
      imageFile = File(pickedImage!.files.first.path!);
      emit(ProfileState.successProfilePic(imageFile!));
      String imgUrl= await uploadImage('images/users/${user.uid}');
      user.updatePhotoURL(imgUrl);
      firestore.collection('users').doc(user.phoneNumber).update({'img':imgUrl});



  }
  Future<String> uploadImage(String path) async{
    final ref=FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask= ref.putFile(imageFile!);
    final snapshot= await uploadTask.whenComplete(() => null);
    final url=await snapshot.ref.getDownloadURL();
    return url;
  }

  logout(BuildContext context){
    FirebaseAuth.instance.signOut().then((value) {
      context.pushNamedAndRemoveUntil(Routes.signInOrSignupScreen,predicate: (route) => false,);
    },);
  }
}
