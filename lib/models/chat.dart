import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Chat {
   late String lastMessage,chatId;
   late DateTime time;
   late UserInformation user;


  static Future<Chat> fromMap(Map<String,dynamic> data,String chatId) async{
     Chat chat =Chat();
    chat.lastMessage=data['last_msg'];
    chat.chatId=chatId;
    chat.time=(data['time'] as Timestamp).toDate();
    chat.user = await UserInformation.fromMap(FirebaseAuth.instance.currentUser!.phoneNumber==data['group'][0]?data['group'][1]:data['group'][0]);
    return chat;
  }

}

class UserInformation{
  late String name,uid,phone;
  late String? image;
  // late bool isActive;
  static Future<UserInformation>  fromMap(String phone)async{
    UserInformation information= UserInformation();
   await FirebaseFirestore.instance.collection('users').doc(phone).get().then((value){
      information.name=value.data()!['name'];
      information.image=value.data()!['img'];
      information.uid=value.data()!['uid'];
      information.phone=value.data()!['phone'];
    });

    return information;
  }




}

