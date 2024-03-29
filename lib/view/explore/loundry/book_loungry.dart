import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_dragon/view/explore/loundry/laundry_controller/laundry_controller.dart';
import 'package:fashion_dragon/view/explore/loundry/laundry_history.dart';
import 'package:fashion_dragon/view/utils/middle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BookLoungry extends StatefulWidget {
  const BookLoungry({super.key});

  @override
  State<BookLoungry> createState() => BookLoungryState();
}

class BookLoungryState extends State<BookLoungry> {
  final listOfInt = List<int>.generate(100, (index) => index, growable: true);
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();

  @override
  initState() {
    super.initState();
    // getLatestPrices();
  }

  @override
  Widget build(BuildContext context) {
    speedAndStarch() {
      final deco = BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)));
      final ration = BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
        color: Colors.blue.shade100,
      );

      return Consumer<LaundryController>(
        builder: (context, value, child) =>
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
            height: 40,
            child: Row(
              children: [
                Container(
                    decoration: deco,
                    width: 32,
                    child: Center(
                        child: Icon(Icons.watch_later_outlined,
                            color: Colors.white))),
                Container(
                  decoration: ration,
                  width: 70,
                  child: DropdownButton<int>(
                      elevation: 0,
                      underline: SizedBox(),
                      value: value.expectedDay,
                      padding: EdgeInsets.only(left: 1.5),
                      icon: Icon(Icons.keyboard_arrow_down_outlined),
                      onChanged: <int>(newValue) =>
                          value.setExpectedDayValue(newValue),
                      items: listOfInt.map<DropdownMenuItem<int>>((e) {
                        return DropdownMenuItem(
                            child: Text('${e.toString()}' 'day',
                                style:
                                    TextStyle(overflow: TextOverflow.ellipsis)),
                            value: e);
                      }).toList()),
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            child: Row(children: [
              Container(
                  decoration: deco,
                  width: 32,
                  child: Center(child: Icon(Icons.soap, color: Colors.white))),
              Container(
                decoration: ration,
                width: 60,
                child: DropdownButton<bool>(
                    elevation: 0,
                    underline: SizedBox(),
                    value: value.isStarch,
                    padding: EdgeInsets.only(left: 1.5),
                    icon: Icon(Icons.keyboard_arrow_down_outlined),
                    onChanged: <bool>(newValue) =>
                        value.setStarchValue(newValue),
                    items: [
                      DropdownMenuItem(
                          child: Text('yes',
                              style:
                                  TextStyle(overflow: TextOverflow.ellipsis)),
                          value: true),
                      DropdownMenuItem(
                          child: Text('no',
                              style:
                                  TextStyle(overflow: TextOverflow.ellipsis)),
                          value: false)
                    ]),
              )
            ]),
          ),
        ]),
      );
    }

    countClothes() {
      final deco = BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)));
      final ration = BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
        color: Colors.blue.shade100,
      );
      return Consumer<LaundryController>(
        builder: (context, value, child) {
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 40,
                  child: Row(
                    children: [
                      Container(
                        decoration: deco,
                        width: 20,
                        child: Center(
                            child: Text(
                          'X',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                      Container(
                        decoration: ration,
                        child: DropdownButton<int>(
                            elevation: 0,
                            padding: EdgeInsets.only(left: 3),
                            icon: Icon(Icons.keyboard_arrow_down_outlined),
                            underline: SizedBox(),
                            value: value.smallSizeValue,
                            onChanged: <int>(newValue) {
                              value.setSmallSizeValue(newValue);
                            },
                            items: listOfInt.map<DropdownMenuItem<int>>((e) {
                              return DropdownMenuItem(
                                  child: Text(e.toString()), value: e);
                            }).toList()),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  child: Row(
                    children: [
                      Container(
                        decoration: deco,
                        width: 20,
                        child: Center(
                            child: Text(
                          'M',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                      Container(
                        decoration: ration,
                        child: DropdownButton(
                            elevation: 0,
                            padding: EdgeInsets.only(left: 3),
                            icon: Icon(Icons.keyboard_arrow_down_outlined),
                            underline: SizedBox(),
                            value: value.mediumSizeValue,
                            onChanged: <int>(newValue) {
                              value.setMediumSizeValue(newValue);
                            },
                            items: listOfInt.map<DropdownMenuItem<int>>((e) {
                              return DropdownMenuItem(
                                  child: Text(e.toString()), value: e);
                            }).toList()),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  child: Row(
                    children: [
                      Container(
                        decoration: deco,
                        width: 20,
                        child: Center(
                            child: Text(
                          'L',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                      Container(
                        decoration: ration,
                        child: DropdownButton(
                            elevation: 0,
                            underline: SizedBox(),
                            value: value.largeSizeValue,
                            padding: EdgeInsets.only(left: 3),
                            icon: Icon(Icons.keyboard_arrow_down_outlined),
                            onChanged: <int>(newValue) {
                              value.setLargeSizeValue(newValue);
                            },
                            items: listOfInt.map<DropdownMenuItem<int>>((e) {
                              return DropdownMenuItem(
                                  child: Text(e.toString()), value: e);
                            }).toList()),
                      ),
                    ],
                  ),
                )
              ]);
        },
      );
    }

    return Consumer<LaundryController>(
      builder: (context, value, child) => Middle(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
              automaticallyImplyLeading: true,
              title: Text('book laundry'),
              actions: [
                SizedBox(
                  height: 25,
                  child: OutlinedButton(
                      onPressed: () async =>
                          await Provider.of<LaundryController>(context,
                                  listen: false)
                              .selectImagesFromPhone(),
                      child: Text('add images')),
                ),
                SizedBox(width: 20),
                SizedBox(
                  height: 25,
                  child: OutlinedButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            showDragHandle: true,
                            builder: (context) {
                              return LoundryHistory();
                            });
                      },
                      child: Text('history')),
                ),
                SizedBox(width: 10)
              ]),
          body: Container(
            color: Colors.white70,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  //add image
                  value.listOfPicture.isEmpty
                      ? addImageWidget()
                      : ImageSlideshow(
                          autoPlayInterval: 3000,
                          indicatorBackgroundColor: Colors.white,
                          indicatorColor: Colors.blue,
                          height: 200,
                          children: context
                              .watch<LaundryController>()
                              .listOfPicture
                              .map((e) {
                            return imageWidget(index: 0, url: e);
                          }).toList(),
                        ),

                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'speed                |                starch',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                            fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  speedAndStarch(),

                  SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'count',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                            fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'note: shirt and trouser of same fabric is counted as two pieces',
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  countClothes(),
                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'an handler will get in touch with you once booking is completed',
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  FutureBuilder<String>(
                      future: value.getPhoneNumber(),
                      builder: (context, snapshot) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextField(
                            controller: phoneNumberController,
                            onChanged: (v) => value.setPhoneNumber(v),
                            decoration: InputDecoration(
                                hintText: snapshot.hasData ? snapshot.data : '',
                                labelText: 'phone number'),
                          ),
                        );
                      }),

                  SizedBox(height: 20),

                  FutureBuilder<String>(
                      future: value.getAddress(),
                      builder: (context, snapshot) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextField(
                            controller: addressController,
                            onChanged: (v) => value.setAdress(v),
                            decoration: InputDecoration(
                                hintText: snapshot.hasData ? snapshot.data : '',
                                labelText: 'address'),
                          ),
                        );
                      }),
                  SizedBox(height: 500),

                  //
                ],
              ),
            ),
          ),
          bottomSheet: Container(
            color: Colors.transparent,
            height: 50,
            child: Row(
              children: [
                //total cost
                Container(
                  // padding: EdgeInsets.all(10),

                  child: Row(
                    children: [
                      Text('#',
                          style: GoogleFonts.montserratAlternates(
                              color: Color.fromARGB(255, 1, 52, 93),
                              fontSize: 30,
                              fontWeight: FontWeight.w900)),
                      FutureBuilder<int>(
                          future: value.pricing(),
                          builder: (context, snapshot) {
                            return Text(
                                snapshot.hasData
                                    ? snapshot.data.toString()
                                    : "0",
                                style: GoogleFonts.montserratAlternates(
                                    color: Color.fromARGB(255, 1, 52, 93),
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900));
                          })
                    ],
                  ),
                ),
                SizedBox(width: 200),
                //button
                GestureDetector(
                  onTap: () async => await Provider.of<LaundryController>(
                          context,
                          listen: false)
                      .checkout(context),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    margin: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        gradient:
                            LinearGradient(begin: Alignment.topLeft, colors: [
                          // Colors.white,
                          Colors.blue,
                          Colors.black,
                        ]),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      ' checkout ',
                      style: GoogleFonts.montserrat(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.w500),
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imageWidget({String url = '', int index = 0}) {
    return Consumer<LaundryController>(
      builder: (context, value, child) => Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    colors: [Colors.white, Colors.blue, Colors.purple]),
                image: DecorationImage(
                    fit: BoxFit.cover, image: CachedNetworkImageProvider(url))),
          ),
          Positioned(
              top: 15,
              left: 15,
              child: GestureDetector(
                onTap: value.removeAt(index),
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        colors: [Colors.white, Colors.red]),
                  ),
                  child: Icon(Icons.delete_outline_outlined),
                ),
              ))
        ],
      ),
    );
  }

  addImageWidget() {
    return Consumer<LaundryController>(
        builder: (context, value, child) => GestureDetector(
            onTap: () async => await value.selectImagesFromPhone(),
            child: Container(
              padding: EdgeInsets.all(20),
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    colors: [Colors.blue, Colors.black]),
              ),
              child: Center(
                  child: CircleAvatar(
                      radius: 40, child: Icon(Icons.camera_alt, size: 50))),
            )));
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    context.dependOnInheritedWidgetOfExactType();
  }
}
