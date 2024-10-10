import 'package:flutter/material.dart';

import 'widgets/call_history_card.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
          children: [
            // For demo
            ...List.generate(
              10,
                  (index) => CallHistoryCard(
                name: "Darlene Robert",
                image: 'https://firebasestorage.googleapis.com/v0/b/chat-6cf94.appspot.com/o/images%2Fdefualt_avater.png?alt=media&token=9125ad8d-e438-40f5-b6e3-7e12aa76d480',
                time: "3m ago",
                isActive: index.isEven,
                isOutgoingCall: index.isOdd,
                isVideoCall: index.isEven,
                press: () {},
              ),
            ),
          ],
        );
  }
}
