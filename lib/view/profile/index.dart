import 'package:fashion_dragon/view/utils/middle.dart';
import 'package:fashion_dragon/view/auth/auth_service.dart';
import 'package:fashion_dragon/view/profile/edit_profile.dart';
import 'package:fashion_dragon/view/utils/chat_button.dart';
import 'package:fashion_dragon/view/utils/follow-button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_dragon/view/utils/loading.dart';
import 'package:fashion_dragon/view/utils/user_details_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';
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
                bottomLoader: Loading(),
                initialLoader: Loading(),
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
          bottomSheet: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blue, Colors.purple, Colors.red]),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  )),
              child: Row(
                children: [
                  BackButton(),
                  Expanded(
                      child: UserDetailsBar(
                          uid: widget.userUid, textColor: Colors.white70)),
                ],
              ))),
    );
  }
}
