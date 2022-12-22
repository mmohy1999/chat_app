import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../helper/constants.dart';
import '../../../../models/chat.dart';
import '../../../components/circle_avatar_with_active_indicator.dart';


class ChatCard extends StatelessWidget {
  const ChatCard({
    Key? key,
    required this.chat,
    required this.press,
  }) : super(key: key);

  final Chat chat;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding * 0.75),
        child: Row(
          children: [
            CircleAvatarWithActiveIndicator(
              image: chat.user.image ?? 'assets/default_avatar.png',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.user.name,
                      style:
                          const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        chat.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: 0.64,
              child: Text(timeago.format( chat.time,locale: 'en_short')),
            ),
          ],
        ),
      ),
    );
  }
}
