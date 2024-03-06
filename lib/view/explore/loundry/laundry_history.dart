// import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressr/view/profile/item.dart';
import 'package:dressr/view/utils/loading.dart';
import 'package:dressr/view/utils/middle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';

class LoundryHistory extends StatefulWidget {
  const LoundryHistory({super.key});

  @override
  State<LoundryHistory> createState() => LoundryHistoryState();
}

class LoundryHistoryState extends State<LoundryHistory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 200,
      child: Middle(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text('history',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Colors.black)),
            ),
            body: FirestorePagination(
                // isLive: true,
                limit: 20,
                bottomLoader: Loading(),
                viewType: ViewType.grid,
                initialLoader: Loading(),
                onEmpty: Center(
                    child: Icon(Icons.notifications_off_sharp,
                        size: 150, color: Colors.black26)),
                query: FirebaseFirestore.instance
                    .collection('loundry')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('active')
                    .orderBy('timestamp', descending: true),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 0.7),
                isLive: true,
                itemBuilder: (context, item, snapshot) {
                  // if we have data, get all dic
                  // if (snapshot == 0) {
                  //   return Orderr();
                  // }

                  return Item(
                    caption: item['caption'],
                    picture: item['picture'],
                    ancestorId: item['ancestorId'],
                    postId: item['postId'],
                    creatorUid: item['creatorUid'],
                  );
                })),
      ),
    );
  }
}
