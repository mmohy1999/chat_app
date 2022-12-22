import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/chat.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(LoadingState()){
    getDataFromDatabase();
  }
  static ChatCubit get(context) => BlocProvider.of(context);

  bool isActive=false;
  User user=FirebaseAuth.instance.currentUser!;
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  // List<Chat> chatsData = [
  //   Chat(
  //     name: "Jenny Wilson",
  //     lastMessage: "Hope you are doing well...",
  //     image: "assets/images/user.png",
  //     time: "3m ago",
  //     isActive: false,
  //   ),
  //   Chat(
  //     name: "Esther Howard",
  //     lastMessage: "Hello Abdullah! I am...",
  //     image: "assets/images/user_2.png",
  //     time: "8m ago",
  //     isActive: true,
  //   ),
  //   Chat(
  //     name: "Ralph Edwards",
  //     lastMessage: "Do you have update...",
  //     image: "assets/images/user_3.png",
  //     time: "5d ago",
  //     isActive: false,
  //   ),
  //   Chat(
  //     name: "Jacob Jones",
  //     lastMessage: "You’re welcome :)",
  //     image: "assets/images/user_4.png",
  //     time: "5d ago",
  //     isActive: true,
  //   ),
  //   Chat(
  //     name: "Albert Flores",
  //     lastMessage: "Thanks",
  //     image: "assets/images/user_5.png",
  //     time: "6d ago",
  //     isActive: false,
  //   ),
  //   Chat(
  //     name: "Jenny Wilson",
  //     lastMessage: "Hope you are doing well...",
  //     image: "assets/images/user.png",
  //     time: "3m ago",
  //     isActive: false,
  //   ),
  //   Chat(
  //     name: "Esther Howard",
  //     lastMessage: "Hello Abdullah! I am...",
  //     image: "assets/images/user_2.png",
  //     time: "8m ago",
  //     isActive: true,
  //   ),
  //   Chat(
  //     name: "Ralph Edwards",
  //     lastMessage: "Do you have update...",
  //     image: "assets/images/user_3.png",
  //     time: "5d ago",
  //     isActive: false,
  //   ),
  // ];
  List<Chat> chats=[];

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
