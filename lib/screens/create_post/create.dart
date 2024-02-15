import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressr/main.dart';
import 'package:dressr/utils/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagekit_io/imagekit_io.dart';
import 'package:uuid/uuid.dart';
import 'package:dressr/utils/utils_functions.dart';
import './offline_item.dart';

class Create extends StatefulWidget {
  const Create({super.key, required this.ancestorId});
  final String ancestorId;

  @override
  State<Create> createState() => CreateState();
}

class CreateState extends State<Create> {
  bool isUploading = false;
  String ancestorId = Uuid().v1();
  List<String> theListOfUrl = [];
  List<Map<String, dynamic>> listOfCreatingPost = [];
  int currentEditingItem = 0;
  int currentActiveButton = 0; //0 for text,1 for pictures, 2 for tags
  TextEditingController textController = TextEditingController();
  bool canTheUploadBeDone = true;
  double progressingValue = 0;

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

    createTags({String firstCaption = 'designs'}) {
      listOfCreatingPost.forEach((element) {
        List tagss = element['tags'];
        setState(() {
          tagss.addAll(element['caption'].split(' '));
          tagss.addAll(firstCaption.split(' '));
        });
      });
    }

    getWebImages() async {
      // FilePickerResult? result = await FilePicker.platform.pickFiles(
      //   type: FileType.custom,
      //   allowedExtensions: ['jpg', 'png', 'mp4', 'avi'],
      // );

      var images = await ImagePicker.platform.getMultiImageWithOptions();

      if (images.isNotEmpty) {
        images.forEach((element) async {
          var bytes = await element.readAsBytes();
          List<int> bytesint = bytes.toList();
          ImageKit.io(
            bytesint,
            fileName: Uuid().v1(),
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
            // Map onPost = listOfCreatingPost.last;

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
        // File file = File(result.files.single.path!);
      } else {
        // User canceled the picker
        return [File(' ')];
      }
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
          // Map onPost = listOfCreatingPost.last;

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
      if (listOfCreatingPost.isEmpty) {
        setState(() {
          isUploading = false;
        });
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
        setState(() {
          isUploading = true;
        });

        String firstCaption = listOfCreatingPost.first['caption'];
        listOfCreatingPost.forEach((element) {
          String picture = element['picture'];
          String caption = element['caption'];
          if (picture.isEmpty && caption.isEmpty) {
            List<String> tags = element['tags'];
            setState(() {
              canTheUploadBeDone = false;
            });
          }
        });
        listOfCreatingPost.forEach((element) async {
          String postId = Uuid().v1();
          firstCaption = listOfCreatingPost.first['caption'];
          createTags(firstCaption: firstCaption);
          setState(() {
            element['postId'] = postId;
          });

          debugPrint(listOfCreatingPost.length.toString());
          DocumentReference postCollection =
              FirebaseFirestore.instance.collection('posts').doc(postId);
          await postCollection.set(element);
        });

        setState(() {
          isUploading = false;
        });

        Navigator.push(context, PageRouteBuilder(pageBuilder: (context, _, __) {
          debugPrint('posted');

          return MainIndex();
        }));
      }
    }

    Widget addMoreImage() {
      return GestureDetector(
        // onTap: () async => kIsWeb ? getWebImages() : getFilePics(),
        onTap: kIsWeb ? getWebImages : getFilePics,

        child: Center(
          child: Container(
              padding: EdgeInsets.all(10),
              width: 270,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      colors: [Colors.blue, Colors.purple, Colors.red])),
              child: Center(
                child: Text('click to add images',
                    maxLines: 5,
                    style: TextStyle(
                        fontSize: 70,
                        color: Colors.white,
                        fontWeight: FontWeight.w900)),
              )),
        ),
      );
    }

    Widget imageWidget() {
      return Center(child: Container(color: Colors.red));
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          isUploading
              ? CircleAvatar(child: Loading())
              : TextButton(onPressed: uploadPost, child: Text('upload'))
        ],
      ),
      floatingActionButton: listOfCreatingPost.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: Colors.black87,
              onPressed: kIsWeb ? getWebImages : getFilePics,
              child: Icon(
                Icons.add,
                color: Colors.white60,
              ),
            )
          : SizedBox(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: listOfCreatingPost.isEmpty
            ? Center(child: addMoreImage())
            : SizedBox(
                height: 800,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: listOfCreatingPost.length + 1,
                    itemBuilder: (context, index) {
                      if (index == listOfCreatingPost.length) {
                        return addMoreImage();
                      } else {
                        Map<String, dynamic> post = listOfCreatingPost[index];
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
                    }),
              ),
      ),
    );
  }
}
