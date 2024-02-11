import 'package:flutter/material.dart';
import 'dart:math' as math;

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => LoadingState();
}

class LoadingState extends State<Loading> with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: Duration(seconds: 2))
        ..repeat();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Transform.rotate(
              angle: _controller.value * 10 * math.pi,
              child: child,
            );
          },
          child: ShaderMask(
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
                size: 40.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
