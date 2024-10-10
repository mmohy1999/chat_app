import 'package:chat_app/features/profile/logic/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theming/theming_const.dart';
import '../../../../core/widgets/primary_button.dart';
import 'info.dart';
import 'profile_pic.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit= context.read<ProfileCubit>();
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Column(
        children: [
          ProfilePic(image: cubit.user.photoURL),
          Text(
            cubit.user.displayName!,
            style: Theme
                .of(context)
                .textTheme
                .titleLarge,
          ),
          const Divider(height: defaultPadding * 2),
          Info(
            infoKey: "User ID",
            info: cubit.user.uid,
          ),
          Info(
            infoKey: "Phone",
            info: cubit.user.phoneNumber!,
          ),
          Info(
            infoKey: "Email Address",
            info: cubit.user.email!,
          ),
          const SizedBox(height: defaultPadding),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 120,
              child: PrimaryButton(
                padding: const EdgeInsets.all(5),
                color: Colors.redAccent,
                text: "Logout",
                press: ()=>cubit.logout(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
