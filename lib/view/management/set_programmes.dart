import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressr/view/utils/middle.dart';
import 'package:dressr/view/tv/one_movie_coming_up.dart';
import 'package:dressr/view/utils/loading.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_video_info/youtube.dart';

class SetProgramme extends StatefulWidget {
  const SetProgramme({super.key});

  @override
  State<SetProgramme> createState() => SetProgrammeState();
}

class SetProgrammeState extends State<SetProgramme> {
  bool showSetUrl = true;
  TextEditingController setUrlController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  String description = '';
  TimeOfDay startTime = TimeOfDay.now();

  DateTime join(TimeOfDay time) {
    DateTime date = DateTime.now();
    return new DateTime(
        date.year, date.month, date.day, time.hour, time.minute);
  }

  TimeOfDay stopTime = TimeOfDay.now();
  getTitle() async {
    YoutubeDataModel videoData =
        await YoutubeData.getData(setUrlController.text);
    debugPrint(videoData.title);
    setState(() {
      description = videoData.fullDescription!;
      titleController.text = videoData.title!;
    });
  }

  getStartTime() async {
    var res = await FirebaseFirestore.instance
        .collection('tv')
        .doc('movies')
        .collection('youtube')
        .orderBy('timestamp', descending: true)
        .get();
//the starttime of the next one is the stoptime of the last one
    Timestamp startTimestamp = res.docs.first['stopTime'];
    DateTime startDateTime = startTimestamp.toDate();
    TimeOfDay startTimeOfDay = TimeOfDay.fromDateTime(startDateTime);
    setState(() {
      startTime = startTimeOfDay;
    });
    return startDateTime;
  }

  getStopTime() async {
    YoutubeDataModel videoData =
        await YoutubeData.getData(setUrlController.text);

    //length of movie
    int lengthOfMovie = videoData.durationSeconds! * 1000000;
    debugPrint('lengthOFMOvie  ${lengthOfMovie.toString()}');
//start time microseconds since first day
    DateTime startTim = await getStartTime();
    int startTimeInInt = startTim.microsecondsSinceEpoch;
    debugPrint('start time since ${startTimeInInt.toString()}');
    //
    int timeMovieWillFinish = lengthOfMovie + startTimeInInt;
    //convertitTotimeback
    DateTime newStopDateTime =
        DateTime.fromMicrosecondsSinceEpoch(timeMovieWillFinish);
    TimeOfDay newStopTime = TimeOfDay.fromDateTime(newStopDateTime);
    debugPrint('new stopTime ${timeMovieWillFinish.toString()}');
    print(newStopTime);
    print(newStopDateTime);
    setState(() {
      stopTime = newStopTime;
    });
  }

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

  upload() async {
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
        'description': description,
        'timestamp': Timestamp.now(),
        'startTime': Timestamp.fromDate(startingtime),
        'stopTime': Timestamp.fromDate(stopingtime)
      }).whenComplete(() {
        titleController.clear();
        setUrlController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Middle(
      child: Scaffold(
          backgroundColor: Colors.black87,
          floatingActionButton: FloatingActionButton(
            onPressed: upload,
            backgroundColor: Colors.purple,
            child: Icon(Icons.upload, color: Colors.black),
          ),
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
                        showDelete: true,
                        snap: snap,
                      );
                    }))
          ])),
    );
  }

  Widget setUrl() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: Column(
          children: [
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
            SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: titleController,
                decoration: InputDecoration(
                    hintText: 'title',
                    prefix: IconButton(
                        onPressed: getTitle,
                        icon: Icon(Icons.refresh, color: Colors.white))),
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: getStartTime,
                  child: Text(
                    'start ${startTime.hour}:${startTime.minute}',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                IconButton(
                  onPressed: () async => await _startTime(context),
                  icon: Icon(Icons.timer, color: Colors.white60),
                ),
                TextButton(
                  onPressed: getStopTime,
                  child: Text(
                    ' stop  ${stopTime.hour}:${stopTime.minute}',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                IconButton(
                  onPressed: () async => await _stopTime(context),
                  icon: Icon(Icons.timer, color: Colors.white60),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
