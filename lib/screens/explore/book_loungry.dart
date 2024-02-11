import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressr/utils/utils_functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imagekit_io/imagekit_io.dart';

class BookLoungry extends StatefulWidget {
  const BookLoungry({super.key});

  @override
  State<BookLoungry> createState() => BookLoungryState();
}

class BookLoungryState extends State<BookLoungry> {
  List listOfPicture = [];
  final listOfInt =
      List<String>.generate(100, (index) => index.toString(), growable: true);
  bool isItUrgent = false;

  String smallSizeValue = '1';
  String mediumSizeValue = '1';
  String LargeSizeValue = '1';

  @override
  Widget build(BuildContext context) {
    countClothes({selectedValue = '', String typeOfSize = 'X'}) {
      return Row(
        children: [
          Container(
            color: Colors.purple.shade900,
            width: 30,
            height: 30,
            child: Center(
                child: Text(
              'X',
              style: TextStyle(color: Colors.white),
            )),
          ),
          DropdownButton(
              value: selectedValue,
              onChanged: (newValue) {
                setState(() {
                  selectedValue = newValue;
                });
              },
              items: listOfInt.map<DropdownMenuItem<Object>>((e) {
                return DropdownMenuItem(
                    child: Text(e.toString()), value: e.toString());
              }).toList()),
        ],
      );
    }

    return Container(
      height: MediaQuery.of(context).size.height - 80,
      color: Colors.white70,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //add image
            listOfPicture.isEmpty
                ? Row(
                    children: [addImageWidget()],
                  )
                : SizedBox(
                    height: 400,
                    child: ListView.builder(
                        itemCount: listOfPicture.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: ((context, index) {
                          // if (index == listOfPicture.length + 1) {
                          //   return addImageWidget();
                          // }
                          return imageWidget(
                              url: listOfPicture[index], index: index);
                        })),
                  ), //is it urgent

            Row(
              children: [
                Expanded(
                    child: Text(
                  'Is it urgent?',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 105, 0, 124),
                      fontWeight: FontWeight.w500),
                )),
                Switch.adaptive(
                    value: isItUrgent,
                    onChanged: (v) {
                      setState(() {
                        isItUrgent = v;
                      });
                    })
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('sizes and count'),

                //X small
                countClothes(selectedValue: smallSizeValue, typeOfSize: 'X'),
                countClothes(selectedValue: mediumSizeValue, typeOfSize: 'M'),
                countClothes(selectedValue: LargeSizeValue, typeOfSize: 'L')
                //M mideom

                //large
              ],
            ),
            Expanded(child: SizedBox()),

            Row(
              children: [
                //total cost
                Expanded(
                    child: Container(
                  // height: 70,

                  // padding: EdgeInsets.all(10),

                  child: Text('#24,000',
                      style: GoogleFonts.montserratAlternates(
                          color: Color.fromARGB(255, 1, 52, 93),
                          fontSize: 30,
                          fontWeight: FontWeight.w900)),
                )),
                //button
                Container(
                  padding: EdgeInsets.all(7),
                  margin: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      gradient:
                          LinearGradient(begin: Alignment.topLeft, colors: [
                        Colors.white,
                        Colors.blue,
                        // Colors.purple,
                      ]),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15))),
                  child: Center(
                      child: Text(
                    '  book  ',
                    style: GoogleFonts.montserrat(
                        color: Colors.white60,
                        fontSize: 15,
                        fontWeight: FontWeight.w900),
                  )),
                )
              ],
            )
            //
          ],
        ),
      ),
    );
  }

  imageWidget({String url = '', int index = 0}) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(7),
          padding: EdgeInsets.all(7),
          height: 350,
          width: 250,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  colors: [Colors.white, Colors.blue, Colors.purple]),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
              image: DecorationImage(
                  fit: BoxFit.cover, image: CachedNetworkImageProvider(url))),
        ),
        Positioned(
            top: 15,
            left: 15,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  listOfPicture.removeAt(index);
                });
              },
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      colors: [Colors.white, Colors.red]),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                ),
                child: Icon(Icons.delete_outline_outlined),
              ),
            ))
      ],
    );
  }

  addImageWidget() {
    return GestureDetector(
      onTap: () async {
        List<File> listOfFiles = await selectImage(true);
        List<String> listOfUrl = [];
        listOfFiles.forEach((element) async {
          ImageKit.io(
            element.readAsBytesSync(),
            fileName: 'afilename',
            //  folder: "folder_name/nested_folder", (Optional)
            privateKey: privateKey, // (Keep Confidential)
            onUploadProgress: (progressValue) {
              if (true) {
                debugPrint(progressValue.toString());
              }
            },
          ).then((ImagekitResponse data) {
            /// Get your uploaded Image file link from [ImageKit.io]
            /// then save it anywhere you want. For Example- [Firebase, MongoDB] etc.

            debugPrint(
                data.url!); // (you will get all Response data from ImageKit)
            listOfUrl.add(data.url!);

            setState(() {
              listOfPicture.add(data.url!);
            });
            print(listOfPicture);
          });
        });
      },
      child: Container(
          margin: EdgeInsets.all(7),
          padding: EdgeInsets.all(7),
          height: 350,
          width: 250,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  colors: [Colors.white, Colors.blue, Colors.purple]),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
          child: Center(
            child: Text('click to add images of clothes for loundry',
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900)),
          )),
    );
  }
}

//add picture in horizontal scroll view

// counts of clothes

//total cost

// book buttoon
