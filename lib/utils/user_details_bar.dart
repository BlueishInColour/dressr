import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressr/screens/profile/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDetailsBar extends StatefulWidget {
  const UserDetailsBar({super.key, required this.uid});
  final String uid;

  @override
  State<UserDetailsBar> createState() => PartnershipScreenState();
}

class PartnershipScreenState extends State<UserDetailsBar> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Row(
              children: [CircleAvatar()],
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
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(details['profilePicture']),
                ),
                title: Text(
                  details['displayName'],
                  style: TextStyle(color: Colors.black87),
                ),
                subtitle: Text(
                  widget.uid == FirebaseAuth.instance.currentUser!.uid
                      ? 'messaging myself'
                      : '@${details['userName']}',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
