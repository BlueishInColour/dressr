import 'package:dressr/middle.dart';
import 'package:dressr/screens/profile/index.dart';
import 'package:dressr/screens/search/default_post_search.dart';
import 'package:dressr/screens/explore/item/item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class PostSearch extends StatefulWidget {
  const PostSearch(
      {super.key, this.searchText = '', this.showBackButton = false});
  final String searchText;
  final bool showBackButton;

  @override
  State<PostSearch> createState() => PostSearchState();
}

class PostSearchState extends State<PostSearch> {
  String searchText = '';
  TextEditingController controller = TextEditingController();
  // String searchText = widget.searchText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      controller.text = widget.searchText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Middle(
      child: Scaffold(
        body: widget.searchText.isEmpty
            ? DefaultPostSearch()
            : FirestorePagination(
                isLive: true,
                onEmpty: Column(
                  children: [
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                          child: Text('no result for "${widget.searchText}"',
                              style: TextStyle(color: Colors.purple.shade100))),
                    ),
                    SizedBox(height: 10),
                    Expanded(child: DefaultPostSearch())
                  ],
                ),
                query: FirebaseFirestore.instance.collection('posts').where(
                    'tags',
                    arrayContainsAny: widget.searchText.split(' ')),
                itemBuilder: (context, document, snapshot) {
                  return Item(
                    postId: document['postId'],
                  );
                }),
        bottomSheet: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          height: 45,
          child: Row(
            children: [
              widget.showBackButton
                  ? BackButton(color: Colors.white60)
                  : SizedBox(),
              Expanded(
                child: SearchBar(
                  controller: controller,
                  textStyle: MaterialStatePropertyAll(
                      TextStyle(color: Colors.white60)),
                  backgroundColor: MaterialStatePropertyAll(Colors.white38),
                  onChanged: (v) {
                    setState(() {
                      searchText = v;
                    });
                  },
                  hintText: 'search trending styles',
                  trailing: [
                    IconButton(
                        onPressed: () async {
                          // await getPostSearchResult();
                          Navigator.push(context,
                              PageRouteBuilder(pageBuilder: (context, _, __) {
                            return PostSearch(
                              searchText: searchText,
                              showBackButton: true,
                            );
                          }));
                        },
                        icon: Icon(Icons.search))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
