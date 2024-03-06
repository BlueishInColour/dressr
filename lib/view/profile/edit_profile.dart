import 'package:dressr/view/utils/middle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../utils/utils_functions.dart';

class EditProfil extends StatefulWidget {
  const EditProfil({super.key});

  @override
  State<EditProfil> createState() => EditProfilState();
}

class EditProfilState extends State<EditProfil> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController displaynameController = TextEditingController();

  TextEditingController typeOfUserController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(hintText: 'new diplay name'),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            controller: displaynameController,
            decoration: InputDecoration(hintText: 'new username'),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            controller: typeOfUserController,
            decoration: InputDecoration(hintText: 'short caption'),
          ),
          SizedBox(height: 20),
          TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('users').add({
                  'uid': FirebaseAuth.instance.currentUser!.uid,
                  'userName': usernameController.text,
                  'typeOfUser': typeOfUserController.text,
                  'displayName': displaynameController.text,
                  'listOfLikers': [],
                  'listOfLikedPosts': []
                });
                // Navigator.pop(context);
                debugPrint('done');
              },
              child: Text('save')),
          SizedBox(
            height: 100,
          ),
          Text('do this before signing up')
        ],
      ),
    );
  }
}

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController displaynameController = TextEditingController();

  TextEditingController typeOfUserController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Middle(
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: true),
        body: SizedBox(
          height: 400,
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(hintText: 'new diplay name'),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: displaynameController,
                decoration: InputDecoration(hintText: 'new username'),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: typeOfUserController,
                decoration: InputDecoration(hintText: 'short caption'),
              ),
              SizedBox(height: 20),
              TextButton(
                  onPressed: () async {
                    Map userDetails =
                        getUserDetails(FirebaseAuth.instance.currentUser!.uid);
                    if (userDetails.isEmpty) {
                      await FirebaseFirestore.instance.collection('users').add({
                        'uid': FirebaseAuth.instance.currentUser!.uid,
                        'profilePiture':
                            'https://ik.imagekit.io/bluerubic/flutter_imagekit/afilename_sbfW8SCgg_', //'https://source.unsplash.com/random',
                        'userName': usernameController.text,
                        'typeOfUser': typeOfUserController.text,
                        'displayName': displaynameController.text,
                        'listOfLikers': [],
                        'listOfLikedPosts': []
                      });
                      debugPrint('done');

                      Navigator.pop(context);
                    } else {
                      Scaffold.of(context).showBottomSheet((context) =>
                          SnackBar(
                              content: Text(
                                  'you cannot change this details but once')));

                      Navigator.pop(context);
                    }
                  },
                  child: Text('save')),
              SizedBox(
                height: 100,
              ),
              Text('do this before signing up')
            ],
          ),
        ),
      ),
    );
  }
}
