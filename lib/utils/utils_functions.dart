import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagekit_io/imagekit_io.dart';
import '../../models/stories.dart';
import 'package:http/http.dart' as http;
// import '../../';

escShowModelBottomSheet(context, {Widget screen = const SizedBox()}) {
  showModalBottomSheet(context: context, builder: (context) => screen);
}

//
showSnackBar(context, Icon icon, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      showCloseIcon: true,
      closeIconColor: Colors.white60,
      duration: const Duration(seconds: 1),
      content: Row(
        children: [
          icon,
          const SizedBox(width: 20),
          Text(
            text,
            maxLines: 4,
            style: const TextStyle(
                color: Colors.white60, overflow: TextOverflow.ellipsis),
          ),
        ],
      )));
}

Future<List<File>> selectImage(bool isCamera) async {
  final xFile = await ImagePicker().pickMultiImage();
  if (xFile != null) {
    List<File> listOfXfile = [];
    xFile.forEach(
      (element) {
        listOfXfile.add(File(element.path));
      },
    );

    return listOfXfile;
  }

  return [File('')];
}

String privateKey = 'private_A9tBBPhf/8CSEYPp+CR986xpRzE=';

pickPicture(bool isCamera) async {
  List<File> listOfFiles = await selectImage(true);
  List<String> listOfUrl = [];
  listOfFiles.forEach((element) async {
    ImageKit.io(
      element.readAsBytesSync(),
      fileName: 'afilename',
      //  folder: "folder_name/nested_folder", (Optional)
      privateKey: privateKey, // (Keep Confidential)
      onUploadProgress: (progressValue) {
        if (true) {
          debugPrint(progressValue.toString());
        }
      },
    ).then((ImagekitResponse data) {
      /// Get your uploaded Image file link from [ImageKit.io]
      /// then save it anywhere you want. For Example- [Firebase, MongoDB] etc.

      debugPrint(data.url!); // (you will get all Response data from ImageKit)
      listOfUrl.add(data.url!);
    });
  });

  return listOfUrl;
}

Future<String> uploadPixGetUrl(File file) async {
  String? url = await ImageKit.io(
    file.readAsBytesSync(),
    fileName: 'afilename',
    //  folder: "folder_name/nested_folder", (Optional)
    privateKey: privateKey, // (Keep Confidential)
    onUploadProgress: (progressValue) {
      if (true) {
        debugPrint(progressValue.toString());
      }
    },
  ).then((ImagekitResponse data) {
    /// Get your uploaded Image file link from [ImageKit.io]
    /// then save it anywhere you want. For Example- [Firebase, MongoDB] etc.

    debugPrint(data.url!); // (you will get all Response data from ImageKit)
    return data.url;
  });
  return '';
}

Future<String> addSingleImage(ImageSource source) async {
//
  final xFile = await ImagePicker().pickImage(source: source);

  File file = File(xFile!.path);
  //

  String url = await ImageKit.io(
    file.readAsBytesSync(),
    fileName: 'afilename',
    //  folder: "folder_name/nested_folder", (Optional)
    privateKey: privateKey, // (Keep Confidential)
    onUploadProgress: (progressValue) {
      if (true) {
        debugPrint(progressValue.toString());
      }
    },
  ).then((ImagekitResponse data) {
    /// Get your uploaded Image file link from [ImageKit.io]
    /// then save it anywhere you want. For Example- [Firebase, MongoDB] etc.

    debugPrint(data.url!); // (you will get all Response data from ImageKit)
    return data.url!;
  });
  debugPrint(url);

  return url;
}

uploadStories(context, {required Stories stories}) async {
  var url = Uri.parse(
    'https://73ssrmtdna.us-east-1.awsapprunner.com/stories',
  );
  var res = await http.post(url,
      body: json.encode(stories.toJson()),
      headers: {"Content-Type": "application/json"});

  if (res.statusCode == 200) {
    () {
      showSnackBar(
          context,
          const Icon(
            Icons.airplane_ticket,
            color: Colors.green,
          ),
          'done');
    };
  } else {
    () {
      showSnackBar(context, const Icon(Icons.error, color: Colors.red),
          'no internet connection');
    };
  }
}

getUserDetails(String uid) async {
  QuerySnapshot documentSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('uid', isEqualTo: uid)
      .get();

  // DocumentSnapshot snapshot = documentSnapshot.
  QueryDocumentSnapshot snap = documentSnapshot.docs[0];
  debugPrint(snap['uid']);
  debugPrint(snap['userName']);

  debugPrint(snap['displayName']);

  return {
    'userName': snap['userName'],
    'displayName': snap['displayName'],
    'uid': snap['uid'],
    'profilePicture': snap['profilePicture']
  };
}

updateFirebaseDocument(context,
    {String collection = '',
    String firebaseIdName = '',
    String id = '',
    String addKey = '',
    Object addObject = ''}) async {
  debugPrint('clicked');
  QuerySnapshot<Map<String, dynamic>> docs = await FirebaseFirestore.instance
      .collection(collection)
      .where(firebaseIdName, isEqualTo: id)
      .get();
  print(docs);
  for (var snapshot in docs.docs) {
    print('started to find love');
    print(snapshot.id);

    await FirebaseFirestore.instance
        .collection(collection)
        .doc(snapshot.id)
        .update({addKey: addObject});

    debugPrint('done');
    Navigator.pop(context);
  }
}
