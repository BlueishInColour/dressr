import 'package:dressr/screens/chat/index.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ChatScreenButton extends StatelessWidget {
  const ChatScreenButton({super.key, required this.listOfFriends});
  final List<String> listOfFriends;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.push(context,
              PageRouteBuilder(pageBuilder: (context, _, __) {
            return ChatScreen(
              typeOfChat: 'active',
              listOfFriends: listOfFriends,
            );
          }));
        },
        icon: Icon(
          Ionicons.chatbox_ellipses_outline,
          color: Colors.black,
          size: 32,
        ));
  }
}
