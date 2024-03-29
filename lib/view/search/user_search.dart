import 'package:fashion_dragon/view/utils/middle.dart';
import 'package:fashion_dragon/view/profile/index.dart';
import 'package:fashion_dragon/view/search/index.dart';
import 'package:fashion_dragon/view/search/post_search.dart';
import 'package:fashion_dragon/view/explore/item/item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_dragon/view/utils/loading.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class UserSearch extends StatefulWidget {
  const UserSearch({super.key, required this.searchText});
  final String searchText;

  @override
  State<UserSearch> createState() => UserSearchState();
}

class UserSearchState extends State<UserSearch> {
  // String searchText = widget.searchText;

  @override
  Widget build(BuildContext context) {
    return Middle(
      width: 500,
      child: Scaffold(
          body: FirestorePagination(
        bottomLoader: Loading(),
        initialLoader: Loading(),
        isLive: true,
        limit: 15,
        onEmpty:
            Center(child: Text('no search result for "${widget.searchText}"')),
        query: FirebaseFirestore.instance
            .collection('users')
            .where('tags', arrayContainsAny: widget.searchText.split(' ')),
        itemBuilder: (context, data, snapshot) {
          return ListTile(
            onTap: () {
              Navigator.push(context,
                  PageRouteBuilder(pageBuilder: (context, _, __) {
                return ProfileScreen(
                  userUid: data['uid'],
                );
              }));
            },
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                data['profilePicture'],
              ),
            ),
            title: Text(data['displayName']),
            subtitle: Text('@' '${data['userName']}'),
          );
        },
      )),
    );
  }
}
