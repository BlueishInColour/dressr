import 'dart:io';

import 'package:dressr/view/management/install_app_function.dart';
import 'package:dressr/view/utils/loading.dart';
import 'package:dressr/view/utils/utils_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:share_plus/share_plus.dart';

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
          setState(() {
            callToInstall(context);
            isSharing = true;
          });
          final bytes = await widget.controller.capture();

          final result = await Share.shareXFiles([
            XFile.fromData(bytes!,
                mimeType: 'image/jpeg', length: bytes!.length),
          ], text: 'Great picture');
          print(Directory.current.path);
          if (result == true) {
            print('Thank you for sharing the picture!');
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('your image have been shared')));
          }
        },
        icon: isSharing
            ? SizedBox(child: Loading(size: 20))
            : ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.blue, Colors.purple, Colors.red])
                      .createShader(bounds);
                },
                child: Center(
                    child: Icon(
                  Icons.share_rounded,
                  size: 23,
                )),
              ));
  }
}
