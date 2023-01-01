import 'package:flutter/material.dart';

import '../../helper/constants.dart';
class CircleAvatarWithActiveIndicator extends StatelessWidget {
  const CircleAvatarWithActiveIndicator({
    Key? key,
    this.image,
    this.radius = 24,
    this.isActive=false, this.isNetworkImage=true,
  }) : super(key: key);

  final String? image;
  final double? radius;
  final bool? isActive,isNetworkImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        isNetworkImage!?
        CircleAvatar(
          radius: radius,
          backgroundImage: NetworkImage(image!),
        ):CircleAvatar(
          radius: radius,
          backgroundImage: AssetImage(image!),
        ),
        if (isActive!)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor, width: 3),
              ),
            ),
          )
      ],
    );
  }
}
