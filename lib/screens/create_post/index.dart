import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dressr/screens/create_post/offline_item.dart';
import 'package:dressr/utils/utils_functions.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagekit_io/imagekit_io.dart';
import 'package:uuid/uuid.dart';
import '../../main.dart';
import '../store/item/item.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key, required this.ancestorId});
  final String ancestorId;

  @override
  State<CreateScreen> createState() => CreateScreenState();
}

class CreateScreenState extends State<CreateScreen> {
  String ancestorId = Uuid().v1();
  List<String> theListOfUrl = [];
  List<Map<String, dynamic>> listOfCreatingPost = [];
  int currentEditingItem = 0;
  int currentActiveButton = 0; //0 for text,1 for pictures, 2 for tags
  TextEditingController textController = TextEditingController();
  bool canTheUploadBeDone = true;
  double progressingValue = 0;
  @override
  initState() {
    super.initState();
    listOfCreatingPost.add({
      //id
      'postId': '',
      // 'headPostId': widget.headPostId,
      'ancestorId': widget.ancestorId.isEmpty ? ancestorId : widget.ancestorId,

      //content
      'caption': '',
      'picture': '',
      'audio': '',
      'video': '',
      'tags': [],

      //creator
      'creatorUid': FirebaseAuth.instance.currentUser!.uid,

      //metadata

      'timestamp': Timestamp.now()
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> onePost = {
      //id
      'postId': '',
      // 'headPostId': widget.headPostId,
      'ancestorId': widget.ancestorId.isEmpty ? ancestorId : widget.ancestorId,

      //content
      'caption': '',
      'picture': '',
      'audio': '',
      'video': '',
      'tags': [],

      //creator
      'creatorUid': FirebaseAuth.instance.currentUser!.uid,

      //metadata

      'timestamp': Timestamp.now()
    };
    createOnePostInstance(Map<String, dynamic> onePost) async {
      listOfCreatingPost.add(onePost);
    }

    setTextToField(int index) {
      setState(() {
        textController.clear();

        currentEditingItem = index;

        textController.text = listOfCreatingPost[currentEditingItem]['caption'];
      });
    }

    createTags() {
      listOfCreatingPost.forEach((element) {
        List tagss = element['tags'];
        setState(() {
          tagss.addAll(element['caption'].split(' '));
        });
      });
    }

    getFilePics() async {
      List<File> listOfFiles = await selectImage(true);
      listOfFiles.forEach((element) async {
        ImageKit.io(
          element.readAsBytesSync(),
          fileName: 'afilename',
          //  folder: "folder_name/nested_folder", (Optional)
          privateKey: privateKey, // (Keep Confidential)
          onUploadProgress: (progressValue) {
            if (true) {
              debugPrint(progressValue.toString());
              setState(() {
                progressingValue = progressValue;
              });
            }
          },
        ).then((ImagekitResponse data) {
          /// Get your uploaded Image file link from [ImageKit.io]
          /// then save it anywhere you want. For Example- [Firebase, MongoDB] etc.

          debugPrint(data.url ?? 'xxx');

          // (you will get all Response data from ImageKit)
          Map onPost = listOfCreatingPost.last;

          setState(() {
            listOfCreatingPost.add({
              //id
              'postId': '',
              // 'headPostId': widget.headPostId,
              'ancestorId':
                  widget.ancestorId.isEmpty ? ancestorId : widget.ancestorId,

              //content
              'caption': '',
              'picture': data.url ?? '',
              'audio': '',
              'video': '',
              'tags': [],

              //creator
              'creatorUid': FirebaseAuth.instance.currentUser!.uid,

              //metadata

              'timestamp': Timestamp.now()
            });
          });
        });
      });

      // return listOfUrl;
      //     setState(() async {
      //       final listOfUrl = await pickPicture(true).whenComplete(() {});
      //       theListOfUrl.addAll(listOfUrl);
      //     });

      //     listOfUrl.forEach((element) async {
      //       print(listOfUrl);
      //       if (element == listOfUrl.first && listOfCreatingPost.isNotEmpty) {
      //         //ad to last of uploading list
      //         setState(() {
      //           listOfCreatingPost[currentEditingItem]['picture'] = element;
      //         });
      //       } else {
      //         //create a new post to list and add to it
      //         setState(() {
      //           listOfCreatingPost.add(onePost);
      //           listOfCreatingPost.last['picture'] = element;
      //         });
      //       }
      //     });;
    }

    uploadPost() async {
      listOfCreatingPost.forEach((element) {
        String picture = element['picture'];
        String caption = element['caption'];
        if (picture.isEmpty && caption.isEmpty) {
          setState(() {
            canTheUploadBeDone = false;
          });
        }
      });
      if (canTheUploadBeDone == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.black,
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(
                  width: 15,
                ),
                Text(' some pods are empty'),
              ],
            )));
      } else {
        listOfCreatingPost.forEach((element) async {
          String postId = Uuid().v1();
          createTags();
          setState(() {
            element['postId'] = postId;
          });

          debugPrint(listOfCreatingPost.length.toString());
          DocumentReference postCollection =
              FirebaseFirestore.instance.collection('posts').doc(postId);
          await postCollection.set(element);
        });

        Navigator.push(context, PageRouteBuilder(pageBuilder: (context, _, __) {
          debugPrint('posted');

          return MainIndex();
        }));
      }
    }

    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: listOfCreatingPost.isEmpty
              ? Center(
                  child: Text('click   +   to start editing'),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: listOfCreatingPost.length,
                    itemBuilder: (context, index) {
                      var post = listOfCreatingPost[index];
                      if (currentEditingItem == index) {
                        return OfflineItem(
                          onCancel: () {
                            setState(() {
                              listOfCreatingPost.removeAt(index);
                            });
                          },
                          onTap: () {
                            setState(() {
                              textController.clear();

                              currentEditingItem = index;

                              textController.text =
                                  listOfCreatingPost[currentEditingItem]
                                      ['caption'];
                            });
                          },
                          borderActiveColor: Colors.blue,
                          picture: post['picture'],
                          caption: post['caption'],
                        );
                      } else {
                        return OfflineItem(
                          onCancel: () {
                            setState(() {
                              listOfCreatingPost.removeAt(index);
                            });
                          },
                          onTap: () {
                            setState(() {
                              textController.clear();

                              currentEditingItem = index;

                              textController.text =
                                  listOfCreatingPost[currentEditingItem]
                                      ['caption'];
                            });
                          },
                          picture: post['picture'],
                          caption: post['caption'],
                        );
                      }
                    },
                  ),
                ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: Column(
            children: [
              ListTile(
                  leading: IconButton(
                      onPressed: () {
                        setState(() {
                          listOfCreatingPost.add(onePost);
                        });
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.white60,
                      )),
                  title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                currentActiveButton = 0;
                              });
                            },
                            icon: Icon(Icons.abc, color: Colors.white60)),
                        IconButton(
                            onPressed: () async {
                              String url =
                                  await addSingleImage(ImageSource.camera);
                              setState(() {
                                listOfCreatingPost[currentEditingItem]
                                    ['picture'] = url;
                              });
                            },
                            icon: Icon(
                              Icons.camera,
                              color: Colors.white60,
                            )),
                        IconButton(
                            onPressed: getFilePics,
                            //  () async {
                            //   String url = await addSingleImage(ImageSource.gallery);
                            //   setState(() {
                            //     listOfCreatingPost[currentEditingItem]['picture'] = url;
                            //   });
                            // },
                            icon: Icon(Icons.file_copy, color: Colors.white60))
                      ]),
                  trailing: CircleAvatar(
                    child: IconButton(
                        onPressed: uploadPost,
                        icon: Icon(Icons.file_upload_outlined)),
                  )),
            ],
          ),
        ),
        Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                  controller: textController,
                  onChanged: (text) {
                    setState(() {
                      listOfCreatingPost[currentEditingItem]['caption'] = text;
                    });
                  },
                  cursorColor: Colors.white60,
                  style: TextStyle(color: Colors.white60),
                  decoration: InputDecoration(
                      hintText: 'write caption',
                      hintStyle: TextStyle(color: Colors.white60),
                      fillColor: Colors.white60,
                      focusColor: Colors.white)),
            )),
      ],
    ));
  }
}
