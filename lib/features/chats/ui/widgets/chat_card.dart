import 'package:chat_app/core/helpers/bloc_observer.dart';
import 'package:chat_app/core/helpers/spacing.dart';
import 'package:chat_app/features/chat_messages/data/chat_message.dart';
import 'package:chat_app/features/chats/logic/chats_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/theming/theming_const.dart';
import '../../data/chat.dart';
import '../../../../core/widgets/circle_avatar_with_active_indicator.dart';


class ChatCard extends StatelessWidget {
  const ChatCard({
    Key? key,
    required this.chat,
     this.press,
  }) : super(key: key);

  final Chat chat;
  final VoidCallback? press;

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
              isNetworkImage:chat.user.image!=null ,
              image: chat.user.image ?? 'assets/images/default_avatar.png',
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
                    verticalSpace(4),
                    Opacity(
                      opacity:chat.unReadMessage==0?0.64:1,
                      child:setMessageContent(chat)
                    ),

                  ],
                ),
              ),
            ),
            Opacity(
              opacity:chat.unReadMessage==0?0.64:1,
              child: Column(
                children: [
                  Text(timeago.format( chat.time,locale: 'en_short'),style:chat.unReadMessage==0?  null:const TextStyle(color: primaryColor),),
                   if(chat.unReadMessage!=0)
                   CircleAvatar(backgroundColor: primaryColor,radius: 10,child: Text(chat.unReadMessage.toString(),style: const TextStyle(color: Colors.white,fontSize:14),textAlign: TextAlign.center,),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget setMessageContent(Chat chat){
    print(chat.isSender);
    String ifUserMessage =chat.isSender?"You:":'';
    switch(chat.type) {
      case ChatMessageType.text:
        return Text(
        ifUserMessage+chat.lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,);
      case ChatMessageType.audio:
        return Row(mainAxisSize: MainAxisSize.min, children:
        [ if(ifUserMessage.isNotEmpty)
          Text(ifUserMessage),
          const Icon(Icons.settings_voice,size:18),horizontalSpace(5),
          const Text('voice')],
        );
      case ChatMessageType.image:
        return Row(mainAxisSize: MainAxisSize.min, children:
        [
          if(ifUserMessage.isNotEmpty)
          Text(ifUserMessage),
          const Icon(Icons.image,size:18),horizontalSpace(5),
          const Text('image')],
        );
      case ChatMessageType.video:
        return Row(mainAxisSize: MainAxisSize.min, children:
        [ if(ifUserMessage.isNotEmpty)
          Text(ifUserMessage),
          const Icon(Icons.video_camera_back_rounded,size:18),horizontalSpace(5),
          const Text('video',)],
        );
    }

  }
}
