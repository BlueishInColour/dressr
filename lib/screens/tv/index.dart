import 'package:dressr/screens/tv/movies_coming_up.dart';
import 'package:dressr/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// import 'package:flutter_youtube_player/flutter_youtube_player.dart';

class Tv extends StatefulWidget {
  const Tv({super.key});

  @override
  State<Tv> createState() => TvState();
}

class TvState extends State<Tv> {
  String getIdFromLink() {
    var videoId = YoutubePlayer.convertUrlToId(
        "https://youtu.be/XoiOOiuH8iI?si=nIbhSwMHvjY2YgPa");
    print(videoId); // BBAyRBTfsOU
    return videoId ?? '';
  }

  @override
  Widget build(BuildContext context) {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: getIdFromLink(),
      flags: YoutubePlayerFlags(
        hideControls: true,
        //  showLiveFullscreenButton: true,
        disableDragSeek: true,
        autoPlay: false,
        //possibly use this to set play time
        hideThumbnail: true,
        // startAt:
        useHybridComposition: true, controlsVisibleAtStart: false,

        mute: false,
      ),
    );
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(2)),
            context: context,
            builder: (context) => MoviesComingUp());
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 17, 1, 47),
        body: Center(
          child: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            bottomActions: [],
            topActions: [],
            thumbnail: Container(
              child: Center(child: Loading()),
            ),
          ),
        ),

        //      PotraitPlayer(
        //   link: 'YOUR_YOUTUBE_VIDEO_URL',
        //   aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
        //   kColorWhite: Colors.white, // Optional: Customize color themes
        //   kColorPrimary: Colors.orange,
        //   kColorBlack: Colors.black,
        // )
      ),
    );
  }
}
