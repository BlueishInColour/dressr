import 'dart:io';

import 'package:dressr/utils/install_app_function.dart';
import 'package:dressr/utils/loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class DownloadButton extends StatefulWidget {
  const DownloadButton({super.key, required this.controller});
  final WidgetsToImageController controller;
  @override
  State<DownloadButton> createState() => DownloadButtonState();
}

class DownloadButtonState extends State<DownloadButton> {
  bool isDownloading = false;
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
          //  else if (!kIsWeb) {
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
          }
        },
        icon: isDownloading
            ? SizedBox(width: 14, height: 14, child: Loading())
            : ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) => RadialGradient(
                      center: Alignment.topLeft,
                      stops: [.5, 1],
                      colors: [Colors.blue, Colors.purple, Colors.red],
                    ).createShader(bounds),
                child: Icon(
                  Icons.file_download_outlined,
                  size: 40,
                )));
  }
}
