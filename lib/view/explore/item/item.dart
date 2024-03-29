import 'dart:typed_data';

import 'package:fashion_dragon/view/explore/item/item.dart';
import 'package:fashion_dragon/view/explore/item/item_caption.dart';
import 'package:fashion_dragon/view/explore/item/item_header.dart';
import 'package:fashion_dragon/view/explore/item/item_picture.dart';
import 'package:fashion_dragon/view/explore/more_item_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_dragon/view/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class Item extends StatefulWidget {
  const Item({
    super.key,
    required this.postId,
    this.showHeader = true,
    // required this.typeOfShowlist,
    // required this.timesamp
  });

  final bool showHeader;
  // final Timestamp timesamp;
  final String postId;
  // final String typeOfShowlist;

  getPost(String postId) async {}
  @override
  State<Item> createState() => ItemState();
}

class ItemState extends State<Item> {
  // WidgetsToImageController to access widget
  WidgetsToImageController controller = WidgetsToImageController();
  // to save image bytes of widget
  Uint8List? bytes;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            // .where('postId', isEqualTo: widget.postId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(color: Colors.black, height: 200);
          }
          if (snapshot.hasData) {
            DocumentSnapshot snap = snapshot.data!;
            String picture = snap['picture'];
            bool isPictureAvailable = picture.isEmpty;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ItemHeader(
//for donwlowder
                    bytes: bytes, controller: controller,

                    postId: snap['postId'],
                    ancestorId: snap['ancestorId'],
                    creatorUid: snap['creatorUid'],
                    caption: snap['caption'],
                    isPictureAvailable: isPictureAvailable,
                    showHeader: widget.showHeader,
                  ),
                  ItemPicture(
                    creatorUid: snap['creatorUid'],
                    ancestorId: snap['ancestorId'],
                    picture: snap['picture'],
                    postId: snap['postId'],
                  )
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                    // color: Colors.grey[200],
                    gradient: LinearGradient(
                        colors: [Colors.blue, Colors.purple, Colors.red]),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Row(children: [
                      Expanded(child: SizedBox()),
                      CircleAvatar(radius: 17),
                      SizedBox(width: 2),
                    ]),
                    Expanded(
                      child: Center(
                        child: Loading(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
