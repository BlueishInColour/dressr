import 'package:fashion_dragon/view/utils/add_showlist_button.dart';
import 'package:fashion_dragon/view/utils/chat_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_dragon/view/utils/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class FollowButton extends StatefulWidget {
  const FollowButton(
      {super.key,
      required this.userUid,
      required this.displayName,
      required this.profilePicture,
      required this.userName,
      this.color = Colors.white60});
  final Color color;
  final String userUid; //canbe postsid or style id
  final String userName;
  final String displayName;
  final String profilePicture;

  @override
  State<FollowButton> createState() => FollowButtonState();
}

class FollowButtonState extends State<FollowButton> {
  like() async {
    await FirebaseFirestore.instance
        .collection('chat')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('active')
        .doc(widget.userUid)
        .set({
      //likedById
      'followedBy': FirebaseAuth.instance.currentUser!.uid,
      //post id
      'userUid': widget.userUid,
      //timeStamp
      'timestamp': Timestamp.now(),

//to order the chats
      'lastMessageTimeStamp': Timestamp.now(),
      'lastMessage': ' '
      //
    });
  }

  dislike() async {
    await FirebaseFirestore.instance
        .collection('chat')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('active')
        .doc(widget.userUid)
        .delete();

    debugPrint('deleted');
  }

  action() async {
    var res = await FirebaseFirestore.instance
        .collection('chat')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('active')
        .doc(widget.userUid)
        .get();
    res.exists ? dislike() : like();
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('active')
            .doc(widget.userUid)
            .snapshots(),
        builder: (context, snapshot) {
          bool haveLiked = snapshot.data!.exists;

          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return IconButton(
              onPressed: action,
              icon: Icon(
                LineIcons.heart,
                color: widget.color,
                size: 20,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (!snapshot.hasData) {
              return IconButton(
                onPressed: action,
                icon: Icon(
                  LineIcons.heart,
                  color: widget.color,
                  size: 20,
                ),
              );
            }
            return haveLiked
                ? ChatButton(color: Colors.white60, uid: widget.userUid)
                : IconButton(
                    onPressed: action,
                    icon: Icon(
                      LineIcons.heart,
                      color: widget.color,
                      size: 20,
                    ),
                  );
          } else {
            return SizedBox(width: 10, height: 10, child: Loading());
          }
        });
  }
}
