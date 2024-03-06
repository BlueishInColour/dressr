import 'package:flutter/material.dart';

class Middle extends StatefulWidget {
  const Middle({super.key, this.width = 500, required this.child});
  final Widget child;
  final double width;
//keeps the app in the middle of the screen in web
  @override
  State<Middle> createState() => MiddleState();
}

class MiddleState extends State<Middle> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      width: 500,
      child: widget.child,
    ));
  }
}
