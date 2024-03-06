import 'dart:io';

import 'package:dressr/view/management/install_app_function.dart';
import 'package:dressr/view/utils/loading.dart';
import 'package:dressr/view/utils/utils_functions.dart';
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
          callToInstall(context);

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
                  Icons.file_download_outlined,
                  size: 27,
                )),
              ));
  }
}
