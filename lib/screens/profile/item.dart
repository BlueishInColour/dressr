import 'package:dressr/screens/store/more_item_in.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Item extends StatefulWidget {
  const Item({
    super.key,
    this.ancestorId = '',
    this.postId = '',
    this.picture = '',
    this.caption = '',
    this.creatorUid = '',
  });
  final String picture;
  final String postId;
  final String ancestorId;
  final String caption;
  final String creatorUid;

  @override
  State<Item> createState() => ItemState();
}

class ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, PageRouteBuilder(pageBuilder: (context, _, __) {
          return MoreItemIn(
            creatorUid: widget.creatorUid,
            postId: widget.postId,
            ancestorId: widget.ancestorId,
          );
        }));
      },
      child: widget.picture.isNotEmpty
          ? Container(
              color: Colors.blue,
              // height: 50,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: widget.picture,
                    fit: BoxFit.fill,
                    errorWidget: (context, _, __) =>
                        Container(color: Colors.red),
                    placeholder: (context, _) =>
                        Container(color: Colors.black26),
                  )
                  // : Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Text(
                  //       widget.caption,
                  //       style: TextStyle(color: Colors.black54),
                  //     ),
                  //   ),
                  ))
          : SizedBox(height: 1),
    );
  }
}
