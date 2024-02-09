import 'package:dressr/screens/chat/message_bar.dart';
import 'package:dressr/screens/profile/index.dart';
import 'package:dressr/utils/chat_button.dart';
import 'package:dressr/utils/follow-button.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chatview/chatview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressr/utils/utils_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Item extends StatefulWidget {
  const Item({
    super.key,
    required this.uid,
    this.message = const {},
    this.hintText = '',
  });

  final Map<String, dynamic> message;
  final String uid;
  final String hintText;

  @override
  State<Item> createState() => ItemState();
}

class ItemState extends State<Item> {
  bool showSendOptions = false;
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
          title: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Row(
                    children: [CircleAvatar()],
                  );
                }
                if (snapshot.hasData) {
                  var details = snapshot.data!;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          PageRouteBuilder(pageBuilder: (context, _, __) {
                        return ProfileScreen(userUid: details['uid']);
                      }));
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            details['profilePicture']),
                      ),
                      title: Text(
                        details['displayName'],
                        style: TextStyle(color: Colors.black87),
                      ),
                      subtitle: Text(
                        widget.uid == FirebaseAuth.instance.currentUser!.uid
                            ? 'messaging myself'
                            : '@${details['userName']}',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
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
          itemBuilder: (context, documentSnapshot, snapshot) {
            return BubbleSpecialOne(
              text: documentSnapshot['text'],
              color: documentSnapshot['senderId'] ==
                      FirebaseAuth.instance.currentUser!.uid
                  ? Colors.black
                  : Color(0xFF1B97F3),
              tail: false,
              isSender: documentSnapshot['senderId'] ==
                      FirebaseAuth.instance.currentUser!.uid
                  ? true
                  : false,
              textStyle: TextStyle(color: Colors.white, fontSize: 11),
            );
          },
        )),
        MessageBarr()
      ]),
    );
  }
}
