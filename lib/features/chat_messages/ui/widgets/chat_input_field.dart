import 'dart:ffi';

import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/helpers/spacing.dart';
import 'package:chat_app/features/chat_messages/data/chat_message.dart';
import 'package:chat_app/features/chat_messages/logic/messages_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theming/theming_const.dart';
import 'attachment_card.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({
    Key? key,
  }) : super(key: key);

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  bool _showAttachment = false;
  bool _isFieldEmpty = true;
  late MessagesCubit cubit ;
  void _updateAttachmentState() {
    setState(() {
      _showAttachment = !_showAttachment;
    });
  }
  @override
  void initState() {
    cubit=context.read<MessagesCubit>();
    setupMessageControllerListener();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          if (_showAttachment)  messageAttachment(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding / 2,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -4),
                  blurRadius: 32,
                  color: const Color(0xFF087949).withOpacity(0.08),
                ),
              ],
            ),
            child: Row(
              children: [
                if(_isFieldEmpty)
                const Icon(Icons.mic, color: primaryColor),
                if(_isFieldEmpty)
                const SizedBox(width: defaultPadding),
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: defaultPadding / 4),
                      Expanded(
                        child: TextField(
                          controller: cubit.messageController,
                          decoration: InputDecoration(
                              hintText: "Type message",
                              suffixIcon:_isFieldEmpty?
                              SizedBox(
                                width: 65,
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: _updateAttachmentState,
                                      child: Icon(
                                        Icons.attach_file,
                                        color: _showAttachment
                                            ? primaryColor
                                            : Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color!
                                                .withOpacity(0.64),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: defaultPadding / 2),
                                      child: InkWell(
                                         onTap: () => cubit.pickImageFromCamera(),
                                         onLongPress: () => cubit.pickVideoFromCamera(),
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color!
                                              .withOpacity(0.64),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ):
                              InkWell(
                                onTap: () {
                                  cubit.sendZegoTextMessage();
                                },
                                child: const Icon(
                                  Icons.send,
                                  color: primaryColor
                                ),
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget messageAttachment(){
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MessageAttachmentCard(
            iconData: Icons.insert_drive_file,
            title: "Document",
            press: () {},
          ),
          MessageAttachmentCard(
            iconData: Icons.image,
            title: "Gallery",
            press: () {
              _showAttachment=false;
              setState(() {

                cubit.pickImageFromGallery();


              });
            },
          ),
          MessageAttachmentCard(
            iconData: Icons.headset,
            title: "Audio",
            press: () {
              _showAttachment=false;
              setState(() {
                 cubit.pickAudioFromFiles();
              });
            },
          ),
          MessageAttachmentCard(
            iconData: Icons.videocam,
            title: "Video",
            press: () {
              _showAttachment=false;

              setState(() {
                 cubit.pickVideoFromGallery();
              });
            },
          ),
        ],
      ),
    );
  }


  void setupMessageControllerListener() {
    cubit.messageController.addListener(() {
      setState(() {
        _isFieldEmpty=cubit.messageController.text.isEmpty;
      });
    },);
  }
  }
