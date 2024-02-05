import 'package:dressr/screens/profile/index.dart';
import 'package:dressr/screens/store/item/item_caption.dart';
import 'package:dressr/utils/like_button.dart';
import 'package:dressr/utils/repost_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemHeader extends StatefulWidget {
  const ItemHeader(
      {super.key,
      required this.creatorUid,
      required this.ancestorId,
      this.showButtons = true,
      required this.postId});
  final String creatorUid;
  final String postId;
  final String ancestorId;
  final bool showButtons;
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
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              color: Colors.blue,
            ),
            child: Row(children: [
              Expanded(child: SizedBox()),
              CircleAvatar(radius: 17),
              SizedBox(width: 2),
            ]),
          );
        }

        DocumentSnapshot snap = snapshot.data!;
        return Container(
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: Colors.blue),
          child: Row(
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
                  width: 220,
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
                          width: 180,
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
              SizedBox(width: 10)
            ],
          ),
        );
      },
    );
  }
}
