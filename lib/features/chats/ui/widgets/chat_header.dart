import 'package:flutter/material.dart';

import '../../../../core/theming/theming_const.dart';
import '../../../../core/widgets/filled_outline_button.dart';

class ChatHeader extends StatefulWidget {
  const ChatHeader({super.key});

  @override
  State<ChatHeader> createState() => _ChatHeaderState();
}

class _ChatHeaderState extends State<ChatHeader> {
  bool isActive=false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          defaultPadding, 0, defaultPadding, defaultPadding),
      color: primaryColor,
      child: Row(
        children: [
          FillOutlineButton(
            text: "Recent Message",
            press: () {
              setState(() {
                isActive=false;
              });
            },
            isFilled: !isActive,
          ),
          const SizedBox(width: defaultPadding),
          FillOutlineButton(
            press: () {
              setState(() {
                isActive=true;
              });
            },
            text: "Active",
            isFilled:isActive ,
          ),
        ],
      ),
    );
  }
}
