import 'package:chat_app/features/chat_messages/logic/messages_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theming/theming_const.dart';
import '../../logic/messages_state.dart';
import 'chat_input_field.dart';
import 'message.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    MessagesCubit cubit=context.read<MessagesCubit>();
    return BlocBuilder<MessagesCubit, MessagesState>(
      buildWhen:(previous, current) => current is Loading||current is Success ||current is Error,
      builder: (context, state) {
        return Column(
          children: [
            state.maybeWhen(
                loading: ()=> const Expanded(child: Center(child: CircularProgressIndicator(color: primaryColor,),)),
                success: (data) =>cubit.messagesChat.isNotEmpty?
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: ListView.builder(
                      itemCount: cubit.messagesChat.length,
                      itemBuilder: (context, index) =>
                          Message(message: cubit.messagesChat[index]),
                    ),
                  ),
                ): const Expanded(child: Center(child: Text('No Chat Yet'))),
                error: (error) => Expanded(child: Center(child: Text(error))), orElse: () {
              return const SizedBox.shrink();
            }
            ),
            const ChatInputField(),

          ],
        );
      },
    );
  }
}
