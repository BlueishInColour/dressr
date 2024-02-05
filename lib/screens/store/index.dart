import 'dart:convert';

import 'package:dressr/middle.dart';
import 'package:dressr/screens/auth/auth_service.dart';
import 'package:dressr/screens/cart/index.dart';
import 'package:dressr/screens/chat/index.dart';
import 'package:dressr/screens/profile/index.dart';
import 'package:dressr/utils/my_profile_button.dart';
import 'package:dressr/utils/utils_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dressr/screens/store/add_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_load_more/easy_load_more.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidable/hidable.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loadmore_listview/loadmore_listview.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/posts.dart';
import 'item/item.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key, required this.controller});

  final ScrollController controller;

  @override
  State<StoreScreen> createState() => StoreScreenState();
}

class StoreScreenState extends State<StoreScreen>
    with AutomaticKeepAliveClientMixin {
  TextEditingController searchBarController = TextEditingController();
  bool click = false;
  String url = 'http://localhost:8080/shop';
  List<Post> listOfPost = [];
  int cartCount = 3;
  String profilePicture = '';
  Widget loadMoreWidget(context) {
    return CircleAvatar(
      backgroundColor: Colors.grey[200],
      child: CircularProgressIndicator(),
    );
  }

  setProfilePicture() async {
    var data = getUserDetails(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      profilePicture = data['profilePicture'];
    });
  }

  List<String> listOfFriends = [];

  getListOfFriends() async {
    var res = await FirebaseFirestore.instance
        .collection('chat')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('active')
        .get();

    setState(() {
      res.docs.forEach(
        (element) {
          String uid = element['userUid'];
          debugPrint(uid);

          listOfFriends.add(uid);
        },
      );
      debugPrint(listOfFriends.toString());
    });

    debugPrint(listOfFriends.toString());
  }

  initState() {
    super.initState();
    setProfilePicture();
    getListOfFriends();
  }

  button(context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          click = !click;
        });
      },
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          height: 20,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: click ? Colors.blue.shade600 : Colors.black54)),
          child: Center(
            child: Text('price',
                style: TextStyle(fontSize: 11, color: Colors.black54)),
          )),
    );
  }

  PageStorageBucket bucket = PageStorageBucket();

  final FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Middle(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Row(
                children: [
                  Image.asset('assets/icon.png', height: 30),
                  SizedBox(width: 10),
                  Text(
                    "dress`r",
                    style: GoogleFonts.pacifico(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          PageRouteBuilder(pageBuilder: (context, _, __) {
                        return ChatScreen(
                          listOfFriends: listOfFriends,
                        );
                      }));
                    },
                    icon: Icon(
                      Ionicons.chatbox_ellipses_outline,
                      color: Colors.black,
                    )),
                MyProfileButton(),
                SizedBox(
                  width: 7,
                )
              ],
            ),
            backgroundColor: Colors.white,
            body: FirestorePagination(
                isLive: true,
                limit: 20,
                onEmpty: Text('thats all for now'),
                query: db
                    .collection('posts')
                    .orderBy('timestamp', descending: true),
                itemBuilder: (context, document, snapshot) {
                  //if we have data, get all dic

                  return Item(
                    postId: document['postId'],
                  );
                }
                //

                )));
  }
}
