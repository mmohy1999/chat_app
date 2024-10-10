import 'package:chat_app/features/profile/logic/profile_cubit.dart';
import 'package:chat_app/features/profile/ui/widgets/profile_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/dependency_injection.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => getIt<ProfileCubit>(),
      child: const ProfileBody() ,
    );

  }
}


