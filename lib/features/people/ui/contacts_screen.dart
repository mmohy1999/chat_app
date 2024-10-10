import 'package:chat_app/features/people/ui/widgets/people_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/dependency_injection.dart';
import '../logic/people_cubit.dart';

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(create: (context) => getIt<PeopleCubit>()..getContactsFromHive(),
    child: const PeopleBody() ,
    );




  }
}
