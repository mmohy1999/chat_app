import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theming/theming_const.dart';


class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
         style:  TextButton.styleFrom(backgroundColor: const Color(0xFFF5F6F9),
         shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), padding:  const EdgeInsets.all(20)),

        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              theme: const SvgTheme(currentColor: primaryColor),
              width: 22,
            ),
            const SizedBox(width: 20),
            Expanded(child: Text(text)),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
