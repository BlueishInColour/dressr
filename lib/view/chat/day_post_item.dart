import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_dragon/view/profile/index.dart';
import 'package:fashion_dragon/view/explore/more_item_in.dart';
import 'package:flutter/material.dart';

class DayPostItem extends StatefulWidget {
  const DayPostItem({super.key, required this.data});
  final DocumentSnapshot data;
  @override
  State<DayPostItem> createState() => DayPostItemState();
}

class DayPostItemState extends State<DayPostItem> {
  @override
  Widget build(BuildContext context) {
    String picture = widget.data['picture'];
    bool isPicture = picture.isNotEmpty;
    return GestureDetector(
        onTap: () {
          //

          Navigator.push(context,
              PageRouteBuilder(pageBuilder: (context, _, __) {
            return MoreItemIn(
                postId: widget.data['postId'],
                ancestorId: widget.data['ancestorId'],
                creatorUid: widget.data['creatorUid']);
          }));
        },
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 40,
                  child: !isPicture
                      ? Center(child: Text(widget.data['caption']))
                      : SizedBox(),
                  backgroundImage:
                      CachedNetworkImageProvider(widget.data['picture']),
                ),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.data['creatorUid'])
                        .get(),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircleAvatar(
                          radius: 10,
                        );
                      } else if (snapshot.hasError) {
                        return CircleAvatar(
                          radius: 10,
                        );
                      } else if (snapshot.hasData) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                PageRouteBuilder(pageBuilder: (context, _, __) {
                              return ProfileScreen(
                                  userUid: widget.data['creatorUid']);
                            }));
                          },
                          child: CircleAvatar(
                            radius: 10,
                            backgroundImage: CachedNetworkImageProvider(
                                snapshot.data?['profilePicture']),
                          ),
                        );
                      } else {
                        return CircleAvatar(
                          radius: 10,
                        );
                      }
                    })),
              ],
            )));
  }
}

// import 'package:flutter/material.dart';

