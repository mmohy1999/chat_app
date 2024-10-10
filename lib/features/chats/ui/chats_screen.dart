import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/dependency_injection.dart';
import '../logic/chats_cubit.dart';
import 'widgets/chat_body.dart';
import 'widgets/chat_header.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChatsCubit>(),
      child: const Column(
        children: [
          ChatHeader(),
          ChatBody(),
        ],
      ),
    );
  }

}
