import 'package:chat_app/controllers/cubit/chat/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../helper/constants.dart';
import '../../components/filled_outline_button.dart';
import 'components/chat_card.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        ChatCubit cubit=ChatCubit.get(context);
        if(state is LoadingState) {
          return const Center(child: CircularProgressIndicator(color: primaryColor),);
        }
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(
                  defaultPadding, 0, defaultPadding, defaultPadding),
              color: primaryColor,
              child: Row(
                children: [
                  FillOutlineButton(
                    text: "Recent Message",
                    press: () {
                      cubit.changeActiveButton(false);
                    },
                    isFilled: !cubit.isActive,
                  ),
                  const SizedBox(width: defaultPadding),
                  FillOutlineButton(
                    press: () {
                      cubit.changeActiveButton(true);
                    },
                    text: "Active",
                    isFilled:cubit.isActive ,
                  ),
                ],
              ),
            ),
            cubit.chats.isNotEmpty?
            Expanded(
              child: ListView.builder(
                itemCount: cubit.chats.length,
                itemBuilder: (context, index) =>
                    ChatCard(
                        chat: cubit.chats[index],
                        press: () => cubit.goToChat(context, cubit.chats[index].chatId)
                    ),
              ),
            ):
            const Expanded(child: Center(
              child: Text('No Chat Yet'),
            ))
            ,
          ],
        );
      },
    );
  }

}
