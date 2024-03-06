import 'package:dressr/view/utils/utils_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddShowlistButton extends StatefulWidget {
  const AddShowlistButton({super.key});

  @override
  State<AddShowlistButton> createState() => AddShowlistButtonState();
}

class AddShowlistButtonState extends State<AddShowlistButton> {
  final addShowlistController = TextEditingController();

  addCollectionToShowList() {
    showModalBottomSheet(
        enableDrag: true,
        isDismissible: true,
        showDragHandle: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Builder(builder: (context) {
              return Container(
                height: 200,
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    TextField(
                        controller: addShowlistController,
                        decoration: InputDecoration(hintText: 'showlist name')),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(child: SizedBox()),
                        ElevatedButton(
                            onPressed: () async {
                              // add it to the user list pof showlists
                              updateFirebaseDocument(context,
                                  collection: 'users',
                                  firebaseIdName: 'uid',
                                  id: FirebaseAuth.instance.currentUser!.uid,
                                  addKey: 'listOfShowlist',
                                  addObject: FieldValue.arrayUnion(
                                      [addShowlistController.text]));
                              addShowlistController.clear();
                            },
                            child: Text(' add ')),
                      ],
                    )
                  ],
                ),
              );
            }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          addCollectionToShowList();
        },
        icon: Icon(Icons.add, color: Colors.black));
  }
}
