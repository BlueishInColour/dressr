import 'package:dressr/screens/store/more_item_in.dart';
import 'package:flutter/material.dart';

class ItemCaption extends StatefulWidget {
  const ItemCaption(
      {super.key,
      required this.caption,
      this.ancestorId = '',
      this.postId = '',
      this.creatorUid = '',
      this.backgroundColor = Colors.blue,
      required this.isPictureAvailable});
  final String caption;
  final bool isPictureAvailable;
  final Color backgroundColor;
  final String ancestorId;
  final String creatorUid;
  final String postId;
  @override
  State<ItemCaption> createState() => ItemCaptionState();
}

class ItemCaptionState extends State<ItemCaption> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, PageRouteBuilder(pageBuilder: (context, _, __) {
          return MoreItemIn(
            ancestorId: widget.ancestorId,
            creatorUid: widget.creatorUid,
            postId: widget.postId,
          );
        }));
      },
      child: Container(
        decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: widget.isPictureAvailable
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))
                : null),
        child: widget.isPictureAvailable
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.caption,
                        style: TextStyle(color: Colors.white60)),
                  ),
                ],
              )
            : SizedBox(),
      ),
    );
  }
}
