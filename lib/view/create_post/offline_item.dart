import 'package:dressr/view/explore/item/item_caption.dart';
import 'package:dressr/view/explore/item/item_header.dart';
import 'package:dressr/view/explore/item/item_picture.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OfflineItem extends StatefulWidget {
  const OfflineItem(
      {super.key,
      required this.caption,
      required this.picture,
      required this.onTap,
      required this.onCancel,
      this.borderActiveColor = Colors.black});
  final String caption;
  final String picture;
  final Color borderActiveColor;
  final Function()? onTap;

  final Function()? onCancel;

  @override
  State<OfflineItem> createState() => OfflineItemState();
}

class OfflineItemState extends State<OfflineItem> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                  fit: BoxFit.contain,
                  imageUrl: widget.picture,
                  placeholder: (context, string) {
                    return Container();
                  },
                  errorWidget: (context, _, __) {
                    return Container();
                  }),
            ),
          ),
        ),
        Positioned(
            top: 10,
            right: 10,
            child: CircleAvatar(
              child: IconButton(
                  onPressed: widget.onCancel,
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.red,
                  )),
            ))
      ],
    );
  }
}
