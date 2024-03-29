import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_dragon/view/management/install_app_function.dart';
import 'package:fashion_dragon/view/utils/loading.dart';
import 'package:fashion_dragon/view/utils/subscripe.dart';
import 'package:fashion_dragon/view/utils/utils_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CheckSubAndIsWeb extends StatefulWidget {
  const CheckSubAndIsWeb({super.key, required this.child});
  final Widget child;

  @override
  State<CheckSubAndIsWeb> createState() => CheckSubAndIsWebState();
}

class CheckSubAndIsWebState extends State<CheckSubAndIsWeb> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('subscriptio')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('currentSubscription')
            .get(),
        builder: (context, snapshot) {
          // if user in on web
          if (kIsWeb) {
            return InstallApp();
          }

          //if its still loading
          else if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
                width: 15, height: 15, child: Center(child: Loading()));
          }

          //  if have subscribed
          else if (snapshot.hasData) {
            return widget.child;
          }

          //else
          else {
            return Subscripe();
          }
        });
  }
}
