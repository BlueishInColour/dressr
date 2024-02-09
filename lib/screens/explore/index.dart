import 'dart:convert';

import 'package:dressr/middle.dart';
import 'package:dressr/screens/auth/auth_service.dart';
import 'package:dressr/screens/explore/order.dart';
import 'package:dressr/screens/save/index.dart';
import 'package:dressr/screens/chat/index.dart';
import 'package:dressr/screens/profile/index.dart';
import 'package:dressr/utils/chat_screen_button.dart';
import 'package:dressr/utils/my_profile_button.dart';
import 'package:dressr/utils/subscripe.dart';
import 'package:dressr/utils/utils_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dressr/screens/store/add_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_load_more/easy_load_more.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  bool click = false;

  List<String> listOfFriends = [];

  // initialize bucket globally

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

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Middle(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 40,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text("dressmate",
              style: GoogleFonts.pacifico(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              )),
          actions: [
            ChatScreenButton(listOfFriends: listOfFriends),
            SizedBox(width: 7),
            MyProfileButton(),
            SizedBox(width: 7)
          ],
          bottom: AppBar(
            toolbarHeight: 40,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Orderr(),
            automaticallyImplyLeading: false,
          ),
        ),
        body: FirestorePagination(
            // isLive: true,
            limit: 20,
            onEmpty: Text('thats all for now'),
            query: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('timestamp', descending: true),
            itemBuilder: (context, document, snapshot) {
              //if we have data, get all dic

              return Item(
                postId: document['postId'],
              );
            }),
      ),
    );
  }
}
