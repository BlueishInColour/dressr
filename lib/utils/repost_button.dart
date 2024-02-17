// import 'package:dressr/screens/store/add_item.dart';
import 'package:dressr/screens/create_post/create.dart';
import 'package:dressr/screens/explore/more_item_out.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class RepostButton extends StatefulWidget {
  const RepostButton({
    super.key,
    required this.postId,
    required this.ancestorId,
    required this.creatorUid,
  });
  final String postId;
  final String creatorUid;
  final String ancestorId;
  @override
  State<RepostButton> createState() => RepostButtonState();
}

class RepostButtonState extends State<RepostButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 45,
      child: Badge(
        backgroundColor: Colors.white,
        alignment: Alignment.topRight,
        label: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .where(
                  'ancestorId',
                  isEqualTo: widget.ancestorId,
                )
                .snapshots(),
            builder: (context, snapshot) {
              int? count = snapshot.data?.docs.length;
              if (snapshot.hasData) {
                return Text(
                  count.toString(),
                  style: TextStyle(color: Colors.black),
                );
              } else {
                return Text('0');
              }
            }),
        child: widget.creatorUid == FirebaseAuth.instance.currentUser!.uid
            ? IconButton(
                onPressed: () {
                  Navigator.push(context,
                      PageRouteBuilder(pageBuilder: (context, _, __) {
                    return Create(
                      ancestorId: widget.ancestorId,
                    );
                  }));
                },
                icon: Icon(Icons.add, color: Colors.white60),
              )
            : IconButton(
                padding: EdgeInsets.symmetric(horizontal: 5),
                onPressed: () {
                  Navigator.push(context,
                      PageRouteBuilder(pageBuilder: (context, _, __) {
                    return Create(
                      ancestorId: widget.ancestorId,
                    );
                  }));
                },
                icon: Icon(LineIcons.retweet, color: Colors.white60),
              ),
      ),
    );
  }
}
