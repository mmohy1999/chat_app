import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zego_zim/src/zim_defines.dart';

enum ChatMessageType { text, audio, image, video;
  static ChatMessageType fromString(String s) => switch (s) {
    "text" => text,
    "audio" => audio,
    "image" => image,
    "video"=>video,
    // TODO: Handle this case.
    String() => throw UnimplementedError(),
  };
}
enum MessageStatus { notSent, notView, viewed;
  static MessageStatus fromString(String s) => switch (s) {
    "notSent" => notSent,
    "notView" => notView,
    "viewed" => viewed,
  // TODO: Handle this case.
    String() => throw UnimplementedError(),
  };}

class ChatMessage {
   String? message,messageId,videoThumbnail;//link Media or message
   ChatMessageType? messageType;
   MessageStatus? messageStatus;
   DateTime? time;
   bool? isSender;

  ChatMessage({
    this.messageId,
    this.message = '',
     this.messageType,
     this.messageStatus,
     this.time,
     this.isSender,
    this.videoThumbnail
  });


   static ChatMessage fromZego(ZIMMessage zego)  {
     return ChatMessage(
         isSender:zego.senderUserID==FirebaseAuth.instance.currentUser!.phoneNumber,
         messageStatus: MessageStatus.fromString('viewed'),
         messageType:ChatMessageType.fromString(zego.type.name),
          time:DateTime.fromMillisecondsSinceEpoch(zego.timestamp),
         messageId: zego.messageID.toString(),
         message:getMessageValue(zego),
        videoThumbnail:getVideoThumbnail(zego)
     );
   }

   // static String getMessageStatus(ZIMMessage zego){
   //  if(zego.type==ZIMMessageType.text) {
   //    print('Message:${(zego as ZIMTextMessage).message} State:${zego.senderUserID}');
   //  }
   //    return 'viewed';
   // }

   static String? getVideoThumbnail(ZIMMessage zego){
    if(zego.type==ZIMMessageType.video){
      return (zego as ZIMVideoMessage).videoFirstFrameDownloadUrl;
    }

     return null;
   }
   static String getMessageValue(ZIMMessage zego){
     switch(zego.type){
       case ZIMMessageType.unknown:
         return '';
       case ZIMMessageType.text:
         return (zego as ZIMTextMessage).message;
       case ZIMMessageType.command:
         // TODO: Handle this case.
       case ZIMMessageType.barrage:
         // TODO: Handle this case.
       case ZIMMessageType.image:
         return (zego as ZIMImageMessage).fileDownloadUrl;
       case ZIMMessageType.file:
         // TODO: Handle this case.
       case ZIMMessageType.audio:
       return  (zego as ZIMAudioMessage).fileDownloadUrl;
       case ZIMMessageType.video:
         return  (zego as ZIMVideoMessage).fileDownloadUrl;
       case ZIMMessageType.system:
         // TODO: Handle this case.
       case ZIMMessageType.revoke:
         // TODO: Handle this case.
       case ZIMMessageType.custom:
         // TODO: Handle this case.
       case ZIMMessageType.tips:
         // TODO: Handle this case.
       case ZIMMessageType.combine:
         // TODO: Handle this case.
     }
     return'';
   }
   static String getMessageType(ZIMMessage? lastMessage) {
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


}

