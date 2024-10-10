
import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/helpers/hive_helper.dart';
import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/features/people/logic/people_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/helpers/constants.dart';
import '../data/contact.dart';

class PeopleCubit extends Cubit<PeopleState> {
  PeopleCubit() : super(const PeopleState.initial()){
    initRegisterContactsAdapter();
    contactHive=HiveHelper<ContactModel>(contactBoxHive);
  }
  late HiveHelper<ContactModel> contactHive;
  List<ContactModel> myContacts=[];
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  FirebaseAuth auth =FirebaseAuth.instance;

  initRegisterContactsAdapter()async{
    if(!Hive.isAdapterRegistered(ContactModelAdapter().typeId)){
      Hive.registerAdapter(ContactModelAdapter());
    }
  }

  getContactsFromHive()async{
    emit(const PeopleState.loading());

    await contactHive.getAll().then((value) {
      myContacts=value;
    },).onError((error, stackTrace) {
      emit(PeopleState.error(error: error.toString()));
    },);

    if(myContacts.isEmpty){
      getContactsFromFirebase();
    }else{
      emit(PeopleState.success(myContacts));
    }

  }

  getContactsFromFirebase()async{
    emit(const PeopleState.loading());
    List<Contact> contacts=[];
    if(contacts.isEmpty&&await FlutterContacts.requestPermission()){
      try {
        contacts = await FlutterContacts.getContacts(withProperties: true);
       final myCollection= firestore.collection('users');
        int counter=0;
        for (int i = 0; i < contacts.length; i++) {
          var contact = contacts[i];
          if(contact.phones.first.normalizedNumber.isNotEmpty) {
            await myCollection.doc(contact.phones.first.normalizedNumber).get().then((value){
              if(value.exists){
                var user =value.data()!;
                myContacts.insert(counter,ContactModel(name: user['name'],
                    phone: user['phone'],
                    email: user['email'],
                    isExists: true,
                    uid: user['uid'],
                    photo: user['img']
                ));
                counter++;
              } else{
                 debugPrint('{name: ${contact.displayName},phone:${contact.phones.first.normalizedNumber} }');
                 myContacts.add(ContactModel(name: contact.displayName.toString(),
                                phone: contact.phones.first.normalizedNumber.toString(),
                                  photo: 'assets/images/default_avatar.png'));
              }
            }).onError((error, stackTrace) {
              debugPrint('Error:$error');
            },);
          }


        }
        contactHive.addAll(myContacts);
        emit(PeopleState.success(myContacts));
      }catch (e){
       emit(PeopleState.error(error: e.toString()));
      }
    }
    else{
      emit(const PeopleState.error(error: 'Please allow access to contacts'));
    }

  }

  goToChat(int index,BuildContext context){
    if(myContacts[index].isExists) {
      contactModel = myContacts[index];
      context.pushNamed(Routes.messagesScreen);
    }else{
      debugPrint('not exists');
    }
  }


}
