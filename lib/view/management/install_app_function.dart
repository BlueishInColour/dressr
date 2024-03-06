import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressr/view/utils/middle.dart';
import 'package:dressr/view/utils/loading.dart';
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
  bool showSetUrlLink = false;
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Widget setLink(context) {
      return Row(
        children: [
          Expanded(
            child: TextField(controller: textController),
          ),
          IconButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('app')
                    .doc('url-link')
                    .set({'url': textController.text});
                setState(() {
                  showSetUrlLink = false;
                });
              },
              icon: Icon(Icons.upload))
        ],
      );
    }

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
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('app')
                      .doc('url-link')
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black,
                        ),
                        height: 50,
                        width: 200,
                        child: Center(child: Loading()),
                      );
                    } else if (snapshot.hasData) {
                      String urlLink = snapshot.data?['url'];
                      return GestureDetector(
                          onLongPress: () {
                            setState(() {
                              showSetUrlLink = true;
                            });
                          },
                          onTap: () async {
                            debugPrint('installit');
                            // http.get(Uri.parse(widget.installLink));
                            await launchUrl(Uri.parse(urlLink),
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
                          ));
                    } else {
                      return setLink(context);
                    }
                  }),
            ],
          ),
        ),
        bottomSheet: showSetUrlLink ? setLink(context) : SizedBox.shrink(),
      ),
    );
  }
}
