import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_dragon/view/utils/middle.dart';
import 'package:fashion_dragon/view/explore/item/item.dart';
import 'package:fashion_dragon/view/utils/chat_button.dart';
import 'package:fashion_dragon/view/utils/check_sub_and_isweb.dart';
import 'package:fashion_dragon/view/utils/delete_post_button.dart';
import 'package:fashion_dragon/view/utils/download_button.dart';
import 'package:fashion_dragon/view/management/install_app_function.dart';
import 'package:fashion_dragon/view/utils/share_button.dart';
import 'package:fashion_dragon/view/utils/subscripe.dart';
import 'package:fashion_dragon/view/utils/utils_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_share/flutter_share.dart';

class ItemActions extends StatefulWidget {
  const ItemActions({
    super.key,
    required this.controller,
    required this.context,
    required this.bytes,
    required this.postId,
    required this.creatorUid,
  });
  final String postId;

  //for download button
  // WidgetsToImageController to access widget
  final WidgetsToImageController controller;
  // to save image bytes of widget
  final Uint8List? bytes;
  final BuildContext context;
  final String creatorUid;
  @override
  State<ItemActions> createState() => ItemActionsState();
}

class ItemActionsState extends State<ItemActions> {
  bool isDownloading = false;
  bool isSharing = false;
  //Create an instance of ScreenshotController

  Uint8List? bytes;
  @override
  Widget build(BuildContext context) {
    return Middle(
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
              automaticallyImplyLeading: false,
              foregroundColor: Colors.white,
              title: Row(children: [
                //download button
                DownloadButton(controller: widget.controller),
                //  sharebutton
                ShareButton(controller: widget.controller),
                //chat creator
                // ChatButton(uid: widget.creatorUid),
                //use button should be here

                //
                Expanded(child: SizedBox()),
                //delete post else report
                DeletePostButton(
                    postId: widget.postId, creatorUid: widget.creatorUid),
              ])),
          body: ListView(children: [
            WidgetsToImage(controller: widget.controller, child: cardWidget()),
          ])),
    );
  }

  Widget cardWidget() {
    return Item(
      postId: widget.postId,
    );
  }

  Widget buildImage(Uint8List bytes) => Image.memory(bytes);
}

// import 'package:flutter/material.dart';

// class DownloadButton extends StatefulWidget {
//   const DownloadButton({
//     super.key,
//     required this.controller,
//     // required this.bytes,
//   });

//   //for download button
//   // WidgetsToImageController to access widget
//   final WidgetsToImageController controller;
//   // to save image bytes of widget
//   @override
//   State<DownloadButton> createState() => DownloadButtonState();
// }

// class DownloadButtonState extends State<DownloadButton> {
//   Uint8List? bytes;

//   @override
//   Widget build(BuildContext context) {
  
//   }
// }
