import 'package:chat_app/controllers/cubit/chat/chat_cubit.dart';
import 'package:chat_app/controllers/cubit/navigation/navigation_cubit.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavigationLayout extends StatelessWidget {
  const BottomNavigationLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NavigationCubit()),
        BlocProvider(create: (context) => ChatCubit()),
      ],
      child: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          NavigationCubit cubit =NavigationCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor,
              automaticallyImplyLeading: false,
              title:  Text(cubit.title),
              actions: [
                cubit.title=='profile'?
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
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index) => cubit.changeCurrentIndex(index, ChatCubit.get(context)),
                items: cubit.bottomNavigationItems
            ),
            floatingActionButton:cubit.title!='Chats'?null: FloatingActionButton(
              onPressed: () {
                cubit.changeCurrentIndex(1,ChatCubit.get(context));


              },
              backgroundColor: primaryColor,
              child: const Icon(
                Icons.person_add_alt_1,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
