import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressr/view/utils/utils_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class MessageBarr extends StatefulWidget {
  MessageBarr({
    super.key,
    required this.uid,
    this.pushedMessage = const {},
  });
  String uid;
  final Map<String, dynamic> pushedMessage;

  @override
  State<MessageBarr> createState() => MessageBarrState();
}

class MessageBarrState extends State<MessageBarr> {
  bool showSendOptions = false;
  String uid = '';
  @override
  String getChatKey() {
    List chatRoom = [FirebaseAuth.instance.currentUser!.uid, widget.uid];
    chatRoom.sort();
    var chatKey = chatRoom.join();
    return chatKey;
  }

  Map<String, dynamic> message = {
    'ancestorId': '',
    'postId': Uuid().v1(),
    'creatorUid': FirebaseAuth.instance.currentUser!.uid,
    //content
    'caption': '',
    'picture': '',
    'audio': '',
    'video': '',
    'tags': [],

    //
    'timestamp': Timestamp.now(),
    'status': 'seen',
  };

  initState() {
    super.initState();
    setState(() {
      message = widget.pushedMessage;

      message['ancestorId'] = getChatKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    sendCameraImage() async {
      String url = await addSingleImage(ImageSource.camera);
      setState(() {
        message['picture'] = url;
      });
    }

    sendGalleryImage() async {
      String url = await addSingleImage(ImageSource.camera);
      setState(() {
        message['picture'] = url;
      });
    }

    sendMessage() async {
      debugPrint('about to send message');

      var res = await FirebaseFirestore.instance
          .collection('chatroom')
          .doc(getChatKey())
          .collection('messages')
          .add(message)
          .whenComplete(() => setState(() {
                message.clear();
              }));
      // chatRoom.map((e) async =>);

      // }

      debugPrint('message sent');
    }

    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                // color: Colors.black,

                gradient: LinearGradient(
                    colors: [Colors.blue, Colors.purple, Colors.red]),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            // height: 65,
            child: Column(
              children: [
                message['picture'].isNotEmpty
                    ? Container(
                        width: 200,
                        height: 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: CachedNetworkImageProvider(
                                  message['picture']),
                            ),
                            border: Border.all(color: Colors.blue, width: 2)),
                      )
                    : SizedBox.shrink(),
                ListTile(
                  leading: IconButton(
                      onPressed: () {
                        setState(() {
                          showSendOptions = !showSendOptions;
                        });
                      },
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        showSendOptions
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up_sharp,
                        color: Colors.white60,
                      )),
                  title: TextField(
                    onChanged: (v) {
                      setState(() {
                        message['caption'] = v;
                      });
                    },
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          onPressed: sendMessage,
                          icon: Icon(Icons.send, color: Colors.blueGrey),
                        )),
                  ),
                  horizontalTitleGap: 0,
                  contentPadding: EdgeInsets.all(0),
                  minLeadingWidth: 0,
                ),
              ],
            ),
          ),
          //send message buttons
          showSendOptions
              ? Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
//send money button

//sendpicture
                        IconButton(
                            onPressed: sendGalleryImage,
                            icon: Icon(
                              Icons.image_rounded,
                              color: Colors.blue,
                            )),
                        IconButton(
                            onPressed: sendCameraImage,
                            icon: Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.blue,
                            ))
//send style
                      ]),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
