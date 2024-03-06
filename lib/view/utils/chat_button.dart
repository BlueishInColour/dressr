import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import '../chat/item.dart';

class ChatButton extends StatefulWidget {
  const ChatButton({super.key, this.color = Colors.black, required this.uid});

  final Color color;
  final String uid;
  @override
  State<ChatButton> createState() => ChatButtonState();
}

class ChatButtonState extends State<ChatButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.push(context,
              PageRouteBuilder(pageBuilder: (context, _, __) {
            return ChatItem(
              uid: widget.uid,
            );
          }));
        },
        icon: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (Rect bounds) => RadialGradient(
                  center: Alignment.topLeft,
                  stops: [.5, 1],
                  colors: [Colors.blue, Colors.purple, Colors.red],
                ).createShader(bounds),
            child: Icon(
              Icons.chat,
              size: 40,
            )));
  }
}
