import 'package:dressr/screens/chat/item.dart';
import 'package:dressr/utils/utils_functions.dart';
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
      height: 35,
      color: Colors.transparent,
      child: Row(children: [
//order button with money tag
        GestureDetector(
          onTap: () async {
            callOnlySubScription(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(colors: [Colors.blue, Colors.purple])),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('order',
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w900)),
                    Text('a/c #1.2k',
                        style: TextStyle(fontSize: 10, color: Colors.white))
                  ],
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 16,
                )
              ],
            ),
          ),
        ),
        SizedBox(width: 10),
//drycleaner button
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                PageRouteBuilder(pageBuilder: (context, _, __) {
              return Item(
                uid: 'qHr2JjqrNydJ01rrRTftgWlVxnK2',
                hintText: 'i want your service',
              );
            }));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('dryclean',
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                            fontWeight: FontWeight.w900)),
                    Text('#250/pics',
                        style: TextStyle(fontSize: 8, color: Colors.black))
                  ],
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.black,
                  size: 16,
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
