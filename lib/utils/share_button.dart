import 'dart:io';

import 'package:dressr/utils/install_app_function.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class ShareButton extends StatefulWidget {
  const ShareButton({super.key, required this.controller});
  final WidgetsToImageController controller;
  @override
  State<ShareButton> createState() => ShareButtonState();
}

class ShareButtonState extends State<ShareButton> {
  bool isSharing = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          if (kIsWeb) {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return InstallApp();
                });
          }
          // else if (!kIsWeb) {
          //   var res = await FirebaseFirestore.instance
          //       .collection('users')
          //       .doc(FirebaseAuth.instance.currentUser!.uid)
          //       .get();
          //   String currentSubscription = res['currentSubscription'];
          //   bool isBlack = currentSubscription == 'black';
          //   if (isBlack) {
          //     showModalBottomSheet(
          //         context: context,
          //         builder: (context) {
          //           return Subscripe();
          //         });
          //   }
          // }
          else {
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
            if (result == true) {
              print('Thank you for sharing the picture!');
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('your image have been shared')));
            }
          }
        },
        icon: isSharing
            ? SizedBox(
                width: 14, height: 14, child: CircularProgressIndicator())
            : Icon(Icons.share));
  }
}
