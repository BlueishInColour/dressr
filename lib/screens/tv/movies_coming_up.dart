import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressr/screens/tv/one_movie_coming_up.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';

class MoviesComingUp extends StatefulWidget {
  const MoviesComingUp({super.key});

  @override
  State<MoviesComingUp> createState() => PartnershipScreenState();
}

class PartnershipScreenState extends State<MoviesComingUp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FirestorePagination(
          query: FirebaseFirestore.instance
              .collection('tv')
              .doc('movies')
              .collection('youtube')
              .orderBy('timestamp', descending: false),
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemBuilder: (context, snap, index) {
            return OneMovieComingUp(
              postId: snap['postId'],
              snap: snap,
            );
          }),
    );
  }
}
