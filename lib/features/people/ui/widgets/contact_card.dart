import 'package:flutter/material.dart';
import '../../../../core/theming/theming_const.dart';
import '../../../../core/widgets/circle_avatar_with_active_indicator.dart';

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
      onTap: press,
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
                Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.64),
          ),
        ),
      ),
      trailing:isExists? null:ElevatedButton(onPressed: (){
        print('invite');
      }, child: const Text('invite')) ,
    );
  }
}
