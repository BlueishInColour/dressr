import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressr/middle.dart';
import 'package:dressr/utils/loading.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';

class OrderDressMake extends StatefulWidget {
  const OrderDressMake({super.key});

  @override
  State<OrderDressMake> createState() => OrderDressMakeState();
}

class OrderDressMakeState extends State<OrderDressMake> {
  @override
  Widget build(BuildContext context) {
    return Middle(
      child: Scaffold(
          appBar: AppBar(),
          body: FirestorePagination(
            bottomLoader: Loading(),
            initialLoader: Loading(),
            onEmpty: Loading(size: 60),
            query: FirebaseFirestore.instance.collection('order'),
            itemBuilder: (context, snap, index) {
              return OrderItem(snap: snap);
            },
          )),
    );
  }
}

// import 'package:flutter/material.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({super.key, required this.snap});
  final DocumentSnapshot<Object?> snap;

  @override
  State<OrderItem> createState() => OrderItemState();
}

class OrderItemState extends State<OrderItem> {
  @override
  Widget build(BuildContext context) {
    String picture = widget.snap['picture'];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(children: [
        //photo in short form,
        Container(
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              image:
                  DecorationImage(image: CachedNetworkImageProvider(picture))),
        )
        //row of date // pay or paid //

        //row of progress  bar in form of accepted//workinprogress//ondelivery//delivered
      ]),
    );
  }
}
