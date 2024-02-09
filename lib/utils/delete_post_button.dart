import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeletePostButton extends StatefulWidget {
  const DeletePostButton(
      {super.key, required this.postId, required this.creatorUid});
  final String postId;
  final String creatorUid;

  @override
  State<DeletePostButton> createState() => DeletePostButtonState();
}

class DeletePostButtonState extends State<DeletePostButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.creatorUid == FirebaseAuth.instance.currentUser!.uid) {
      return IconButton(
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.postId)
                .delete();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(
              children: [
                Icon(Icons.delete, color: Colors.red),
                SizedBox(width: 15),
                Text('you deleted a post')
              ],
            )));
          },
          icon: Icon(Icons.delete, color: Colors.red));
    } else {
      return SizedBox.shrink();
    }
  }
}
