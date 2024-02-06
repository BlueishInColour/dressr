import 'package:dressr/screens/profile/index.dart';
import 'package:dressr/utils/chat_button.dart';
import 'package:dressr/utils/follow-button.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chatview/chatview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Item extends StatefulWidget {
  const Item({
    super.key,
    required this.uid,
  });

  final String uid;

  @override
  State<Item> createState() => ItemState();
}

class ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    List chatRoom = [FirebaseAuth.instance.currentUser!.uid, widget.uid];
    chatRoom.sort();
    String chatKey = chatRoom.join();

    return Scaffold(
      appBar: AppBar(
          foregroundColor: Colors.black,
          leadingWidth: 30,
          automaticallyImplyLeading: false,
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
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chatroom')
                .doc(chatKey)
                .collection('messages')
                // .where('listOfChatters', isEqualTo: chatRoom)
                .orderBy('timestamp', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              //if we have data, get all dic
              if (snapshot.hasData) {
                return SizedBox(
                  height: 500,
                  child: ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: ((context, index) {
                        //get indicidual doc
                        DocumentSnapshot documentSnapshot =
                            snapshot.data!.docs[index];

                        return BubbleSpecialTwo(
                          text: documentSnapshot['text'],
                          color: documentSnapshot['senderId'] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Colors.black
                              : Color(0xFF1B97F3),
                          tail: true,
                          isSender: documentSnapshot['senderId'] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? true
                              : false,
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 11),
                        );
                      })),
                );
              }

              return Center(
                  child:
                      CircularProgressIndicator(color: Colors.blue.shade600));
            },
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          // height: 65,
          child: ListTile(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white60,
                )),
            title: MessageBar(
              messageBarColor: Colors.transparent,
              onSend: (text) async {
                debugPrint('about to send message');
                // for (var i = 0; i < chatRoom.length; i++) {
                // debugPrint(i.toString());
                await FirebaseFirestore.instance
                    .collection('chatroom')
                    .doc(chatKey)
                    .collection('messages')
                    .add({
                  'senderId': FirebaseAuth.instance.currentUser!.uid,
                  'reciever': 'tinuke',
                  'recieverId': widget.uid,
                  'text': text,
                  'picture': '',
                  'voiceNote': '',
                  'timestamp': Timestamp.now(),
                  'status': 'seen',
                  'listOfChatters': chatRoom,
                });
                // chatRoom.map((e) async =>);
                // }

                debugPrint('message sent');
              },
              sendButtonColor: Colors.white60,
              actions: [],
            ),
            horizontalTitleGap: 0,
            contentPadding: EdgeInsets.all(0),
            minLeadingWidth: 0,
          ),
        ),
      ]),
    );
  }
}
