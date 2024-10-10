import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/features/chat_messages/data/chat_message.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/theming/theming_const.dart';


class VideoMessage extends StatefulWidget {
   VideoMessage({super.key, required this.message});
  final ChatMessage message;

  @override
  State<VideoMessage> createState() => _VideoMessageState();
}

class _VideoMessageState extends State<VideoMessage> {
   late VideoPlayerController _controller;
   late ChewieController chewieController ;

   @override
  void initState() {
     initVideo();
    super.initState();
  }

  initVideo()async{
     print(widget.message.message!);
    _controller= VideoPlayerController.networkUrl(Uri.parse(widget.message.message!));

    await _controller.initialize().onError((error, stackTrace) {
        print('Errrror: $error');
      },);

    setState(() {

    });
  }
   @override
   void dispose() {
     _controller.dispose();
     super.dispose();
   }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45, // 45% of total width
      child: AspectRatio(
        aspectRatio: 1.6,
        child: InkWell(
          onTap: () => videoView(context),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:CachedNetworkImage(imageUrl:widget.message.videoThumbnail!),
              ),
              Container(
                height: 25,
                width: 25,
                decoration: const BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                // ignore: prefer_const_constructors
                child: Icon(
                  Icons.play_arrow,
                  size: 16,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

   videoView(BuildContext context){
     chewieController= ChewieController(
       videoPlayerController: _controller,
       autoPlay: true,

       controlsSafeAreaMinimum: const EdgeInsets.only(bottom: 8),
     );
     return  showDialog(
       context: context,
       builder: (context) => Center( child:_controller.value.isInitialized? Chewie(controller: chewieController,

       ):const CircularProgressIndicator()),
     ).whenComplete(() {
       _controller.seekTo(Duration.zero);
       _controller.pause();
       chewieController.dispose();
     },);

   }
}
