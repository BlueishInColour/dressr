import 'package:dressr/middle.dart';
import 'package:dressr/screens/explore/ads_widget.dart';
import 'package:dressr/screens/explore/appbar.dart';
import 'package:dressr/utils/chat_screen_button.dart';
import 'package:dressr/utils/loading.dart';
import 'package:dressr/utils/my_profile_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:admob_flutter/admob_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
// Loads a banner ad.
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Middle(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Orderr(),
          toolbarHeight: 40,
        ),
        body: FirestorePagination(
            // isLive: true,
            limit: 20,
            bottomLoader: Loading(),
            initialLoader: Loading(),
            onEmpty: Text('thats all for now'),
            // separatorBuilder: (context, index) {
            //   return MyBannerAdWidget();
            // },
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
