// import 'dart:html';

import 'package:dressr/middle.dart';
import 'package:dressr/screens/chat/day_post.dart';
import 'package:dressr/utils/loading.dart';
import 'package:dressr/utils/shared_pref.dart';
import 'package:dressr/utils/utils_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './item.dart';
import '../../models/chat_user.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key,
      required this.typeOfChat,
      this.listOfFriends = const [],
      this.appBarTitle = 'chats',
      this.showOthers = true,
      this.showDayPost = true});
  final List<String> listOfFriends;
  final String typeOfChat;
  final String appBarTitle;
  final bool showDayPost;
  final bool showOthers;

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  List<String> myUid = [FirebaseAuth.instance.currentUser!.uid];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Middle(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.black54,
        title: Text(widget.appBarTitle),
      ),
      body: Column(
        children: [
          widget.showDayPost
              ? DayPost(
                  listOfFreinds: widget.listOfFriends.isEmpty
                      ? myUid
                      : widget.listOfFriends)
              : SizedBox(),
          widget.showDayPost ? Divider() : SizedBox(),
          widget.showOthers
              ? ListTile(
                  onTap: () {
                    Navigator.push(context,
                        PageRouteBuilder(pageBuilder: (context, _, __) {
                      return ChatScreen(
                        typeOfChat: 'requests',
                        showOthers: true,
                        appBarTitle: 'message requests',
                        showDayPost: false,
                      );
                    }));
                  },
                  title: Text('message requests'),
                  trailing: Icon(Icons.arrow_forward_ios_outlined),
                )
              : SizedBox(),
          Expanded(
            child: FirestorePagination(
                bottomLoader: Loading(),
                onEmpty: Center(child: Text('no  user here yet')),
                query: FirebaseFirestore.instance
                    .collection('chat')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection(widget.typeOfChat)
                // .orderBy('lastMessageTimeStamp')
                ,
                itemBuilder: (context, document, snapshot) {
                  String userUid = document['userUid'];
                  return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(userUid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: 40,
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10)),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          String lastMessage = document['lastMessage'];
                          if (snapshot.hasData) {
                            var snap = snapshot.data!;
                            return ListTile(
                              onTap: () {
                                Navigator.push(context, PageRouteBuilder(
                                    pageBuilder: (context, _, __) {
                                  return ChatItem(
                                    uid: userUid,
                                  );
                                }));
                              },
                              leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    snap['profilePicture']),
                              ),
                              title: Text(
                                '${snap["displayName"]}'
                                '   |  '
                                '@${snap['userName']}',
                                maxLines: 1,
                                style:
                                    TextStyle(overflow: TextOverflow.ellipsis),
                              ),
                              subtitle: Row(
                                children: [
                                  Expanded(
                                      child: Text(lastMessage.isEmpty
                                          ? lastMessage
                                          : 'start chat'))
                                ],
                              ),
                            );
                          } else {
                            return Row(children: [
                              CircleAvatar(),
                              Text('user might have disable account')
                            ]);
                          }
                        } else {
                          return Container(
                            height: 40,
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10)),
                          );
                        }
                      });
                }),
          ),
        ],
      ),
    ));
  }
}
