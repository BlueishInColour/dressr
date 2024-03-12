import 'package:fashion_dragon/view/explore/more_item_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../explore/more_item_out.dart';

class CommentButton extends StatefulWidget {
  const CommentButton({
    super.key,
    required this.headPostId,
    required this.postId,
  });
  final String postId;

  final String headPostId;

  @override
  State<CommentButton> createState() => CommentButtonState();
}

class CommentButtonState extends State<CommentButton> {
  int count = 0;

  getAggregateCount() async {
    AggregateQuerySnapshot query = await FirebaseFirestore.instance
        .collection('comments')
        .where(
          'postId',
          isEqualTo: widget.postId,
        )
        .count()
        .get();

    debugPrint('The number of products: ${query.count}');
    setState(() {
      count = query.count!;
    });
  }

  @override
  initState() {
    super.initState();
    getAggregateCount();
  }

  @override
  Widget build(BuildContext context) {
    return Badge(
      backgroundColor: Colors.white60,
      label: Text(
        count.toString(),
        style: TextStyle(color: Colors.black),
      ),
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () {
          Navigator.push(context,
              PageRouteBuilder(pageBuilder: (context, _, __) {
            return CommentButton(
                headPostId: widget.headPostId, postId: widget.postId);
          }));
        },
        icon: Icon(LineIcons.comment, size: 25, color: Colors.white),
      ),
    );
  }
}
