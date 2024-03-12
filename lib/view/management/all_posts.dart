import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_dragon/view/utils/middle.dart';
import 'package:fashion_dragon/view/profile/item.dart';
import 'package:fashion_dragon/view/utils/loading.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';

class AllPost extends StatefulWidget {
  const AllPost({super.key});

  @override
  State<AllPost> createState() => AllPostState();
}

class AllPostState extends State<AllPost> {
  bool isDeleting = false;
  @override
  Widget build(BuildContext context) {
    return Middle(
      child: Scaffold(
          appBar: AppBar(title: Text('manage content and post')),
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
                            setState(() {
                              isDeleting = true;
                            });
                            await FirebaseFirestore.instance
                                .collection('posts')
                                .doc(item['postId'])
                                .delete();
                          },
                          icon: isDeleting
                              ? Loading()
                              : Icon(Icons.delete, color: Colors.red),
                        ),
                        top: 1,
                        right: 1)
                  ],
                );
              })),
    );
  }
}
