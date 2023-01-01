import 'package:chat_app/views/components/primary_button.dart';
import 'package:flutter/material.dart';

import '../../../../helper/constants.dart';
import '../../../components/circle_avatar_with_active_indicator.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    Key? key,
    required this.name,
    required this.number,
    required this.image,
    required this.press, required this.isExists,
  }) : super(key: key);

  final String name, number, image;
  final bool isExists;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
          horizontal: defaultPadding, vertical: defaultPadding / 2),
      onTap: () {},
      leading: CircleAvatarWithActiveIndicator(
        isNetworkImage: image.startsWith('https'),
        image: image,
        radius: 28,
      ),
      title: Text(name),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: defaultPadding / 2),
        child: Text(
          number,
          style: TextStyle(
            color:
                Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.64),
          ),
        ),
      ),
      trailing:isExists? null:ElevatedButton(onPressed: (){
        print('invite');
      }, child: const Text('invite',style: TextStyle(color: Colors.white),)) ,
    );
  }
}
