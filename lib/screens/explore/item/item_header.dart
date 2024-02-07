import 'dart:typed_data';

import 'package:dressr/screens/profile/index.dart';
import 'package:dressr/screens/explore/item/item_actions.dart';
import 'package:dressr/screens/explore/item/item_caption.dart';
import 'package:dressr/utils/like_button.dart';
import 'package:dressr/utils/repost_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class ItemHeader extends StatefulWidget {
  const ItemHeader(
      {super.key,
      required this.controller,
      required this.bytes,
      required this.creatorUid,
      required this.ancestorId,
      this.showButtons = true,
      this.caption = '',
      this.isPictureAvailable = false,
      required this.postId});
  final String creatorUid;
  final String postId;
  final String ancestorId;
  final bool showButtons;
  final String caption;
  final bool isPictureAvailable;

  //for download button
  // WidgetsToImageController to access widget
  final WidgetsToImageController controller;
  // to save image bytes of widget
  final Uint8List? bytes;

  @override
  State<ItemHeader> createState() => ItemHeaderState();
}

class ItemHeaderState extends State<ItemHeader> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('users')
          // .where('uid', isEqualTo: widget.creatorUid)
          .doc(widget.creatorUid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              color: Colors.black,
            ),
            child: Row(children: [
              Expanded(child: SizedBox()),
              CircleAvatar(radius: 17),
              SizedBox(width: 2),
            ]),
          );
        }
        if (snapshot.hasData) {
          DocumentSnapshot snap = snapshot.data!;
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: widget.isPictureAvailable
                      ? Radius.circular(15)
                      : Radius.circular(0),
                  bottomRight: widget.isPictureAvailable
                      ? Radius.circular(15)
                      : Radius.circular(0),
                ),
                color: snap['currentSubscription'] == 'black'
                    ? Colors.black
                    : Colors.blue),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  textDirection: TextDirection.rtl,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            PageRouteBuilder(pageBuilder: (context, _, __) {
                          return ProfileScreen(userUid: snap['uid']);
                        }));
                      },
                      child: SizedBox(
                        width: 185,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            textDirection: TextDirection.rtl,
                            children: [
                              CircleAvatar(
                                  radius: 17,
                                  backgroundImage: CachedNetworkImageProvider(
                                      snap['profilePicture'])),
                              SizedBox(width: 5),
                              SizedBox(
                                width: 130,
                                child: Text(
                                  '${snap['displayName']}'
                                  ' | '
                                  '@'
                                  '${snap['userName']}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white70,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    RepostButton(
                      ancestorId: widget.ancestorId,
                      postId: widget.postId,
                    ),
                    LikeButton(
                        typeOfShowlist: '',
                        idType: 'postId',
                        postId: widget.postId,
                        collection: 'posts'),
                    IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return ItemActions(
                                    creatorUid: widget.creatorUid,
                                    postId: widget.postId,
                                    bytes: widget.bytes,
                                    controller: widget.controller);
                              });
                        },
                        icon: Icon(
                          Icons.more_vert_rounded,
                          color: Colors.white70,
                        )),
                  ],
                ),

                //item captionn
                ItemCaption(
                  caption: widget.caption,
                  isPictureAvailable: widget.isPictureAvailable,
                  postId: widget.postId,
                  ancestorId: widget.ancestorId,
                  creatorUid: widget.creatorUid,
                ),
              ],
            ),
          );
        } else {
          return Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              color: Colors.black,
            ),
            child: Row(children: [
              Expanded(child: SizedBox()),
              CircleAvatar(radius: 17),
              SizedBox(width: 2),
            ]),
          );
        }
      },
    );
  }
}
