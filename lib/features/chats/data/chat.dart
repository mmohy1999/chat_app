import 'package:chat_app/features/chat_messages/data/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zego_zim/zego_zim.dart';


class Chat {
   late String lastMessage;
   late ChatMessageType type;
   late MessageStatus status;
   late bool isSender;
   late DateTime time;
   late UserInformation user;
   late int unReadMessage;


   static Future<Chat> fromZegoCon(ZIMConversation zim) async{
     Chat chat =Chat();
     chat.lastMessage= getLastMessageValue(zim.lastMessage);
     chat.isSender =isUserSender(zim.lastMessage);
     chat.status=MessageStatus.fromString(getLastMessageStatus(zim));
     chat.type=ChatMessageType.fromString(getLastMessageType(zim.lastMessage));
     chat.time=  DateTime.fromMillisecondsSinceEpoch(zim.lastMessage!.timestamp);
     chat.user = await UserInformation.fromMap(zim.conversationID);
     chat.unReadMessage= zim.unreadMessageCount;
     return chat;
   }

   static bool isUserSender(ZIMMessage? lastMessage){
     if(lastMessage!.senderUserID==FirebaseAuth.instance.currentUser!.phoneNumber){
       return true;
     }
     return false;
   }
   static String getLastMessageStatus(ZIMConversation zim){
    if(zim.unreadMessageCount==0) {
      return 'viewed';
    }
    return 'notView';
   }
   static String getLastMessageType(ZIMMessage? lastMessage) {
     String targetMessage;
     switch (lastMessage!.type) {
       case ZIMMessageType.text:
         targetMessage = 'text';
         break;
       case ZIMMessageType.command:
         targetMessage = 'cmd';
         break;
       case ZIMMessageType.barrage:
         targetMessage = 'text';
         break;
       case ZIMMessageType.audio:
         targetMessage = 'audio';
         break;
       case ZIMMessageType.video:
         targetMessage = 'video';
         break;
       case ZIMMessageType.file:
         targetMessage = 'file';
         break;
       case ZIMMessageType.image:
         targetMessage = 'image';
         break;
       default:
         {
           targetMessage = '[unknown message type]';
         }
     }
     return targetMessage;
   }
   static String getLastMessageValue(ZIMMessage? lastMessage) {
     String targetMessage;
     switch (lastMessage!.type) {
       case ZIMMessageType.text:
         targetMessage = (lastMessage as ZIMTextMessage).message;
         break;
       case ZIMMessageType.command:
         targetMessage = '[cmd]';
         break;
       case ZIMMessageType.barrage:
         targetMessage = (lastMessage as ZIMBarrageMessage).message;
         break;
       case ZIMMessageType.audio:
         targetMessage = '[audio]';
         break;
       case ZIMMessageType.video:
         targetMessage = '[video]';
         break;
       case ZIMMessageType.file:
         targetMessage = '[file]';
         break;
       case ZIMMessageType.image:
         targetMessage = '[image]';
         break;
       default:
         {
           targetMessage = '[unknown message type]';
         }
     }
     return targetMessage;
   }

}

class UserInformation{
  late String name,uid,phone;
  late String? image;
  // late bool isActive;
  static Future<UserInformation>  fromMap(String phone)async{
    UserInformation information= UserInformation();
   print(phone);
   await FirebaseFirestore.instance.collection('users').doc(phone).get().then((value){
      information.name=value.data()!['name']??'Name';
      information.image=value.data()!['img']??'https://firebasestorage.googleapis.com/v0/b/chat-6cf94.appspot.com/o/images%2Fdefualt_avater.png?alt=media&token=9125ad8d-e438-40f5-b6e3-7e12aa76d480';
      information.uid=value.data()!['uid']??phone;
      information.phone=value.data()!['phone']??phone;
    });

    return information;
  }




}

