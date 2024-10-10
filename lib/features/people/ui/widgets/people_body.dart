import 'package:chat_app/features/people/logic/people_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theming/theming_const.dart';
import '../../logic/people_state.dart';
import 'contact_card.dart';

class PeopleBody extends StatelessWidget {
  const PeopleBody({super.key});

  @override
  Widget build(BuildContext context) {
    PeopleCubit cubit=context.read<PeopleCubit>();

    return BlocBuilder<PeopleCubit,PeopleState>(
        buildWhen:(previous, current) => current is Loading||current is Success ||current is Error,
        builder: (context, state) => state.maybeWhen(
            loading: ()=> const Center(child: CircularProgressIndicator(color: primaryColor,),),
            success: (data) =>cubit.myContacts.isNotEmpty?
            ListView.builder(
              itemCount: cubit.myContacts.length,
              itemBuilder: (context, index) =>
                  ContactCard(
                    name: cubit.myContacts[index].name,
                    number: cubit.myContacts[index].phone,
                    image:  cubit.myContacts[index].photo,
                    isExists: cubit.myContacts[index].isExists,
                    press: () {
                      cubit.goToChat(index, context);
                    },
                  ),
            ): const Center(child: Text('No Contacts Found')) ,
            error: (error) => Center(child: Text(error)), orElse: () {
          return const SizedBox.shrink();
        }
        )
    );


  }
}
