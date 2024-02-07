// import 'package:dressr/screens/store/add_item.dart';
import 'package:dressr/screens/explore/more_item_out.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class RepostButton extends StatefulWidget {
  const RepostButton({
    super.key,
    required this.postId,
    required this.ancestorId,
  });
  final String postId;
  final String ancestorId;
  @override
  State<RepostButton> createState() => RepostButtonState();
}

class RepostButtonState extends State<RepostButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.push(context,
              PageRouteBuilder(pageBuilder: (context, _, __) {
            return SteezeSection(
              ancestorId: widget.ancestorId,
            );
          }));
        },
        icon: Badge(
          backgroundColor: Colors.white,
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
          child: Icon(
            LineIcons.retweet,
            color: Colors.white60,
            size: 20,
            // weight: 15,
          ),
        ));
  }
}
