import 'package:chat_app/controllers/cubit/chat/chat_cubit.dart';
import 'package:chat_app/views/screens/chats/chats_screen.dart';
import 'package:chat_app/views/screens/people/contacts_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationInitial()){
   bottomNavigationItems.add(BottomNavigationBarItem(
      icon: user.photoURL!=null? CircleAvatar(
        radius: 14,
        backgroundImage: NetworkImage(user.photoURL!),
      ): const CircleAvatar(
        radius: 14,
        backgroundImage: AssetImage('assets/default_avatar.png'),
      ),
      label: "Profile",
    ));
  }

  static NavigationCubit get(context) => BlocProvider.of(context);
  int currentIndex=0;
  User user=FirebaseAuth.instance.currentUser!;
  String title='Chats';
  List<BottomNavigationBarItem> bottomNavigationItems= [
    const BottomNavigationBarItem(
      icon: Icon(Icons.messenger), label: "Chats",),
    const BottomNavigationBarItem(
        icon: Icon(Icons.people), label: "People"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.call), label: "Calls"),
  ];

  List screens=[
    const ChatsScreen(),
    const PeopleScreen(),
    const Scaffold(body: Center( child: Text('calls')),),
    const Scaffold(body: Center( child: Text('profile')),),
  ];


  changeCurrentIndex(int index, ChatCubit cubit){
    if(currentIndex!=index){
      title=index==0?'Chats':index==1?'People':index==2?'Calls':'Profile';
      currentIndex=index;
      emit(ChangeIndex());
      if(index==1){
        cubit.getContacts();
      }
    }
  }


}
