import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/helpers/constants.dart';
import '../../../core/theming/theming_const.dart';
import 'widgets/body.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: const Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const BackButton(),
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(contactModel.photo),
          ),
          const SizedBox(width: defaultPadding * 0.75),
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contactModel.name,
                style: const TextStyle(fontSize: 16),
              ),
              // Text(
              //   "Active 3m ago",
              //   style: TextStyle(fontSize: 12),
              // )
            ],
          )
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.local_phone), onPressed: () {}),
        IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
        const SizedBox(width: defaultPadding / 2),
      ],
    );
  }
}
