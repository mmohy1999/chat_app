import 'package:flutter/material.dart';
import '../../../../core/theming/theming_const.dart';
import '../../../../core/widgets/circle_avatar_with_active_indicator.dart';


class CallHistoryCard extends StatelessWidget {
  const CallHistoryCard({
    Key? key,
    required this.name,
    required this.time,
    required this.isActive,
    required this.isVideoCall,
    required this.isOutgoingCall,
    required this.image,
    required this.press,
  }) : super(key: key);

  final String name, time, image;
  final bool isActive, isVideoCall, isOutgoingCall;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      onTap: () {},
      leading: CircleAvatarWithActiveIndicator(
        image: image,
        isActive: isActive,
        radius: 28,
      ),
      title: Text(name),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
        child: Row(
          children: [
            Icon(
              isOutgoingCall ? Icons.north_east : Icons.south_west,
              size: 16,
              color:
              isOutgoingCall ? Theme.of(context).primaryColor : errorColor,
            ),
            const SizedBox(width: defaultPadding / 2),
            Text(
              time,
              style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .color!
                    .withOpacity(0.64),
              ),
            ),
          ],
        ),
      ),
      trailing: Icon(
        isVideoCall ? Icons.videocam : Icons.call,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}