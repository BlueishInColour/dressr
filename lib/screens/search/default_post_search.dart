import 'package:dressr/middle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressr/utils/loading.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';

import '../profile/item.dart';

class DefaultPostSearch extends StatefulWidget {
  const DefaultPostSearch({super.key});

  @override
  State<DefaultPostSearch> createState() => DefaultPostSearchState();
}

class DefaultPostSearchState extends State<DefaultPostSearch> {
  @override
  Widget build(BuildContext context) {
    return Middle(
      child: Scaffold(
          body: FirestorePagination(
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
                  .orderBy('timestamp', descending: true),
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
              })),
    );
  }
}
