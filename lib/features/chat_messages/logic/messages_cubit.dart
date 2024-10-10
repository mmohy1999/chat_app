import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zego_zim/zego_zim.dart';
import '../../../core/helpers/constants.dart';
import '../data/chat_message.dart';
import 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit() : super(const MessagesState.initial()){
    getZegoMessages();
  }
  FirebaseAuth auth=FirebaseAuth.instance;
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  FirebaseStorage storage =FirebaseStorage.instance;
  final antherUser=contactModel;
  TextEditingController messageController = TextEditingController();
  List<ChatMessage> messagesChat=[];
  List<ZIMMessage> zegoMessageList = <ZIMMessage>[];


  File? mediaFile;

  zegoUnreadMessageClear(){
    ZIM.getInstance()!.clearConversationUnreadMessageCount(antherUser.phone, ZIMConversationType.peer);
  }

  getZegoMessages() async{
    emit(const MessagesState.loading());
    ZIMMessageQueryConfig queryConfig = ZIMMessageQueryConfig();
    queryConfig.count = 20;
    queryConfig.reverse = true;

    try {
      ZIMMessageQueriedResult result = await ZIM
          .getInstance()!
          .queryHistoryMessage(
          antherUser.phone, ZIMConversationType.peer, queryConfig);


      for (var element in result.messageList) {
        print(element.type.name);
        messagesChat.add(await ChatMessage.fromZego(element));
      }
      emit(const MessagesState.success('gg'));
      zegoUnreadMessageClear();
    } on PlatformException catch (onError) {
      log(onError.code);
    }

    streamMessagesUpdate();
  }

  sendZegoTextMessage()async{
    if(messageController.text.trim().isNotEmpty){

      try {
        ZIMTextMessage zimMessage=ZIMTextMessage(message: messageController.text);
        zimMessage.senderUserID=auth.currentUser!.phoneNumber!;
        print('id: ${zimMessage.senderUserID}');
        ZIMMessageSentResult result = await ZIM.getInstance()!.
        sendPeerMessage(zimMessage , antherUser.phone, ZIMMessageSendConfig());

          print(result.message.type.name);
          ChatMessage message =  ChatMessage.fromZego(result.message);
          messagesChat.add(message);
          messageController.clear();

        emit(MessagesState.addMessage(message));
        emit(const MessagesState.success('messagesChat'));

      } on PlatformException catch (onError) {
        log('send error,code:${onError.code}message:${onError.message!}');

      }
    }
  }

  sendZegoMediaMessage(ChatMessageType type)async{
    if (mediaFile == null) return;


    late ZIMMediaMessage mediaMessage ;
    switch(type){
      case ChatMessageType.text:
      // TODO: Handle this case.
      case ChatMessageType.audio:
      mediaMessage=ZIMAudioMessage(mediaFile!.path);
      case ChatMessageType.image:
        mediaMessage=ZIMImageMessage(mediaFile!.path);
      case ChatMessageType.video:
        mediaMessage=ZIMVideoMessage(mediaFile!.path);
    }
    mediaMessage.senderUserID=auth.currentUser!.phoneNumber!;
   final result= await ZIM.getInstance()!.sendMediaMessage(mediaMessage, antherUser.phone, ZIMConversationType.peer, ZIMMessageSendConfig(),
      ZIMMediaMessageSendNotification());

    int messageId=result.message.messageID;
    String imgUrl=(result.message as  ZIMMediaMessage).fileDownloadUrl;
    String? videoThumbnail;
    if(type==ChatMessageType.video) {
      videoThumbnail=(result.message as  ZIMVideoMessage).videoFirstFrameDownloadUrl;
    }
    ChatMessage message =ChatMessage(
      messageType: type,
      messageStatus: MessageStatus.notView,
      time: DateTime.now(),
      isSender: true,
      message: imgUrl,
      messageId: messageId.toString(),
      videoThumbnail: videoThumbnail

    );
    mediaFile=null;
    videoThumbnail=null;
     messagesChat.add(message);
    emit(MessagesState.addMessage(message));
    emit(const MessagesState.success('messagesChat'));
  }



//stream
  streamMessagesUpdate() {
    ZIMEventHandler.onReceivePeerMessage = (zim, messageList, fromUserID) async {
      if (fromUserID != antherUser.phone) {
        return;
      }
      for (ZIMMessage message in messageList) {
       final messageChat = ChatMessage.fromZego(message);
        messagesChat.add(messageChat);
        emit(MessagesState.addMessage(messageChat));
        emit(const MessagesState.success('messagesChat'));
        zegoUnreadMessageClear();
      }

    };
  }




  pickImageFromGallery() async {
    var pickedImage = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (pickedImage != null) {
      mediaFile = File(pickedImage.files.first.path!);
      sendZegoMediaMessage(ChatMessageType.image);
    }
  }

  pickVideoFromGallery() async {
    var pickedVideo= await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (pickedVideo != null) {
      mediaFile = File(pickedVideo.files.first.path!);
      sendZegoMediaMessage(ChatMessageType.video);
    }
  }
  pickAudioFromFiles() async {
    var pickedAudio= await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (pickedAudio != null) {
      mediaFile = File(pickedAudio.files.first.path!);
      sendZegoMediaMessage(ChatMessageType.audio);
    }
  }

  pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );
    if(pickedImage !=null) {
      mediaFile = File(pickedImage.path);
      sendZegoMediaMessage(ChatMessageType.image);
    }
  }

  pickVideoFromCamera() async {
    final picker = ImagePicker();
    final pickedVideo = await picker.pickVideo(
      source: ImageSource.camera,

    ).onError((error, stackTrace) {
      print('errrrrror: $error');
      return null;
    },);
    if(pickedVideo !=null) {
      mediaFile = File(pickedVideo.path);
      sendZegoMediaMessage(ChatMessageType.video);
    }
  }
}




