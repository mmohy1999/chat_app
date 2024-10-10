import 'package:chat_app/core/helpers/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zego_zim/zego_zim.dart';
import '../../../core/helpers/constants.dart';
import '../../../core/routing/routes.dart';
import '../../people/data/contact.dart';
import '../data/chat.dart';
import 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit() : super(const ChatsState.initial()){
    user=FirebaseAuth.instance.currentUser!;
    loginZego();
  }
  late User user;
  List<Chat> chats=[];
  final List<ZIMConversation> zegoCov = [];
  
  loginZego() async{
    emit(const ChatsState.loading());
    final zimLoginConfig =ZIMLoginConfig();
    zimLoginConfig.userName=user.displayName!;
    zimLoginConfig.token=user.phoneNumber!;
    await ZIM.getInstance()!.login(user.phoneNumber.toString(), ZIMLoginConfig());
    await getChats();
    streamChatsUpdate();
  }
  getChats() async{
    final queryConfig =  ZIMConversationQueryConfig();
    queryConfig.count = 20;
    try {
      ZIMConversationListQueriedResult result =
          await ZIM.getInstance()!.queryConversationList(queryConfig);
        zegoCov.addAll(result.conversationList);
      for (ZIMConversation newConversation in result.conversationList){
        print(Chat.getLastMessageValue(newConversation.lastMessage));
         chats.add(await Chat.fromZegoCon(newConversation));
      }
      emit(ChatsState.success(chats));
    } on PlatformException catch (onError) {
      print(onError.message);
      return null;
    }
  }
  deleteChat(int index)async{
    var deleteMassage= ZIMMessageDeleteConfig();
    var deleteCon=ZIMConversationDeleteConfig();
    deleteMassage.isAlsoDeleteServerMessage=true;
    deleteCon.isAlsoDeleteServerConversation=true;
    await ZIM.getInstance()!.deleteAllMessage(chats[index].user.phone, ZIMConversationType.peer, deleteMassage);
    await ZIM.getInstance()!.deleteConversation(chats[index].user.phone, ZIMConversationType.peer, deleteCon);

  }


  goToChat(int index,BuildContext context){


      contactModel =ContactModel(name: chats[index].user.name, phone: chats[index].user.phone, photo: chats[index].user.image!);
      context.pushNamed(Routes.messagesScreen);

  }
  streamChatsUpdate()async {
    ZIMEventHandler.onConversationChanged = (zim, conversationChangeInfoList) async {
      for (ZIMConversationChangeInfo changeInfo in conversationChangeInfoList) {
       print(changeInfo.event.name);
        switch (changeInfo.event) {
          case ZIMConversationEvent.added:
            print('Added Chat');
            chats.insert(0,await Chat.fromZegoCon(changeInfo.conversation!));
            emit(  const ChatsState.successAddChat());
            emit(ChatsState.success(chats));
            break;
          case ZIMConversationEvent.updated:
            print('Updated Chat');
            int index= chats.indexWhere((element) {
            if( element.user.phone==changeInfo.conversation!.conversationID) {
              return true;
            } else {
              return false;
            }
           },);
          if(index != -1){
            chats[index]=await Chat.fromZegoCon(changeInfo.conversation!);

            chats.insert(0, chats[index]);
            chats.removeAt(++index);
            emit(const ChatsState.loadingAddChat());
            emit(ChatsState.success(chats));
          }
            break;
          case ZIMConversationEvent.deleted:
            print('Deleted Chat');
            int index= chats.indexWhere((element) {
              if( element.user.phone==changeInfo.conversation!.conversationID) {
                return true;
              } else {
                return false;
              }
            },);
            if(index != -1){
              chats.removeAt(index);
              emit(const ChatsState.loadingAddChat());
              emit(ChatsState.success(chats));
            }
            break;
          default:
        }

      }
    };
  }

}

