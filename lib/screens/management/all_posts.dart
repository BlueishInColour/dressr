import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressr/middle.dart';
import 'package:dressr/screens/profile/item.dart';
import 'package:dressr/utils/loading.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';

class AllPost extends StatefulWidget {
  const AllPost({super.key});

  @override
  State<AllPost> createState() => AllPostState();
}

class AllPostState extends State<AllPost> {
  @override
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

                return Stack(
                  children: [
                    Item(
                      caption: item['caption'],
                      picture: item['picture'],
                      ancestorId: item['ancestorId'],
                      postId: item['postId'],
                      creatorUid: item['creatorUid'],
                    ),
                    Positioned(
                        child: IconButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('posts')
                                .doc(item['postId'])
                                .delete();
                          },
                          icon: Icon(Icons.delete),
                        ),
                        top: 5,
                        right: 5)
                  ],
                );
              })),
    );
  }
}
