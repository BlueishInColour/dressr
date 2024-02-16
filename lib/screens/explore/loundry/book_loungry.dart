import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressr/screens/profile/item.dart';
import 'package:dressr/screens/explore/loundry/loundry_item.dart';
import 'package:dressr/utils/loading.dart';
import 'package:dressr/utils/utils_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imagekit_io/imagekit_io.dart';
import 'package:uuid/uuid.dart';
import 'package:flutterwave_web_client/flutterwave_web_client.dart';

class BookLoungry extends StatefulWidget {
  const BookLoungry({super.key});

  @override
  State<BookLoungry> createState() => BookLoungryState();
}

class BookLoungryState extends State<BookLoungry> {
  List listOfPicture = [];
  final listOfInt = List<int>.generate(100, (index) => index, growable: true);
  bool isItUrgent = false;

  int smallSizeValue = 0;
  int mediumSizeValue = 0;
  int LargeSizeValue = 0;

  int uPX = 250;
  int uPM = 400;
  int uPL = 600;

  int notUPX = 150;
  int notUPM = 250;
  int notUPL = 500;

  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    int notUrgentPrice = (notUPX * smallSizeValue +
        notUPM * mediumSizeValue +
        notUPL * LargeSizeValue);
    int urgentPrice =
        (uPX * smallSizeValue + uPM * mediumSizeValue + uPL * LargeSizeValue);

    int pricing() {
      if (isItUrgent) {
        return urgentPrice;
      } else {
        return notUrgentPrice;
      }
    }

