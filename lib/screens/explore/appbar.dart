import 'package:dressr/screens/chat/item.dart';
import 'package:dressr/screens/explore/loundry/book_loungry.dart';
import 'package:dressr/screens/management/index.dart';
import 'package:dressr/utils/chat_screen_button.dart';
// import 'package:dressr/utils/fluttter_pay.dart';
import 'package:dressr/utils/loading.dart';
import 'package:dressr/utils/my_profile_button.dart';
import 'package:dressr/utils/utils_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Orderr extends StatefulWidget {
  const Orderr({super.key});

  @override
  State<Orderr> createState() => OrderrState();
}

class OrderrState extends State<Orderr> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      height: 50,
      color: Colors.transparent,
      child: Row(children: [
        CircleAvatar(
          radius: 13,
          child: Stack(
            children: [
              //Loading(strokeWidth: 1),
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.blue, Colors.purple, Colors.red])
                      .createShader(bounds);
                },
                child: Center(
                  child: Icon(
                    Icons.star_rounded,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        //dressmate icon
        // ShaderMask(
        //   blendMode: BlendMode.srcIn,
        //   shaderCallback: (Rect bounds) => RadialGradient(
        //     center: Alignment.topLeft,
        //     stops: [.5, 1],
        //     colors: [Colors.blue, Colors.purple, Colors.red],
        //   ).createShader(bounds),
        //   child: Icon(
        //     Icons.star_rounded,
        //     size: 40,
        //   ),
        // ),

        SizedBox(width: 15),
//order button with money tag
        GestureDetector(
          onTap: () async {
            // showModalBottomSheet(
            //     context: context, builder: (context) => FlutterPay());
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(colors: [Colors.blue, Colors.purple])),
            child: Row(
              children: [
                Text('book us',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w900)),
                SizedBox(width: 5),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 10,
                )
              ],
            ),
          ),
        ),
        SizedBox(width: 10),
//drycleaner button
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
                isScrollControlled: true,
                // enableDrag: true,
                // showDragHandle: true,
                shape: ContinuousRectangleBorder(),
                backgroundColor: Colors.white60,
                context: context,
                builder: (context) {
                  return BookLoungry();
                });
          },
          child: Container(
            height: 20,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.purple, width: 1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text('dryclean',
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.purple,
                      fontWeight: FontWeight.w300)),
            ),
          ),
        ),
        Expanded(child: SizedBox()),
        IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout)),
        // ChatScreenButton(),
        // SizedBox(width: 7),

        IconButton(
          onPressed: () {
            Navigator.push(context,
                PageRouteBuilder(pageBuilder: (context, _, __) {
              return Management();
            }));
          },
          icon: Icon(Icons.explore),
        ),
        MyProfileButton(),
        SizedBox(width: 7)
      ]),
    );
  }
}
