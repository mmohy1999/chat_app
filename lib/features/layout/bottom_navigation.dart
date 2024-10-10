import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/features/calls/ui/calls_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/theming/theming_const.dart';
import '../chats/ui/chats_screen.dart';
import '../people/ui/contacts_screen.dart';
import '../profile/ui/profile_screen.dart';


class BottomNavigationLayout extends StatefulWidget {
   const BottomNavigationLayout({Key? key}) : super(key: key);

  @override
  State<BottomNavigationLayout> createState() => _BottomNavigationLayoutState();
}

class _BottomNavigationLayoutState extends State<BottomNavigationLayout> {
  @override
  void initState() {
    // TODO: implement initState
    final user=FirebaseAuth.instance.currentUser!;

    bottomNavigationItems.add(BottomNavigationBarItem(
      icon: user.photoURL!=null? CircleAvatar(
        radius: 14,
        backgroundImage: CachedNetworkImageProvider(user.photoURL!),
      ): const CircleAvatar(
        radius: 14,
        backgroundImage: AssetImage('assets/images/default_avatar.png'),
      ),
      label: "Profile",
    ));
    super.initState();
  }
  List titles =['Chats','People','Calls','Profile'];
  List<BottomNavigationBarItem> bottomNavigationItems= [
    const BottomNavigationBarItem(
      icon: Icon(Icons.messenger), label: "Chats",),
    const BottomNavigationBarItem(
        icon: Icon(Icons.people), label: "People"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.call), label: "Calls"),
  ];
  int currentIndex=0;
  List screens=[
     const ChatsScreen(),
    const PeopleScreen(),
    const CallScreen(),
    const ProfileScreen(),

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        title:  Text(titles[currentIndex]),//change when
        actions: [
          currentIndex==3?
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ):
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) => changeCurrentIndex(index),
          items:bottomNavigationItems
      ),
      floatingActionButton:currentIndex!=0?null: FloatingActionButton(
        onPressed: () {
          changeCurrentIndex(1);

        },
        backgroundColor: primaryColor,
        child: const Icon(
          Icons.person_add_alt_1,
          color: Colors.white,
        ),
      ),
    );

  }

  changeCurrentIndex( int index){
    setState(() {
      currentIndex=index;
    });
  }
}
