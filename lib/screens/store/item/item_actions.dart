import 'dart:io';
import 'dart:typed_data';

import 'package:dressr/screens/store/item/item.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_share/flutter_share.dart';

class ItemActions extends StatefulWidget {
  const ItemActions({
    super.key,
    required this.controller,
    required this.bytes,
    required this.postId,
  });
  final String postId;

  //for download button
  // WidgetsToImageController to access widget
  final WidgetsToImageController controller;
  // to save image bytes of widget
  final Uint8List? bytes;

  @override
  State<ItemActions> createState() => ItemActionsState();
}

class ItemActionsState extends State<ItemActions> {
  bool isDownloading = false;
  bool isSharing = false;
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  Uint8List? bytes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          //download button
          IconButton(
              onPressed: () async {
                setState(() {
                  isDownloading = true;
                });
                final directory = await getDownloadsDirectory();
                String fileName = Uuid().v1();
                String path = '${directory?.path}';
                String savedPath = '$path' '/$fileName.png';

                final bytes = await widget.controller.capture();

                print(bytes);
                print(path);
                final imagePath = await File(savedPath).create();
                await imagePath.writeAsBytes(bytes!.toList());
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('your image have been downloaded')));
              },
              icon: isDownloading
                  ? SizedBox(
                      width: 14, height: 14, child: CircularProgressIndicator())
                  : Icon(Icons.download)),

          //  sharebutton
          IconButton(
              onPressed: () async {
                setState(() {
                  isSharing = true;
                });
                final directory = await getDownloadsDirectory();
                String fileName = Uuid().v1();
                String path = '${directory?.path}';
                String savedPath = '$path' '/$fileName.png';

                final bytes = await widget.controller.capture();

                print(bytes);
                print(path);
                final imagePath = await File(savedPath).create();
                await imagePath.writeAsBytes(bytes!.toList());
                // final result = await Share.shareXFiles([XFile(savedPath)],
                //     text: 'Great picture');

                final result = await FlutterShare.shareFile(
                  title: 'share from dressmate',
                  filePath: savedPath,
                );
                if (true == true) {
                  print('Thank you for sharing the picture!');
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('your image have been shared')));
                }
              },
              icon: isSharing
                  ? SizedBox(
                      width: 14, height: 14, child: CircularProgressIndicator())
                  : Icon(Icons.share))
        ],
      )),
      body: ListView(
        children: [
          // Screenshot(
          //   controller: screenshotController,
          //   child: Text("This text will be captured as image"),
          // ),
          WidgetsToImage(controller: widget.controller, child: cardWidget()),
          // if (bytes != null) buildImage(bytes!),
        ],
      ),
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
