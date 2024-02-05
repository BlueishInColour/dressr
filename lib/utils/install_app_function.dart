import 'package:dressr/middle.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';

class InstallApp extends StatefulWidget {
  const InstallApp({super.key});

  @override
  State<InstallApp> createState() => InstallAppState();
}

class InstallAppState extends State<InstallApp> {
  @override
  Widget build(BuildContext context) {
    return Middle(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('do more on dressr,  install for android'),
              SizedBox(
                height: 15,
              ),
              Text(
                  'upload fashion styles, dressups, DIYs, cosplays, models and many more'),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                  onTap: () async {
                    debugPrint('installit');
                    // http.get(Uri.parse(widget.installLink));
                    await launchUrl(Uri.parse('https://files.fm/u/7emgbkauvd'),
                        mode: LaunchMode.inAppBrowserView,
                        webOnlyWindowName: 'download dressr');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black,
                    ),
                    height: 50,
                    width: 200,
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'download & install',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.download,
                          color: Colors.white,
                        )
                      ],
                    )),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
