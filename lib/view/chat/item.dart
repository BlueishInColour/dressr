import 'package:fashion_dragon/view/chat/message_bar.dart';
import 'package:fashion_dragon/view/profile/index.dart';
import 'package:fashion_dragon/view/utils/chat_button.dart';
import 'package:fashion_dragon/view/utils/follow-button.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chatview/chatview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_dragon/view/utils/user_details_bar.dart';
import 'package:fashion_dragon/view/utils/utils_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../explore/item/item.dart';

class ChatItem extends StatefulWidget {
  const ChatItem({
    super.key,
    required this.uid,
    this.message = const {},
    this.hintText = '',
  });

  final Map<String, dynamic> message;
  final String uid;
  final String hintText;

  @override
  State<ChatItem> createState() => ChatItemState();
}

class ChatItemState extends State<ChatItem> {
  //check or add
  checkOrAdd() async {
    //check  if you are in ther person active chat else add you to his request chat
    var res = await FirebaseFirestore.instance
        .collection('chat')
        .doc(widget.uid)
        .collection('active')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (await res.exists) {
      await FirebaseFirestore.instance
          .collection('chat')
          .doc(widget.uid)
          .collection('requests')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();
    } else {
      await FirebaseFirestore.instance
          .collection('chat')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('requests')
          .doc(widget.uid)
          .set({
        //likedById
        'followedBy': FirebaseAuth.instance.currentUser!.uid,
        //post id
        'userUid': widget.uid,
        //timeStamp
        'timestamp': Timestamp.now(),

//to order the chats
        'lastMessageTimeStamp': Timestamp.now(),
        'lastMessage': ' '
        //
      });
    }
  }

  tile(context, {String text = ''}) {
    return GestureDetector(
      //define how money will bw sent savely

      //
      child: Column(
        children: [
          CircleAvatar(child: Icon(Icons.headphones, color: Colors.white)),
          SizedBox(height: 3),
          Text(text, style: TextStyle(color: Colors.white))
        ],
      ),
    );
  }

  @override
  initState() {
    super.initState();
    checkOrAdd();
  }

  @override
  Widget build(BuildContext context) {
    List chatRoom = [FirebaseAuth.instance.currentUser!.uid, widget.uid];
    chatRoom.sort();
    String chatKey = chatRoom.join();

    return Scaffold(
      appBar: AppBar(
          foregroundColor: Colors.black,
          leadingWidth: 30,
          automaticallyImplyLeading: true,
          title: UserDetailsBar(uid: widget.uid, textColor: Colors.black),
          actions: [
            // FollowButton(
            //   userUid: widget.uid,
            //   color: Colors.black54,
            //   displayName: widget.displayName,
            //   profilePicture: widget.profilePicture,
            //   userName: widget.userName,
            // )
          ]),
      body: Column(children: [
        Expanded(
            child: FirestorePagination(
          query: FirebaseFirestore.instance
              .collection('chatroom')
              .doc(chatKey)
              .collection('messages')
              // .where('listOfChatters', isEqualTo: chatRoom)
              .orderBy('timestamp', descending: false),
          itemBuilder: (context, snap, snapshot) {
            String creator = snap['creatorUid'];
            return SizedBox(
                width: 150,
                child: Align(
                  alignment: creator == FirebaseAuth.instance.currentUser!.uid
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Item(postId: snap['postId'], showHeader: false),
                ));
          },
        )),
        MessageBarr(
          uid: widget.uid,
        )
      ]),
    );
  }
}
