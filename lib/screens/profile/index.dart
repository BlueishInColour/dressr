import 'package:dressr/middle.dart';
import 'package:dressr/screens/auth/auth_service.dart';
import 'package:dressr/screens/profile/edit_profile.dart';
import 'package:dressr/utils/chat_button.dart';
import 'package:dressr/utils/follow-button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../../models/posts.g..dart';
import 'item.dart';

// final String uid =cc FirebaseAuth.instance.currentUser!.uid;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.userUid});
  final String userUid;

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Middle(
      child: Scaffold(
        //wordrope],

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FirestorePagination(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 0.7),
              isLive: true,
              limit: 25,
              viewType: ViewType.grid,
              query: FirebaseFirestore.instance
                  .collection('posts')
                  .where('creatorUid', isEqualTo: widget.userUid),
              itemBuilder: (context, item, snapshot) {
                // setState(() {
                //   listOfSnapshots.add(document);
                // });

                return Item(
                  caption: item['caption'],
                  picture: item['picture'],
                  ancestorId: item['ancestorId'],
                  postId: item['postId'],
                  creatorUid: item['creatorUid'],
                );
              }),
        ),
        bottomSheet: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userUid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  height: 70,
                );
              } else if (snapshot.hasData) {
                // DocumentSnapshot snapshot = documentSnapshot.
                DocumentSnapshot<Map<String, dynamic>> snap = snapshot.data!;
                String uid = snap['uid'];
                String userName = snap['userName'];
                String displayName = snap['displayName'];
                String profilePicture = snap['profilePicture'];

                return GestureDetector(
                    // onTap: showBottomSheet,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15))),
                        height: 70,
                        child: ListTile(
                          leading: BackButton(
                            color: Colors.white60,
                          ),
                          horizontalTitleGap: 0,
                          contentPadding: EdgeInsets.all(0),
                          minLeadingWidth: 0,
                          title: ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  CachedNetworkImageProvider(profilePicture),
                            ),
                            title: Text(
                              displayName,
                              maxLines: 1,
                              style: TextStyle(color: Colors.white70),
                            ),
                            subtitle: Text(
                              uid == FirebaseAuth.instance.currentUser!.uid
                                  ? '@${userName}' ' | ' 'my profile'
                                  : '@${userName}',
                              maxLines: 1,
                              style: TextStyle(color: Colors.white60),
                            ),
                            trailing:
                                // widget.userUid == FirebaseAuth.instance.currentUser!.uid
                                //     ? IconButton(
                                //         onPressed: () async {
                                //           await AuthService().logout();
                                //         },
                                //         icon: Icon(
                                //           Icons.logout,
                                //           color: Colors.white54,
                                //         ))
                                //    +-- :
                                FollowButton(
                                    userUid: widget.userUid,
                                    displayName: displayName,
                                    profilePicture: profilePicture,
                                    userName: userName),
                          ),
                        )));
              } else {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  height: 70,
                );
              }
            }),
      ),
    );
  }
}
