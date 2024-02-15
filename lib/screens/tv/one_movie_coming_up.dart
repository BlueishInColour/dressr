import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class OneMovieComingUp extends StatefulWidget {
  const OneMovieComingUp(
      {super.key,
      required this.postId,
      this.showDelete = false,
      required this.snap});
  final String postId;
  final bool showDelete;
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
    delete() async {
      await FirebaseFirestore.instance
          .collection('tv')
          .doc('movies')
          .collection('youtube')
          .doc(widget.postId)
          .delete();
    }

    return ListTile(
      //time tot time
      leading: Text(
          isNowShowing ? 'now showing' : '${startt.hour} : ${startt.minute}',
          style: TextStyle(color: Colors.white)),
      //time tot time
      trailing: widget.showDelete
          ? IconButton(
              onPressed: delete,
              icon: Icon(Icons.delete, color: Colors.red),
            )
          : Text('${stopp.hour} : ${stopp.minute}',
              style: TextStyle(color: Colors.white)),
      //title of video
      title: Text(snap['title'],
          style: TextStyle(fontSize: 12, color: Colors.white)),
      //set alrm
      // trailing: IconButton(onPressed: ringAlarm, icon: Icon(Icons.alarm)),
      onTap: () {
        showModalBottomSheet(
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(2)),
            context: context,
            builder: (context) => Container(
                  color: Color.fromARGB(234, 13, 1, 61),
                  padding: EdgeInsets.all(10),
                  // margin: EdgeInsets.all(10),
                  child: ListView(
                    children: [
                      Row(
                        children: [
                          Text('caption',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(snap['description'],
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ));
      },
    );
  }
}
