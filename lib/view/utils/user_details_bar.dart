import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressr/view/profile/index.dart';
import 'package:dressr/view/utils/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDetailsBar extends StatefulWidget {
  const UserDetailsBar({super.key, required this.uid, required this.textColor});
  final String uid;
  final Color textColor;

  @override
  State<UserDetailsBar> createState() => UserDetailsBarState();
}

class UserDetailsBarState extends State<UserDetailsBar> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.data!.exists) {
            return SizedBox(
              height: 60,
              child: Row(
                children: [
                  CircleAvatar(
                    child: Loading(),
                  )
                ],
              ),
            );
          }
          if (snapshot.hasData) {
            var details = snapshot.data!;
            return GestureDetector(
              onTap: () {
                Navigator.push(context,
                    PageRouteBuilder(pageBuilder: (context, _, __) {
                  return ProfileScreen(userUid: details['uid']);
                }));
              },
              child: Container(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(details['profilePicture']),
                  ),
                  title: Text(
                    details['displayName'],
                    style: TextStyle(color: widget.textColor),
                  ),
                  subtitle: Text(
                    '@${details['userName']}',
                    style: TextStyle(color: widget.textColor),
                  ),
                ),
              ),
            );
          } else {
            return ListTile(leading: Loading());
          }
        });
  }
}