    onPaymentCompleted() async {
      print(listOfPicture);
      setState(() {
        isUploading = true;
      });
      String ancestorUid = Uuid().v1();

      String caption =
          'counts are S $smallSizeValue , M $mediumSizeValue, L $LargeSizeValue and total cost is $pricing';
      if (listOfPicture.isNotEmpty) {
        debugPrint('upoladingg');
        listOfPicture.forEach((element) async {
          debugPrint('upoladingg');

          String postUid = Uuid().v1();
          var data = {
            //id
            'postId': postUid,
            // 'headPostId': widget.headPostId,
            'ancestorId': ancestorUid,

            //content
            'caption': caption,
            'picture': element,
            'audio': '',
            'video': '',
            'tags': [],

            //creator
            'creatorUid': FirebaseAuth.instance.currentUser!.uid,

            //metadata

            'timestamp': Timestamp.now(), 'status': '',
          };

          await FirebaseFirestore.instance
              .collection('loundry')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('active')
              .doc(postUid)
              .set(data);
        });

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.black,
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(
                  width: 15,
                ),
                Text(' you have not added any image yet'),
              ],
            )));
      }
    }

    countClothes() {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        //is urgent?
        Container(
            height: 40,
            padding: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.purple.shade900,
            ),
            child: Center(
                child: Row(
              children: [
                Icon(Icons.speed, color: Colors.white),
                Checkbox(
                    // fillColor: MaterialStatePropertyAll(Colors.purple.shade100),
                    value: isItUrgent,
                    // activeColor: Colors.white,
                    checkColor: Colors.green,
                    shape: CircleBorder(side: BorderSide(color: Colors.white)),
                    onChanged: (v) {
                      setState(() {
                        isItUrgent = !isItUrgent;
                      });
                    }),
              ],
            ))),

        Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.purple.shade900,
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.purple.shade900,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5))),
                width: 20,
                child: Center(
                    child: Text(
                  'X',
                  style: TextStyle(color: Colors.white),
                )),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  color: Colors.purple.shade100,
                ),
                child: DropdownButton(
                    elevation: 0,
                    padding: EdgeInsets.only(left: 3),
                    icon: Icon(Icons.keyboard_arrow_down_outlined),
                    underline: SizedBox(),
                    value: smallSizeValue,
                    onChanged: <int>(newValue) {
                      setState(() {
                        smallSizeValue = newValue;
                      });
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
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.purple.shade900,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5))),
                width: 20,
                child: Center(
                    child: Text(
                  'M',
                  style: TextStyle(color: Colors.white),
                )),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  color: Colors.purple.shade100,
                ),
                child: DropdownButton(
                    elevation: 0,
                    padding: EdgeInsets.only(left: 3),
                    icon: Icon(Icons.keyboard_arrow_down_outlined),
                    underline: SizedBox(),
                    value: mediumSizeValue,
                    onChanged: <int>(newValue) {
                      setState(() {
                        mediumSizeValue = newValue;
                      });
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
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.purple.shade900,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5))),
                width: 20,
                child: Center(
                    child: Text(
                  'L',
                  style: TextStyle(color: Colors.white),
                )),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  color: Colors.purple.shade100,
                ),
                child: DropdownButton(
                    elevation: 0,
                    underline: SizedBox(),
                    value: LargeSizeValue,
                    padding: EdgeInsets.only(left: 3),
                    icon: Icon(Icons.keyboard_arrow_down_outlined),
                    onChanged: <int>(newValue) {
                      setState(() {
                        LargeSizeValue = newValue;
                      });
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
    }

    return Container(
      height: MediaQuery.of(context).size.height - 80,
      color: Colors.white70,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.cancel)),
                Expanded(child: SizedBox()),
                TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          showDragHandle: true,
                          builder: (context) {
                            return LoundryHistory();
                          });
                    },
                    child: Text('history'))
              ],
            ),
            //add image
            listOfPicture.isEmpty
                ? Row(
                    children: [addImageWidget()],
                  )
                : SizedBox(
                    height: 350,
                    child: ListView.builder(
                        itemCount: listOfPicture.length + 1,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: ((context, index) {
                          if (index == listOfPicture.length) {
                            return addImageWidget();
                          }
                          return imageWidget(
                              url: listOfPicture[index], index: index);
                        })),
                  ), //is it urgent

            Row(
              children: [
                Text(
                  'speed and counts',
                  style: TextStyle(
                      fontSize: 10,
                      color: const Color.fromARGB(255, 105, 0, 124),
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'note: shirt and trouser of same fabric is counted as two pieces',
                  style: TextStyle(
                      fontSize: 8,
                      color: Color.fromARGB(255, 230, 127, 248),
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),

            SizedBox(height: 10),

            countClothes(),
            SizedBox(height: 10),

            Row(
              children: [
                Text(
                  'a dispatch rider will be on his way once checkout is completed',
                  style: TextStyle(
                      fontSize: 8,
                      color: Color.fromARGB(255, 230, 127, 248),
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                //total cost
                Expanded(
                    child: Container(
                  // height: 70,

                  // padding: EdgeInsets.all(10),

                  child: Row(
                    children: [
                      Text('#',
                          style: GoogleFonts.montserratAlternates(
                              color: Color.fromARGB(255, 1, 52, 93),
                              fontSize: 30,
                              fontWeight: FontWeight.w900)),
                      Text(pricing().toString(),
                          style: GoogleFonts.montserratAlternates(
                              color: Color.fromARGB(255, 1, 52, 93),
                              fontSize: 30,
                              fontWeight: FontWeight.w900)),
                    ],
                  ),
                )),
                //button
                GestureDetector(
                  onTap: () async {
                    if (kIsWeb) {
                      callToInstall(context);
                    } else {
                      if (pricing() == 0) {
                      } else {
                        final Customer customer = Customer(
                            email: FirebaseAuth.instance.currentUser!.email!);

                        final Flutterwave flutterwave = Flutterwave(
                            context: context,
                            publicKey:
                                'FLWPUBK_TEST-ef4d818fa96ee72db01e180edd283079-X',
                            currency: 'NGN',
                            redirectUrl: 'https://dress-mate.web.app',
                            txRef: Uuid().v1(),
                            amount: pricing().toString(),
                            customer: customer,
                            paymentOptions:
                                "card, payattitude, barter, bank transfer, ussd",
                            customization: Customization(title: "Test Payment"),
                            isTestMode: true);

                        final ChargeResponse response =
                            await flutterwave.charge();
                        if (response.success != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(response.toString()),
                          ));
                          // showLoading(response.toString());
                          print("${response.toJson()}");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('no response'),
                          ));
                        }
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(7),
                    margin: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        gradient:
                            LinearGradient(begin: Alignment.topLeft, colors: [
                          // Colors.white,
                          Colors.blue,
                          Colors.purple,
                        ]),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      ' checkout ',
                      style: GoogleFonts.montserrat(
                          color: Colors.white60,
                          fontSize: 10,
                          fontWeight: FontWeight.w900),
                    )),
                  ),
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
            child: Text('click to add images of clothes for loundry **MUST**',
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

// import 'package:flutter/material.dart';

class LoundryHistory extends StatefulWidget {
  const LoundryHistory({super.key});

  @override
  State<LoundryHistory> createState() => LoundryHistoryState();
}

class LoundryHistoryState extends State<LoundryHistory> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height - 100,
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('history',
                  style:
                      TextStyle(fontSize: 12, color: Colors.purple.shade900)),
            ),
            body: FirestorePagination(
                // isLive: true,
                limit: 20,
                bottomLoader: Loading(),
                viewType: ViewType.grid,
                initialLoader: Loading(),
                onEmpty: Text('thats all for now'),
                query: FirebaseFirestore.instance
                    .collection('loundry')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('active')
                    .orderBy('timestamp', descending: true),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 0.7),
                isLive: true,
                itemBuilder: (context, item, snapshot) {
                  // if we have data, get all dic
                  // if (snapshot == 0) {
                  //   return Orderr();
                  // }

                  return Item(
                    caption: item['caption'],
                    picture: item['picture'],
                    ancestorId: item['ancestorId'],
                    postId: item['postId'],
                    creatorUid: item['creatorUid'],
                  );
                })));
  }
}
