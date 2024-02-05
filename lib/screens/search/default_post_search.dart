import 'package:dressr/middle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            //if we have data, get all dic

            if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(' no content yet'),
                );
              }
              return ListView(
                children: [
                  MasonryView(
                      itemPadding: 3,
                      listOfItem: snapshot.data!.docs,
                      numberOfColumn: 4,
                      itemBuilder: (item) {
                        return Item(
                          caption: item['caption'],
                          picture: item['picture'],
                          ancestorId: item['ancestorId'],
                          postId: item['postId'],
                          creatorUid: item['creatorUid'],
                        );
                      }),
                ],
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
