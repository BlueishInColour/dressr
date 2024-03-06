import 'package:dressr/view/management/set_pricing.dart';
import 'package:dressr/view/utils/middle.dart';
import 'package:dressr/view/management/all_posts.dart';
import 'package:dressr/view/management/install_app_function.dart';
import 'package:dressr/view/management/order_dress_make.dart';
import 'package:dressr/view/management/set_programmes.dart';
import 'package:dressr/view/management/test_fullscreen_ads.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Management extends StatefulWidget {
  const Management({super.key});

  @override
  State<Management> createState() => ManagementState();
}

class ManagementState extends State<Management> {
  @override
  Widget build(BuildContext context) {
    Widget goto(String text, Widget child) {
      return ListTile(
        title: Text(text),
        onTap: () {
          Navigator.push(context,
              PageRouteBuilder(pageBuilder: (context, _, __) {
            return child;
          }));
        },
      );
    }

    return Middle(
      child: Scaffold(
          appBar: AppBar(title: Text('management'), actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                icon: Icon(Icons.logout)),
          ]),
          body: ListView(
            children: [
              goto('set app url', InstallApp()),
              goto('set programmes', SetProgramme()),
              goto('manage post and content', AllPost()),
              goto('orders and make dresses', OrderDressMake()),
              // goto('test full screen ads', TestFullScreenAds()),
              goto('set pricing', SetPricing())

              ///
            ],
          )),
    );
  }
}
