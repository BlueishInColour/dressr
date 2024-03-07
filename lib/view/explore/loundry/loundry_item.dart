import 'dart:typed_data';

import 'package:dressr/view/explore/item/item.dart';
import 'package:dressr/view/explore/item/item_caption.dart';
import 'package:dressr/view/explore/item/item_header.dart';
import 'package:dressr/view/explore/item/item_picture.dart';
import 'package:dressr/view/explore/more_item_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressr/view/utils/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lit_relative_date_time/lit_relative_date_time.dart';
import 'package:uuid/uuid.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class LaundryItem extends StatefulWidget {
  const LaundryItem({
    super.key,
    this.postId = '',
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
  State<LaundryItem> createState() => LaundryItemState();
}

class LaundryItemState extends State<LaundryItem> {
  // WidgetsToImageController to access widget
  WidgetsToImageController controller = WidgetsToImageController();
  // to save image bytes of widget
  Uint8List? bytes;
  DateTime date = DateTime.now();

  String format(context, DateTime dateTime) {
    RelativeDateTime _relativeDateTime =
        RelativeDateTime(dateTime: dateTime, other: DateTime.now());

    RelativeDateFormat _relativeDateFormatter =
        RelativeDateFormat(Localizations.localeOf(context));

    return _relativeDateFormatter.format(_relativeDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      // height: 150,
      color: Colors.white,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        //title
        Row(
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue, Colors.purple, Colors.red])
                    .createShader(bounds);
              },
              child: Center(
                child: Icon(
                  Icons.star_rounded,
                  color: Colors.white,
                  size: 25.0,
                ),
              ),
            ),
            SizedBox(width: 10),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: Text('order succesfully recieved',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 17))),
          ],
        ),

        Divider(thickness: 0.4),

        //descriptiionn
        Text(
          'your order (${Uuid.NAMESPACE_DNS}) have been recieved and being processed by an handler, we will keep in touch with you (blueishincolour@gmail.com)',
          maxLines: 10,
          style: TextStyle(overflow: TextOverflow.ellipsis),
        ),
        //details
        Divider(thickness: 0.4),
        Row(
          children: [
            Text('x:21  m:2  l:1   urgent:no   starched:yes   price:2500'),
          ],
        ),
        //date
        Divider(thickness: 0.4),
        Row(
          children: [
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
                child: Text(format(context, date),
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black45,
                        fontSize: 12))),
          ],
        ),
      ]),
    );
  }
}
