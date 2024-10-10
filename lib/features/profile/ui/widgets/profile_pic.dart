import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/features/profile/logic/profile_cubit.dart';
import 'package:chat_app/features/profile/logic/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theming/theming_const.dart';


class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
     this.image,
  }) : super(key: key);

  final String? image;

  @override
  Widget build(BuildContext context) {
    final cubit=context.read<ProfileCubit>();
    return BlocBuilder<ProfileCubit, ProfileState>(
  builder: (context, state) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      margin: const EdgeInsets.symmetric(vertical: defaultPadding),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color:
              Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.08),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
      cubit.imageFile!=null?
           CircleAvatar(
            radius: 50,
            backgroundImage: FileImage(cubit.imageFile!),
          ):CircleAvatar(
            radius: 50,
            backgroundImage:CachedNetworkImageProvider(image!),
            ),
          InkWell(
            onTap: () => cubit.pickFromGallery(),
            child: CircleAvatar(
              radius: 13,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  },
);
  }
}
