import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressr/middle.dart';
import 'package:dressr/screens/tv/one_movie_coming_up.dart';
import 'package:dressr/utils/loading.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SetProgramme extends StatefulWidget {
  const SetProgramme({super.key});

  @override
  State<SetProgramme> createState() => SetProgrammeState();
}

class SetProgrammeState extends State<SetProgramme> {
  bool showSetUrl = true;
  TextEditingController setUrlController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  TimeOfDay startTime = TimeOfDay.now();

  TimeOfDay stopTime = TimeOfDay.now();

  Future<void> _startTime(BuildContext context) async {
    final TimeOfDay? picked_s = await showTimePicker(
        context: context,
        initialTime: startTime,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });

    if (picked_s != null && picked_s != startTime)
      setState(() {
        debugPrint('setted');

        startTime = picked_s;
      });
  }

  Future<void> _stopTime(BuildContext context) async {
    final TimeOfDay? picke = await showTimePicker(
        context: context,
        initialTime: stopTime,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });

    if (picke != null && picke != stopTime)
      setState(() {
        debugPrint('setted');
        stopTime = picke;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Middle(
      child: Scaffold(
          backgroundColor: Colors.black87,
          appBar: AppBar(),
          body: Column(children: [
            setUrl(),
            Expanded(
                child: FirestorePagination(
                    isLive: true,
                    bottomLoader: Loading(),
                    initialLoader: Loading(),
                    query: FirebaseFirestore.instance
                        .collection('tv')
                        .doc('movies')
                        .collection('youtube')
                        .orderBy('timestamp', descending: true),
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    onEmpty: Center(
                      child: Text('no movie yet'),
                    ),
                    itemBuilder: (context, snap, index) {
                      return OneMovieComingUp(
                        postId: snap['id'],
                        snap: snap,
                      );
                    }))
          ])),
    );
  }

  DateTime join(TimeOfDay time) {
    DateTime date = DateTime.now();
    return new DateTime(
        date.year, date.month, date.day, time.hour, time.minute);
  }

  Widget setUrl() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 170,
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: titleController,
                decoration: InputDecoration(hintText: 'title'),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
                height: 60,
                child: TextField(
                    controller: setUrlController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'url',
                      //suffix widget to send url

                      //prefix to pick time
                    ))),
            Row(
              children: [
                Text(
                  'start ${startTime.hour}:${startTime.minute}',
                  style: TextStyle(color: Colors.white70),
                ),
                IconButton(
                  onPressed: () async => await _startTime(context),
                  icon: Icon(Icons.timer, color: Colors.white60),
                ),
                Text(
                  ' stop  ${stopTime.hour}:${stopTime.minute}',
                  style: TextStyle(color: Colors.white70),
                ),
                IconButton(
                  onPressed: () async => await _stopTime(context),
                  icon: Icon(Icons.timer, color: Colors.white60),
                ),
                IconButton(
                    onPressed: () async {
                      DateTime startingtime = join(startTime);
                      DateTime stopingtime = join(stopTime);
                      if (setUrlController.text.isNotEmpty) {
                        String id = Uuid().v1();
                        await FirebaseFirestore.instance
                            .collection('tv')
                            .doc('movies')
                            .collection('youtube')
                            .doc(id)
                            .set({
                          'id': id,
                          'url': setUrlController.text,
                          'title': titleController.text,
                          'timestamp': Timestamp.now(),
                          'startTime': Timestamp.fromDate(startingtime),
                          'stopTime': Timestamp.fromDate(stopingtime)
                        }).whenComplete(() {
                          titleController.clear();
                          setUrlController.clear();
                        });
                      }
                    },
                    icon: Icon(
                      Icons.upload,
                      color: Colors.white70,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
