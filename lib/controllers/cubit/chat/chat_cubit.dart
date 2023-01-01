import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../../../models/chat.dart';
import '../../../models/contact.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(LoadingState()){
    getDataFromDatabase();
  }
  static ChatCubit get(context) => BlocProvider.of(context);

  bool isActive=false;
  User user=FirebaseAuth.instance.currentUser!;
  FirebaseFirestore firestore=FirebaseFirestore.instance;
 late List<Contact> contacts=[];
  List<Chat> chats=[];
  List<ContactModel> myContacts=[];

  goToChat(BuildContext context,String chatId){
    print(chatId);
  }
  getContacts()async{

    if(contacts.isEmpty&&await FlutterContacts.requestPermission()){
      emit(LoadingState());

      try {
      contacts = await FlutterContacts.getContacts(withProperties: true);

      for (var contact in contacts) {
       if(contact.phones.first.normalizedNumber.isNotEmpty) {
         await firestore.collection('users').doc(contact.phones.first.normalizedNumber).get().then((value){
          if(value.exists){
            var user =value.data()!;
            myContacts.insert(0,ContactModel(name: user['name'], phone: user['phone'], email: user['email'], isExists: true,uid: user['uid'],photo: user['img']));
          } else{
            myContacts.add(ContactModel(name: contact.displayName, phone: contact.phones.first.normalizedNumber,photo: 'assets/images/user_1.png'));
          }
        });
       }
      }
      emit(GetData());
    }catch (e){
      print('error:$e');
    }
    }

  }

  changeActiveButton(bool active){
    if(active!=isActive){
      isActive=active;
      emit(ChangeButton());
    }
  }

  getDataFromDatabase()async{
    var chatsId = await getChatsId();

    for (var id in chatsId) {
      await getChat(id);
    }
    emit(GetData());
  }

  getChat(String id) async{
    await firestore.collection('chats').doc(id).get().then((value) async{
      chats.add(await Chat.fromMap(value.data()!,value.id));
    });
  }

  Future<List> getChatsId() async{
    List chats=[];
   await firestore.collection('users').doc(user.phoneNumber!).get().then((value){
     chats= value.data()!['chats'];
    });

    return chats;
  }

}
