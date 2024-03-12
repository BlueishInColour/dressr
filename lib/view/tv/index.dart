import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_dragon/view/utils/middle.dart';
import 'package:fashion_dragon/view/tv/movies_coming_up.dart';
import 'package:fashion_dragon/view/utils/loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:youtube_player_iframe_plus/youtube_player_iframe_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// import 'package:flutter_youtube_player/flutter_youtube_player.dart';

class Tv extends StatefulWidget {
  const Tv({super.key});

  @override
  State<Tv> createState() => TvState();
}

class TvState extends State<Tv> {
  String getIdFromLink(
      {String url = "https://youtu.be/LWeiydKl0mU?si=4dfFr1iwWCDQucyR"}) {
    var videoId = YoutubePlayer.convertUrlToId(url);
    print(videoId); // BBAyRBTfsOU
    return videoId ?? '';
  }

  int startPlayAt = 0;
  startAt() async {
    var res = await FirebaseFirestore.instance
        .collection('tv')
        .doc('movies')
        .collection('youtube')
        .where(
          'stopTime',
          isGreaterThan: Timestamp.now(),
        )
        .get();

    Timestamp startTimeTimestamp = res.docs.first['startTime'];
    // startTimeTimestamp
    Timestamp now = Timestamp.now();
    int startTimeInSeconds = startTimeTimestamp.seconds;

    int nowInSeconds = now.seconds;
    int seekToPosition = nowInSeconds - startTimeInSeconds;
    seekToPosition;
    debugPrint(seekToPosition.toString());
    debugPrint(seekToPosition.toString());
    debugPrint(seekToPosition.toString());
    debugPrint(seekToPosition.toString());
    debugPrint(seekToPosition.toString());
    debugPrint(seekToPosition.toString());
    debugPrint(seekToPosition.toString());
    setState(() {
      startPlayAt = seekToPosition;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startAt();
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? MoviesComingUp()
        : GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                  context: context,
                  builder: (context) => MoviesComingUp());
            },
            child: Middle(
              child: Scaffold(
                backgroundColor: Color.fromARGB(255, 17, 1, 47),
                body: Center(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('tv')
                          .doc('movies')
                          .collection('youtube')
                          .where(
                            'stopTime',
                            isGreaterThan: Timestamp.now(),
                          )
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.data!.docs.isEmpty ||
                            !snapshot.hasData) {
                          return Center(
                              child: Icon(Icons.star_half_rounded,
                                  color: Colors.white38, size: 150));
                        }
                        if (snapshot.hasData) {
                          // if()

                          String url = snapshot.data!.docs.first['url'];
                          return
                              //  YoutubeValueBuilder(
                              //   controller: YoutubePlayerController(
                              //     initialVideoId: 'nPt8bK2gbaU', // getIdFromLink(),
                              //     params: YoutubePlayerParams(
                              //       startAt: Duration(seconds: 30),
                              //       showControls: false,
                              //       autoPlay: true,
                              //       enableKeyboard: false,
                              //       showVideoAnnotations: true,
                              //       showFullscreenButton: true,
                              //     ),
                              //   ), // This can be omitted, if using `YoutubePlayerControllerProvider`
                              //   builder: (context, value) {
                              //     return SizedBox();
                              //   },
                              // );
                              YoutubePlayer(
                            controller: YoutubePlayerController(
                              initialVideoId: getIdFromLink(url: url),
                              flags: YoutubePlayerFlags(
                                hideControls: true,
                                //  showLiveFullscreenButton: true,
                                disableDragSeek: true,
                                autoPlay: false,
                                //possibly use this to set play time
                                hideThumbnail: true,
                                startAt: startPlayAt,
                                useHybridComposition: true,
                                controlsVisibleAtStart: false,

                                mute: false,
                              ),
                            ),
                            showVideoProgressIndicator: true,
                            bottomActions: [],
                            topActions: [],
                            progressIndicatorColor: Colors.white,
                            thumbnail: Container(
                              child: Center(child: Loading()),
                            ),
                          );
                        } else {
                          return Loading();
                        }
                      }),
                ),

                //      PotraitPlayer(
                //   link: 'YOUR_YOUTUBE_VIDEO_URL',
                //   aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
                //   kColorWhite: Colors.white, // Optional: Customize color themes
                //   kColorPrimary: Colors.orange,
                //   kColorBlack: Colors.black,
                // )
              ),
            ),
          );
  }
}
