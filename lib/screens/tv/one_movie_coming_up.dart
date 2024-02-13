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
    Timestamp start = snap['startTime'];
    Timestamp stop = snap['stopTime'];
    Timestamp now = Timestamp.now();
    bool isNowShowing = now.toDate().isAfter(start.toDate()) &&
        now.toDate().isBefore(stop.toDate());
    DateTime startt = start.toDate();
    DateTime stopp = stop.toDate();
    return ListTile(
      //time tot time
      leading: Text(
          isNowShowing ? 'now showing' : '${startt.hour} : ${startt.minute}',
          style: TextStyle(color: Colors.white)),
      //time tot time
      trailing: Text('${stopp.hour} : ${stopp.minute}',
          style: TextStyle(color: Colors.white)),
      //title of video
      title: Text(snap['title'],
          style: TextStyle(fontSize: 12, color: Colors.white)),
      //set alrm
      // trailing: IconButton(onPressed: ringAlarm, icon: Icon(Icons.alarm)),
      onTap: () {
        // showModalBottomSheet(
        //     context: context,
        //     builder: (context) => Container(
        //           padding: EdgeInsets.all(10),
        //           child: Text(snap['description']),
        //         ));
      },
    );
  }
}
