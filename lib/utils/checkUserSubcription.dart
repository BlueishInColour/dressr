import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressr/utils/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckUserSubscription extends StatefulWidget {
  const CheckUserSubscription(
      {super.key,
      required this.acceptableSubscriptionMode,
      required this.child});
  final Widget child;
  final String acceptableSubscriptionMode;

  @override
  State<CheckUserSubscription> createState() => CheckUserSubscriptionState();
}

class CheckUserSubscriptionState extends State<CheckUserSubscription> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('subscription')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('current')
            .doc('current')
            .snapshots(),
        builder: (context, snapshot) {
          var snap = snapshot.data!;
          Timestamp subscriptionEnd = snap['subscriptionEnd'];
          Timestamp now = Timestamp.now();
          if (snapshot.hasData) {
            if (now.toDate().isBefore(subscriptionEnd.toDate())) {
              return widget.child;
            } else {
              showModalBottomSheet(
                  context: context,
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  enableDrag: true,
                  anchorPoint: Offset(0, 20),
                  elevation: 15,
                  isDismissible: true,
                  showDragHandle: true,
                  builder: (context) {
                    return Scaffold(
                      body: Container(
                        height: 100,
                        child: Text('upgrade your subscription'),
                      ),
                    );
                  });
            }
          }

          return Center(
            child: Loading(),
          );
        });
  }
}
