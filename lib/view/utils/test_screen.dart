import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_dragon/view/utils/loading.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => TestScreenState();
}

class TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chatroom').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(body: Text(snapshot.data!.docs.toString()));
          } else {
            return Center(
              child: Loading(),
            );
          }
        });
  }
}
