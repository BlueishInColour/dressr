import 'package:dressr/view/profile/index.dart';
import 'package:dressr/view/explore/item/item_header.dart';
import 'package:dressr/view/explore/more_item_in.dart';
import 'package:dressr/view/explore/more_item_out.dart';
import 'package:dressr/view/utils/repost_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../utils/chat_button.dart';
import '../../utils/comment_button.dart';
import '../../utils/like_button.dart';
import '../../../main.dart';

class ItemPicture extends StatefulWidget {
  const ItemPicture({
    super.key,
    required this.creatorUid,
    required this.ancestorId,
    this.index = 1,
    this.picture = '',
    this.postId = '',
  });
  final int index;
  final String postId;
  final String ancestorId;
  final String creatorUid;
  final String picture;

  @override
  State<ItemPicture> createState() => ItemPictureState();
}

class ItemPictureState extends State<ItemPicture> {
  bool showDetail = false;
  final controller = ScrollController();
  Widget button(context, {required Function() onTap}) {
    return IconButton(
        onPressed: onTap,
        icon: Icon(
          Icons.favorite_rounded,
          color: Colors.white,
        ));
  }

  int currentMainIndex = 0;
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
      child: Stack(
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
              child: CachedNetworkImage(
                imageUrl: widget.picture, fit: BoxFit.fill,
                fadeInCurve: Curves.elasticIn,
                errorWidget: (context, _, __) => Container(color: Colors.red),
                placeholder: (context, _) =>
                    Container(color: Colors.black26, height: 500),

                // images[index],
              ),
            ),
          ),
          // Positioned(
          //     top: 10,
          //     left: 10,
          //     child: Container(
          //       decoration: BoxDecoration(
          //           color: Colors.grey[300],
          //           borderRadius: BorderRadius.circular(15)),
          //       height: 25,
          //       width: 40,
          //       child: Center(
          //           child: Text(
          //               '${widget.index.toString()}/${widget.pictures.length.toString()}')),
          //     ))
        ],
      ),
    );
  }
}
