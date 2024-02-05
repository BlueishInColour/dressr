import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});
  @override
  State<LoadingPage> createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    bottomSheet(context) {
      return Container(
        color: Colors.black,
        height: 40,
        child: const Row(children: [
          AnimatedRotation(
            turns: 29990,
            curve: Curves.bounceIn,
            duration: Duration(seconds: 20),
            child: Icon(
              Icons.signal_wifi_4_bar_sharp,
              color: Colors.white60,
            ),
          ),
          SizedBox(width: 15),
          Text(
            'fetching stories,  make sure there`s internet connection',
            style: TextStyle(
                color: Colors.white60, overflow: TextOverflow.ellipsis),
          )
        ]),
      );
    }

    ;

    return Scaffold(
      body: Center(
          child: SizedBox(
        width: 450,
        child: ListView.builder(
            itemCount: 3, itemBuilder: (context, index) => const LoadingPod()),
      )),
      bottomSheet: bottomSheet(context),
    );
  }
}

class LoadingPod extends StatefulWidget {
  const LoadingPod({super.key});
  @override
  State<LoadingPod> createState() => LoadingPodState();
}

class LoadingPodState extends State<LoadingPod> {
  @override
  Widget build(BuildContext context) {
//
    Color color = Colors.green;

    Widget creatorHeader(context) {
      return (Row(children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: color,
        ),
        const SizedBox(width: 5),
        const SizedBox(width: 3),
        Container(
          height: 30,
          width: 200,
          decoration: BoxDecoration(
              gradient: RadialGradient(
                  focalRadius: 20,
                  radius: 13,
                  colors: [Colors.black, Colors.green, Colors.blue]),
              borderRadius: BorderRadius.circular(15)),
        )
      ]));
    }

    Widget image(context) {
      return SizedBox(
          width: 450,
          // height: 250,
          child: Container(
            height: 250,
            decoration: BoxDecoration(
                gradient: RadialGradient(
                    focalRadius: 20,
                    radius: 3,
                    colors: [Colors.black, Colors.green, Colors.blue]),
                // color: color,
                borderRadius: BorderRadius.circular(15)),
          ));
    }

    Widget textBody(context) {
      return Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(
                focalRadius: 20,
                radius: 15,
                colors: [Colors.black, Colors.green, Colors.blue]),
            borderRadius: BorderRadius.circular(15)),
        height: 25,
      );
    }

    Widget bottom(context) {
      return Container(
        height: 30,
        // color: color,
        decoration: BoxDecoration(
          gradient: RadialGradient(
              focalRadius: 2,
              radius: 3,
              colors: [Colors.black, Colors.green, Colors.blue]),
        ),
        margin: const EdgeInsets.all(5),
      );
    }

    return Container(
      // height: widget.podHeight,
      width: 500,

      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Column(
        children: [
          creatorHeader(context),
          const SizedBox(height: 10),
          image(context),

          const SizedBox(height: 10),

          textBody(context),

          const SizedBox(height: 4),

          // styledivider
        ],
      ),
    );
  }
}
