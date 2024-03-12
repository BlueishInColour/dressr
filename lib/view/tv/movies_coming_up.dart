import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_dragon/view/tv/one_movie_coming_up.dart';
import 'package:fashion_dragon/view/management/set_programmes.dart';
import 'package:fashion_dragon/view/utils/loading.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MoviesComingUp extends StatefulWidget {
  const MoviesComingUp({super.key});

  @override
  State<MoviesComingUp> createState() => PartnershipScreenState();
}

class PartnershipScreenState extends State<MoviesComingUp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(234, 13, 1, 61),
      child: Column(
        children: [
          Row(
            children: [
              kIsWeb
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'showing on Mobile App, install to watch!',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w900),
                        ),
                        FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('app')
                                .doc('url-link')
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  !snapshot.hasData ||
                                  !snapshot.data!.exists) {
                                return Center(child: Loading());
                              } else {
                                String urlLink = snapshot.data?['url'];
                                return GestureDetector(
                                    onTap: () async {
                                      debugPrint('installit');
                                      // http.get(Uri.parse(widget.installLink));
                                      await launchUrl(Uri.parse(urlLink),
                                          mode: LaunchMode.inAppBrowserView,
                                          webOnlyWindowName:
                                              'download fashion_dragon');
                                    },
                                    child: Icon(Icons.download,
                                        color: Colors.green));
                              }
                            }),
                      ],
                    )
                  : SizedBox()
            ],
          ),
          Expanded(
            child: FirestorePagination(
                isLive: true,
                bottomLoader: Loading(),
                initialLoader: Loading(),
                query: FirebaseFirestore.instance
                    .collection('tv')
                    .doc('movies')
                    .collection('youtube')
                    .where('stopTime', isGreaterThan: Timestamp.now())
                    .orderBy('stopTime', descending: false),
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
                }),
          ),
        ],
      ),
    );
  }
}
