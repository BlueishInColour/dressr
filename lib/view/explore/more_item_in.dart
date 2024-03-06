import 'package:dressr/view/create_post/create.dart';
import 'package:dressr/view/create_post/index.dart';
// import 'package:dressr/view/store/add_item.dart';
import 'package:dressr/view/explore/index.dart';
import 'package:dressr/view/explore/more_item_out.dart';
import 'package:dressr/view/management/install_app_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressr/view/utils/loading.dart';
import 'package:dressr/view/utils/repost_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import '../../main.dart';
import '../../view/utils/middle.dart';

import 'item/item.dart';
import 'package:flutter/material.dart';

class MoreItemIn extends StatefulWidget {
  const MoreItemIn({
    super.key,
    required this.postId,
    required this.ancestorId,
    required this.creatorUid,
  });
  final String postId;
  final String ancestorId;

  final String creatorUid;
  @override
  State<MoreItemIn> createState() => MoreItemInState();
}

class MoreItemInState extends State<MoreItemIn> {
  showBottomSheet() {
    debugPrint('clicked');
    showModalBottomSheet(
        isScrollControlled: true,
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
        enableDrag: true,
        anchorPoint: Offset(0, 20),
        elevation: 15,
        isDismissible: true,
        showDragHandle: true,
        context: context,
        builder: ((context) {
          return CommentSection(postId: widget.postId);
        }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Middle(
      child: Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: true,
        //   title: Text('steeze-on'),
        //   actions: [
        //     IconButton(
        //         onPressed: () {
        //           Navigator.push(context,
        //               PageRouteBuilder(pageBuilder: (context, _, __) {
        //             return MainIndex();
        //           }));
        //         },
        //         icon: Icon(
        //           Icons.home,
        //           color: Colors.white,
        //         ))
        //   ],
        // ),

        body: FirestorePagination(
            bottomLoader: Loading(),
            query: FirebaseFirestore.instance
                .collection('posts')
                .where('ancestorId', isEqualTo: widget.ancestorId)
                .where('creatorUid', isEqualTo: widget.creatorUid),
            itemBuilder: (context, snap, snapshot) {
              return Item(
                postId: snap['postId'],
              );
            }),
        bottomSheet: GestureDetector(
            onTap: showBottomSheet,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              height: 50,
              child: ListTile(
                leading: BackButton(
                  color: Colors.white60,
                ),
                trailing: RepostButton(
                    creatorUid: widget.creatorUid,
                    ancestorId: widget.ancestorId,
                    postId: widget.postId),
                title: Text(
                  'view comments',
                  style: TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ),
            )),
      ),
    );
  }
}
