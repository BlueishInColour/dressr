import 'package:dressr/screens/create_post/index.dart';
// import 'package:dressr/screens/store/add_item.dart';
import 'package:dressr/screens/explore/more_item_in.dart';
import 'package:dressr/screens/management/install_app_function.dart';
import 'package:dressr/utils/loading.dart';
import 'package:dressr/utils/utils_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:uuid/uuid.dart';

import '../../models/comments.dart';
import 'item/item.dart';

import '../../middle.dart';

class SteezeSection extends StatefulWidget {
  const SteezeSection({
    super.key,
    required this.ancestorId,
  });
  final String ancestorId;

  @override
  State<SteezeSection> createState() => SteezeSectionState();
}

class SteezeSectionState extends State<SteezeSection> {
  @override
  Widget build(BuildContext context) {
    return Middle(
      child: Scaffold(
          // appBar: AppBar(
          //   elevation: 0,
          //   backgroundColor: Colors.white,
          //   automaticallyImplyLeading: true,
          //   leading: IconButton(
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //     icon: Icon(
          //       Icons.arrow_back_ios_new_outlined,
          //       color: Colors.black,
          //     ),
          //   ),
          // ),

          body: FirestorePagination(
              initialLoader: Loading(),
              bottomLoader: Loading(),
              query: FirebaseFirestore.instance
                  .collection('posts')
                  .where('ancestorId', isEqualTo: widget.ancestorId),
              itemBuilder: (context, snap, snapshot) {
                return Item(
                  postId: snap['postId'],
                );
              }),
          bottomSheet: FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!.docs[0];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          PageRouteBuilder(pageBuilder: (context, _, __) {
                        return MoreItemIn(
                          creatorUid: data['creatorUid'],
                          postId: data['postId'],
                          ancestorId: data['ancestorId'],
                        );
                      }));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      height: 50,
                      child: ListTile(
                        leading: BackButton(
                          color: Colors.white60,
                        ),
                        trailing: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(context, PageRouteBuilder(
                                    pageBuilder: (context, _, __) {
                                  return kIsWeb
                                      ? InstallApp()
                                      : CreateScreen(
                                          ancestorId: widget.ancestorId,
                                        );
                                }));
                              },
                              icon: Icon(LineIcons.retweet,
                                  color: Colors.white60),
                            )),
                        title: Text(
                          'view original post',
                          style: TextStyle(color: Colors.white60, fontSize: 14),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Loading(),
                  );
                }
              })),
    );
  }
}

// import 'package:flutter/material.dart';

class CommentSection extends StatefulWidget {
  const CommentSection({super.key, required this.postId});
  final String postId;
  @override
  State<CommentSection> createState() => CommentSectionState();
}

class CommentSectionState extends State<CommentSection> {
  var userDetails = {};

  getTheUserDetails() async {
    var details = await getUserDetails(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      userDetails = details;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTheUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('comments')
              .where('postId', isEqualTo: widget.postId)
              .snapshots(),
          builder: (context, snapshot) {
            //if we have data, get all dic
            if (snapshot.data!.docs.isEmpty) {
              return (Center(
                child: Text('be the first to comment on this'),
              ));
            }
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: ((context, index) {
                    //get indicidual doc
                    DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];

                    return ListTile(
                      titleTextStyle:
                          TextStyle(color: Colors.black, fontSize: 11),
                      subtitleTextStyle: TextStyle(fontSize: 13),
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            documentSnapshot['creatorProfilePicture']),
                      ),
                      title: Text('${documentSnapshot['creatorDisplayName']}'
                          '| @'
                          '${documentSnapshot['creatorUserName']}'),
                      subtitle: Text(documentSnapshot['text']),
                    );
                  }));
            }

            return Center(child: Loading());
          },
        ),
      ),
      bottomSheet: SizedBox(
        height: 70,
        child: MessageBar(
          messageBarHitText: 'write a comment',
          onSend: (text) async {
            debugPrint('about to send message');
            await FirebaseFirestore.instance.collection('comments').add({
              'commentId': Uuid().v1(),
              'text': text,
              'creatorProfilePicture': userDetails['profilePicture'],
              'creatorDisplayName': userDetails['displayName'],
              'creatorUserName': userDetails['userName'],
              'postId': widget.postId
            });

            debugPrint('message sent');
          },
          sendButtonColor: Colors.black,
          actions: [
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: InkWell(
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                  size: 24,
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
