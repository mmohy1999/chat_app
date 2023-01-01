import 'package:chat_app/controllers/cubit/chat/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../helper/constants.dart';
import 'components/contact_card.dart';

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        ChatCubit cubit=ChatCubit.get(context);
        if(state is LoadingState) {
          return const Center(child: CircularProgressIndicator(color: primaryColor),);

        }
        return ListView.builder(
          itemCount: cubit.myContacts.length,
          itemBuilder: (context, index) =>
              ContactCard(
                name: cubit.myContacts[index].name,
                number: cubit.myContacts[index].phone,
                image:  cubit.myContacts[index].photo!,
                isExists: cubit.myContacts[index].isExists,
                press: () {
                },
              ),
        );
      },
    );
  }
}
