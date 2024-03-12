import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_dragon/view/chat/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:ionicons/ionicons.dart';

// import 'package:flutter/material.dart';

class ChatScreenButton extends StatefulWidget {
  const ChatScreenButton({super.key});

  @override
  State<ChatScreenButton> createState() => ChatScreenButtonState();
}

class ChatScreenButtonState extends State<ChatScreenButton> {
  List<String> listOfFriends = [];

  // initialize bucket globally

  getListOfFriends() async {
    var res = await FirebaseFirestore.instance
        .collection('chat')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('active')
        .get();

    setState(() {
      res.docs.forEach(
        (element) {
          String uid = element['userUid'];
          debugPrint(uid);

          listOfFriends.add(uid);
        },
      );
      debugPrint(listOfFriends.toString());
    });

    debugPrint(listOfFriends.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListOfFriends();
  }

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
          // Ionicons.chatbox_ellipses_outline,
          Icons.chat_bubble_outline,
          color: Colors.black,
          size: 18,
        ));
  }
}
