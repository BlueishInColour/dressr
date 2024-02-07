import 'package:dressr/middle.dart';
import 'package:dressr/screens/auth/auth_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/utils_functions.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, required this.onPressed});
  final void Function()? onPressed;

  @override
  State<SignupScreen> createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  Icon usernameSuffixICon = Icon(Icons.edit);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final secondPasswordController = TextEditingController();

  //
  final List<String> userTags = [];
  final displayNameController = TextEditingController();
  final userNameController = TextEditingController();
  final captionController = TextEditingController();
  // final userTagsController = TextEditingController();
  String profilePicture =
      'https://ik.imagekit.io/bluerubic/flutter_imagekit/afilename_sbfW8SCgg_'; // 'https://source.unsplash.com/random';

  bool setProfile = false;
  bool seePassword = true;
  bool isLoading = false;
  bool passwordIsNotMatch = false;

  //
  String userNameText = '';
  changeSetProfilebool() {
    if (passwordController.text != secondPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
        children: [
          Icon(Icons.error, color: Colors.red),
          SizedBox(width: 10),
          Text('passwords dont match')
        ],
      )));
    } else {
      setState(() {
        setProfile = !setProfile;
      });
    }
  }

  signup() async {
    setState(() {
      isLoading = true;
    });
    if (userNameController.text.isNotEmpty &&
        displayNameController.text.isNotEmpty &&
        profilePicture.isNotEmpty &&
        captionController.text.isNotEmpty) {
      if (passwordController.text != secondPasswordController.text) {
        return ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('both passwords don`t match')));
      } else {
        try {
          await AuthService()
              .signup(emailController.text, passwordController.text);
        } catch (e) {
          setState(() {
            isLoading = false;
          });
          return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString()),
            showCloseIcon: true,
          ));
        }
      }

      setState(() {
        //create tags for user
        userTags.addAll(userNameController.text.split(' '));
        userTags.add(displayNameController.text);
        userTags.addAll(captionController.text.split(' '));
        //
      });
      //
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'profilePicture': profilePicture,
        'userName': userNameController.text,
        'caption': captionController.text,
        'displayName': displayNameController.text,
        'email': emailController.text,
        'listOfLikers': [],
        'listOfLikedPosts': [],
        'listOfShowlist': ['for later'],
        'currentSubscription': 'black',
        'currentSubscriptionExpire':
            Timestamp.fromDate(DateTime.parse('20230101'))
      });
    } else {
      setState(() {
        isLoading = false;
      });
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('fill everything to complete set up'),
        showCloseIcon: true,
      ));
    }
  }

  setProfilePicture() async {
    String url = await addSingleImage(ImageSource.gallery);
    setState(() {
      profilePicture = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !setProfile
        ? Middle(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      SizedBox(
                        height: 60,
                        child: TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter an email address';
                            } else if (!RegExp(
                                    r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null; // Return null if the input is valid
                          },
                          decoration: InputDecoration(
                            hintText: 'email',
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      SizedBox(
                        height: 60,
                        child: TextField(
                          controller: passwordController,
                          obscureText: seePassword,
                          decoration: InputDecoration(
                              hintText: 'password',
                              suffix: IconButton(
                                onPressed: () {
                                  setState(() {
                                    seePassword = !seePassword;
                                  });
                                },
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  color: seePassword
                                      ? Colors.blue
                                      : Colors.black45,
                                ),
                              )),
                        ),
                      ),
                      SizedBox(height: 15),
                      SizedBox(
                        height: 60,
                        child: TextField(
                          controller: secondPasswordController,
                          obscureText: seePassword,
                          decoration:
                              InputDecoration(hintText: 'confirm password'),
                        ),
                      ),
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: changeSetProfilebool,
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black45, width: 2),
                              borderRadius: BorderRadius.circular(15),
                              color: const Color.fromRGBO(0, 0, 0, 1)),
                          height: 60,
                          child: Center(
                              child: Text('next',
                                  style: TextStyle(color: Colors.white))),
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Text('you have an account?'),
                          TextButton(
                              onPressed: widget.onPressed,
                              child: Text('login now'))
                        ],
                      ),
                    ])),
              ),
            ),
          )
        :
        //setProfile
        Middle(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Center(
                  child: ListView(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: changeSetProfilebool,
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black45, width: 2),
                              borderRadius: BorderRadius.circular(15),
                              color: const Color.fromRGBO(0, 0, 0, 1)),
                          height: 60,
                          child: Center(
                              child: Text('signup',
                                  style: TextStyle(color: Colors.white))),
                        ),
                      ),

                      SizedBox(height: 15),

                      //profile picture
                      CircleAvatar(
                        radius: 70,
                        backgroundImage:
                            CachedNetworkImageProvider(profilePicture),
                      ),
                      TextButton(
                          onPressed: setProfilePicture,
                          child: Text('set profile picture')),
                      SizedBox(
                        height: 30,
                      ),
                      //set desplay name
                      TextField(
                        controller: displayNameController,
                        decoration: InputDecoration(hintText: 'name'),
                      ),
                      SizedBox(height: 15),
                      //set profile picture
                      SizedBox(
                        height: 55,
                        child: TextField(
                            controller: userNameController,
                            onChanged: (text) {
                              setState(() {
                                userNameText = text;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: 'unique username',
                                prefixIcon:
                                    Icon(Icons.alternate_email_outlined),
                                suffixIcon: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .where('userName',
                                            isEqualTo: userNameText)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      var snap = snapshot.data?.docs.isEmpty;
                                      bool isUserNameAvailable = snap ?? false;
                                      if (userNameText.isEmpty) {
                                        return Icon(Icons.edit);
                                      }
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return SizedBox(
                                          width: 5,
                                          height: 5,
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.active) {
                                        if (userNameText.isEmpty) {
                                          return Icon(Icons.edit);
                                        }
                                        if (!isUserNameAvailable) {
                                          return Icon(Icons.error,
                                              color: Colors.red);
                                        } else {
                                          return Icon(Icons.check,
                                              color: Colors.green);
                                        }
                                      } else {
                                        return Icon(Icons.edit);
                                      }
                                    }))),
                      ),

                      SizedBox(height: 15),
                      SizedBox(
                        height: 100,
                        child: TextField(
                          minLines: 3,
                          maxLines: 10,
                          controller: captionController,
                          decoration: InputDecoration(
                              hintText:
                                  'describe yourself in 100 letters, helps in searches'),
                        ),
                      ),

                      SizedBox(height: 15),

                      //signupbutton
                      GestureDetector(
                        onTap: () async {
                          signup();
                        },
                        child: !isLoading
                            ? Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black45, width: 2),
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color.fromRGBO(0, 0, 0, 1)),
                                height: 60,
                                child: Center(
                                    child: Text('signup',
                                        style: TextStyle(color: Colors.white))),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black45, width: 2),
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color.fromRGBO(0, 0, 0, 1)),
                                height: 60,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ),
                      ),

                      //back
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
