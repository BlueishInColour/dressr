import 'package:dressr/view/utils/middle.dart';
import 'package:dressr/view/profile/index.dart';
import 'package:dressr/view/search/post_search.dart';
import 'package:dressr/view/search/user_search.dart';
import 'package:dressr/view/explore/item/item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.searchText = ''});
  final String searchText;

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  TextEditingController controller = TextEditingController();
  // late TabController tabsController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // tabsController = TabController(length: 2, vsync: this);
    setState(() {
      controller.text = widget.searchText;
    });
  }

  var searchResult = [];
  String searchText = '';

  getPostSearchResult() async {
    var res = await FirebaseFirestore.instance
        .collection('posts')
        .where('tags', arrayContainsAny: searchText.split(' '))
        .get();
    setState(() {
      searchResult = res.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Middle(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black54,
          toolbarHeight: 40,
          title: SizedBox(
            height: 40,
            child: TextField(
              controller: controller,
              onChanged: (v) {
                setState(() {
                  searchText = v;
                });
              },
              cursorHeight: 10,
              showCursor: false,
              style: TextStyle(fontSize: 10),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () async {
                    // await getPostSearchResult();
                    Navigator.push(context,
                        PageRouteBuilder(pageBuilder: (context, _, __) {
                      return SearchScreen(
                        searchText: searchText,
                      );
                    }));
                  },
                  icon: Icon(Icons.search, size: 19, color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.black, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.blue, width: 1),
                ),
                hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                    color: Colors.black),
                hintText: 'find styles and posts',
              ),
            ),
          ),
          // bottom: AppBar(
          //   backgroundColor: Colors.transparent,
          //   foregroundColor: Colors.black54,
          //   elevation: 0,
          //   title: TabBar(
          //       dividerColor: Colors.transparent,
          //       controller: tabsController,
          //       isScrollable: true,
          //       indicatorColor: Colors.black54,
          //       indicatorPadding: EdgeInsets.only(top: 15),
          //       indicatorSize: TabBarIndicatorSize.label,
          //       tabs: [
          //         // Text(
          //         //   'general',
          //         //   style: TextStyle(color: Colors.black54),
          //         // ),
          //         Text(
          //           'posts',
          //           style: TextStyle(color: Colors.black54),
          //         ),
          //         Text(
          //           'people',
          //           style: TextStyle(color: Colors.black54),
          //         ),
          //       ]),
          // ),
        ),
        //add create show list button

        //

        body: PostSearch(searchText: widget.searchText),
        // UserSearch(searchText: widget.searchText)
      ),
    );
  }
}
