import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressr/view/utils/utils_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:imagekit_io/imagekit_io.dart';
import 'package:uuid/uuid.dart';

class LaundryController extends ChangeNotifier {
  List listOfPicture = [];

  int expectedDay = 3;
  int smallSizeValue = 0;
  int mediumSizeValue = 0;
  int largeSizeValue = 0;
  bool isItUrgent = false;
  bool isStarch = true;

  bool isUploading = false;

  int smallSizePrice = 0;
  int mediumSizePrice = 0;
  int largeSizePrice = 0;
  int urgentPrice = 0;
  int starchPrice = 0;

  int totalPrice = 0;
  String phoneNumber = ' ';

  setPrices(QueryDocumentSnapshot result) {
    smallSizePrice = int.parse(result['smallSizeLaundry']);
    mediumSizePrice = int.parse(result['meduimSizeLaundry']);
    largeSizePrice = int.parse(result['largeSizeLaundry']);
    urgentPrice = int.parse(result['urgentLaundry']);
    starchPrice = int.parse(result['starchLaundry']);
    debugPrint(smallSizePrice.toString());
    debugPrint(mediumSizePrice.toString());
    debugPrint(largeSizePrice.toString());
    debugPrint(result['urgentLaundry']);
    notifyListeners();
  }

  setPhoneNumber(String num) {
    phoneNumber = num;
    notifyListeners();
  }

  pricing() {
    int notUrgentPrice = (smallSizePrice * smallSizeValue +
        mediumSizePrice * mediumSizeValue +
        largeSizePrice * largeSizeValue);
    int urgentPric = ((smallSizePrice + urgentPrice) * smallSizeValue +
            (mediumSizePrice + urgentPrice) * mediumSizeValue +
            (largeSizePrice + urgentPrice) * largeSizeValue)
        .toInt();

    if (isItUrgent) {
      totalPrice = urgentPric;

      notifyListeners();
    } else {
      totalPrice = notUrgentPrice;

      notifyListeners();
    }
  }

  Future<dynamic> onPaymentCompleted(BuildContext context) async {
    print(listOfPicture);
    isUploading = true;
    String ancestorUid = Uuid().v1();

    String caption =
        'counts are S $smallSizeValue , M $mediumSizeValue, L $largeSizeValue and total cost is $pricing';
    if (listOfPicture.isNotEmpty) {
      debugPrint('upoladingg');
      listOfPicture.forEach((element) async {
        debugPrint('upoladingg');

        String orderId = Uuid().v1();
        var data = {
          'orderId': orderId,
          'phone number': '',
          'title': 'order successfully booked',
          'description':
              'your order ($orderId) have been recieved and being processed by an handler, we will keep in touch with you ($phoneNumber)',
          'details':
              'x:$smallSizeValue  m:$mediumSizeValue  l:$largeSizeValue   urgent:$isItUrgent   starched:$isStarch   price:$totalPrice',
          'timestamp': Timestamp.now()
        };

        await FirebaseFirestore.instance
            .collection('loundry')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('active')
            .doc(orderId)
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

    notifyListeners();
  }

  Future<dynamic> selectImagesFromPhone() async {
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

        debugPrint(data.url!); // (you will get all Response data from ImageKit)
        listOfUrl.add(data.url!);

        listOfPicture.add(data.url!);
        print(listOfPicture);

        notifyListeners();
      });

      notifyListeners();
    });

    notifyListeners();
  }

  removeAt(int index) {
    listOfPicture.removeAt(index);
    notifyListeners();
  }

  Future<dynamic> checkout(context) async {
    if (kIsWeb) {
      callToInstall(context);
    } else {
      if (pricing() == 0) {
      } else {
        final Customer customer =
            Customer(email: FirebaseAuth.instance.currentUser!.email!);

        final Flutterwave flutterwave = Flutterwave(
            context: context,
            publicKey: 'FLWPUBK_TEST-ef4d818fa96ee72db01e180edd283079-X',
            currency: 'NGN',
            redirectUrl: 'https://dress-mate.web.app',
            txRef: Uuid().v1(),
            amount: pricing().toString(),
            customer: customer,
            paymentOptions: "card, payattitude, barter, bank transfer, ussd",
            customization: Customization(title: "Test Payment"),
            isTestMode: true);

        final ChargeResponse response = await flutterwave.charge();
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

    notifyListeners();
  }

  setStarchValue(bool value) {
    isStarch = value;
    notifyListeners();
  }

  setExpectedDayValue(int day) {
    expectedDay = day;

    notifyListeners();
  }

  setSmallSizeValue(int value) {
    smallSizeValue = value;
    notifyListeners();
  }

  setMediumSizeValue(value) {
    mediumSizeValue = value;
    notifyListeners();
  }

  setlargeSizeValue(int value) {
    largeSizeValue = value;

    notifyListeners();
  }
}
