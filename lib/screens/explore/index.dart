import 'package:dressr/middle.dart';
import 'package:dressr/screens/explore/order.dart';
import 'package:dressr/utils/chat_screen_button.dart';
import 'package:dressr/utils/my_profile_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'item/item.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key, required this.controller});

  final ScrollController controller;

  @override
  State<StoreScreen> createState() => StoreScreenState();
}

class StoreScreenState extends State<StoreScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Middle(
      child: Scaffold(
        appBar: AppBar(
          title: Orderr(),
          toolbarHeight: 40,
        ),
        body: FirestorePagination(
            // isLive: true,
            limit: 20,
            onEmpty: Text('thats all for now'),
            query: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('timestamp', descending: true),
            itemBuilder: (context, document, snapshot) {
              // if we have data, get all dic
              // if (snapshot == 0) {
              //   return Orderr();
              // }

              return Item(
                postId: document['postId'],
              );
            }),
      ),
    );
  }
}
