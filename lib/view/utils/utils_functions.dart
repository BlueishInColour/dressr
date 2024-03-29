import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_dragon/view/management/install_app_function.dart';
import 'package:fashion_dragon/view/utils/loading.dart';
import 'package:fashion_dragon/view/utils/subscripe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagekit_io/imagekit_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import '../../../models/stories.dart';
import 'package:http/http.dart' as http;
// import 'package:image_picker_for_web/image_picker_for_web.dart';
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
  final xFile =
      // kIsWeb
      //     ? await ImagePickerPlugin().getMultiImageWithOptions()
      //     :
      await ImagePicker().pickMultiImage();
  if (xFile != null) {
    List<File> listOfXfile = [];
    xFile.forEach(
      (element) {
        debugPrint(element.path);

        listOfXfile.add(File(element.path));
      },
    );

    return listOfXfile;
  } else {
    return [File('')];
  }
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

Future<String> addSingleImage(ImageSource source) async {
//
  final xFile =
      //  kIsWeb
      //     ? await ImagePickerPlugin().getImageFromSource(source: source)
      //     :
      await ImagePicker().pickImage(source: source);

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

//call to subscribe
callSubScription(context,
    {String warning = '', required Function function}) async {
  if (kIsWeb) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return InstallApp();
        });
  } else if (!kIsWeb) {
    var res = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    String currentSubscription = res['currentSubscription'];
    bool isBlack = currentSubscription == 'black';
    if (isBlack) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Subscripe();
          });
    }
  } else {
    function;
  }
}

Future callOnlySubScription(context, {String warning = ''}) async {
  if (kIsWeb) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return InstallApp();
        });
  } else {
    var res = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    String currentSubscription = res['currentSubscription'];
    bool isBlack = currentSubscription == 'black';
    if (isBlack) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Subscripe();
          });
    }
  }
}

callToInstall(context) {
  if (kIsWeb) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: ListTile(
      leading: Icon(Icons.warning, color: Colors.red),
      title: Text(
          'this feature is only available on the mobile app, click to download and install'),
      trailing: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('app')
              .doc('url-link')
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData ||
                !snapshot.data!.exists) {
              return Center(child: Loading());
            } else {
              String urlLink = snapshot.data?['url'];
              return GestureDetector(
                  onTap: () async {
                    debugPrint('installit');
                    // http.get(Uri.parse(widget.installLink));
                    await launchUrl(Uri.parse(urlLink),
                        mode: LaunchMode.inAppBrowserView,
                        webOnlyWindowName: 'download fashion_dragon');
                  },
                  child: Icon(Icons.download, color: Colors.green));
            }
          }),
    )));
  }
}
