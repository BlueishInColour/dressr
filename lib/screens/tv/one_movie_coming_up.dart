import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class OneMovieComingUp extends StatefulWidget {
  const OneMovieComingUp({super.key, required this.postId, required this.snap});
  final String postId;
  final DocumentSnapshot<Object?> snap;

  @override
  State<OneMovieComingUp> createState() => OneMovieComingUpState();
}

class OneMovieComingUpState extends State<OneMovieComingUp> {
  ringAlarm() {}
  @override
  Widget build(BuildContext context) {
    DocumentSnapshot<Object?> snap = widget.snap;

    return ListTile(
      //time tot time
      leading: Text(''),
      //title of video
      title: Text(snap['title']),
      //set alrm
      trailing: IconButton(onPressed: ringAlarm, icon: Icon(Icons.alarm)),
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) => Container(
                  padding: EdgeInsets.all(10),
                  child: Text(snap['description']),
                ));
      },
    );
  }
}

Map<String, dynamic> document = {
  'id': Uuid().v1(),
  'title': '',
  'caption': '',
  'moviewLink': '',
  'movieLength': '',
  'startTime': '',
  'endTime': '',
};
