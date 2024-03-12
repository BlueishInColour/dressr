import 'package:fashion_dragon/view/utils/middle.dart';
import 'package:fashion_dragon/view/explore/item/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_dragon/view/utils/loading.dart';
import 'package:fashion_dragon/view/utils/utils_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  State<LikeScreen> createState() => LikeScreenState();
}

class LikeScreenState extends State<LikeScreen> {
  ScrollController likeController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Middle(
        width: 500,
        child: FirestorePagination(
          isLive: true,
          bottomLoader: Loading(),
          initialLoader: Loading(),
          onEmpty: Center(
              child: Icon(Icons.star_half_rounded,
                  color: Colors.black26, size: 150)),
          limit: 15,
          controller: likeController,
          query: FirebaseFirestore.instance
              .collection('likes')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('posts'),
          itemBuilder: (context, document, snapshot) {
            if (snapshot > 100) {
              callSubScription(context, function: () {
                debugPrint('');
              }, warning: 'you have suppass your limit of 100 total saves');
            }
            return Item(
              postId: document['postId'],
            );
          },
        ));
  }
}
