import 'package:chat_app/core/helpers/spacing.dart';
import 'package:chat_app/features/chats/logic/chats_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theming/theming_const.dart';
import '../../logic/chats_cubit.dart';
import 'chat_card.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({super.key});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  late ChatsCubit cubit;
  bool isFirstBuild=true;
  @override
  void initState() {
    cubit= context.read<ChatsCubit>();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsCubit, ChatsState>(
      buildWhen:(previous, current) => current is Loading||current is Success ||current is Error || current is LoadingChat ,
      builder: (context, state) => state.maybeWhen(
        loading: ()=> const Expanded(child: Center(child: CircularProgressIndicator(color: primaryColor,),)),
        success: (data) =>data.isNotEmpty?
        Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) =>
                Dismissible(
                  
                  key: Key('${DateTime.now().microsecond}'),
                    direction: DismissDirection.endToStart,
                    background: Container(color: primaryColor,child: Row(mainAxisAlignment: MainAxisAlignment.end,
                    children: [const Icon(Icons.delete,color: Colors.redAccent,size: 32,),horizontalSpace(20)]),),
                    onDismissed: (direction) {
                      cubit.deleteChat(index);
                    },
                    child: ChatCard(
                      chat: data[index],
                      press: () => cubit.goToChat(index,context)
                  ),
                ),
          ),
        ): const Expanded(child: Center(child: Text('No Chat Yet'))) ,
        error: (error) => Expanded(child: Center(child: Text(error))), orElse: () {
          return const SizedBox.shrink();
      }
      )
    );

  }
}
