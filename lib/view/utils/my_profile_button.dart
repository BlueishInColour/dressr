import 'package:dressr/view/profile/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyProfileButton extends StatefulWidget {
  const MyProfileButton({super.key});

  @override
  State<MyProfileButton> createState() => MyProfileButtonState();
}

class MyProfileButtonState extends State<MyProfileButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, PageRouteBuilder(pageBuilder: (context, _, __) {
          return ProfileScreen(userUid: FirebaseAuth.instance.currentUser!.uid);
        }));
      },
      child: SizedBox(
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.data!.exists) {
                return CircleAvatar(radius: 12);
              } else if (snapshot.connectionState == ConnectionState.done) {
                String data = snapshot.data?['profilePicture'] ?? '';
                return CircleAvatar(
                  radius: 8,
                  backgroundImage: CachedNetworkImageProvider(data),
                );
              } else {
                return CircleAvatar(radius: 12);
              }
            }),
      ),
    );
  }
}
