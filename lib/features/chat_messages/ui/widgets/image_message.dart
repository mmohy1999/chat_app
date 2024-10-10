import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theming/theming_const.dart';
import '../../data/chat_message.dart';


class ImageMessage extends StatelessWidget {
  const ImageMessage({super.key,this.message});

  final ChatMessage? message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45, // 45% of total width
      child: AspectRatio(
        aspectRatio: 1.6,
        child: GestureDetector(
          onTap: () => imageView(context,),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:CachedNetworkImage(imageUrl: message!.message!) ,
          ),
        ),
      ),
    );
  }

  imageView(BuildContext context){
    return  showDialog(
      context: context,
      builder: (context) => Center( child: ClipRRect(
        child: CachedNetworkImage(imageUrl: message!.message!),
      )),
    );
  }
}
