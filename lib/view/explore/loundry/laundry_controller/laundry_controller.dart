import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_dragon/view/utils/utils_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:imagekit_io/imagekit_io.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaundryController extends ChangeNotifier {
  List listOfPicture = [];

  int _expectedDay = 3;
  int _smallSizeValue = 0;
  int _mediumSizeValue = 0;
  int _largeSizeValue = 0;
  bool _isStarch = true;

  bool isUploading = false;

  int smallSizePrice = 150;
  int mediumSizePrice = 250;
  int largeSizePrice = 350;
  int urgentPrice = 0;
  int starchPrice = 0;

  int _totalPrice = 0;
  String _phoneNumber = ' ';
  String _address = ' ';

  get totalPrice => _totalPrice;

  get smallSizeValue => _smallSizeValue;
  get mediumSizeValue => _mediumSizeValue;
  get largeSizeValue => _largeSizeValue;
  get isStarch => _isStarch;
  get expectedDay => _expectedDay;

  setPrices() async {
    QuerySnapshot<Map<String, dynamic>> res = await FirebaseFirestore.instance
        .collection('app')
        .doc('pricing')
        .collection('price')
        .orderBy('timestamp', descending: true)
        .get();

    QueryDocumentSnapshot result = res.docs.first;

    smallSizePrice = int.parse(result['smallSizeLaundry']);
    mediumSizePrice = int.parse(result['meduimSizeLaundry']);
    largeSizePrice = int.parse(result['largeSizeLaundry']);
    urgentPrice = int.parse(result['urgentLaundry']);
    starchPrice = int.parse(result['starchLaundry']);
    debugPrint(smallSizePrice.toString());

    notifyListeners();
  }

  Future<void> setPhoneNumber(String num) async {
    _phoneNumber = num;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('phoneNumber', _phoneNumber);
    notifyListeners();
  }

  Future<String> getPhoneNumber() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('phoneNumber') ?? '';
  }

//address

  Future<void> setAdress(String adres) async {
    _address = adres;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('address', _address);
    notifyListeners();
  }

  Future<String> getAddress() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('address') ?? '';
  }

  Future<int> pricing() async {
    await setPrices();
    int price = smallSizePrice * _smallSizeValue +
        mediumSizePrice * _mediumSizeValue +
        largeSizePrice * _largeSizeValue;
    _totalPrice = price;
    notifyListeners();
    return _totalPrice;
  }

  Future<dynamic> onPaymentCompleted(BuildContext context) async {
    print(listOfPicture);
    isUploading = true;
    String ancestorUid = Uuid().v1();

    String caption =
        'counts are S $_smallSizeValue , M $_mediumSizeValue, L $_largeSizeValue and total cost is $pricing';
    if (true == true) {
      debugPrint('upoladingg');
      listOfPicture.forEach((element) async {
        debugPrint('upoladingg');

        String orderId = Uuid().v1();
        var data = {
          'orderId': orderId,
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'status': 'requested', //requested , completted, confirmed
          'phone number': _phoneNumber,
          'address': _address,
          'pictures': listOfPicture,
          'title': 'order successfully booked',
          'description':
              'your order ($orderId) have been recieved and being processed by an handler, we will keep in touch with you ($_phoneNumber)',
          'details':
              'x:$_smallSizeValue  m:$_mediumSizeValue  l:$_largeSizeValue   urgent:$_expectedDay   starched:$_isStarch   price:$_totalPrice',
          'timestamp': Timestamp.now()
        };

        await FirebaseFirestore.instance
            .collection('loundry')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('request')
            .doc(orderId)
            .set(data)
            .then((value) {
          debugPrint('doneeee');

          debugPrint('doneeee');
          debugPrint('doneeee');
          debugPrint('doneeee');
        });
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

// redirection url back to flutter app how to
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
            amount: _totalPrice.toString(),
            customer: customer,
            paymentOptions: "card, payattitude, barter, bank transfer, ussd",
            customization: Customization(title: "Test Payment"),
            isTestMode: true);

        final ChargeResponse response = await flutterwave.charge();
        if (response.success == true) {
          await onPaymentCompleted(context);
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
    _isStarch = value;
    notifyListeners();
  }

  setExpectedDayValue(int day) {
    _expectedDay = day;

    notifyListeners();
  }

  setSmallSizeValue(int value) {
    _smallSizeValue = value;
    notifyListeners();
  }

  setMediumSizeValue(value) {
    _mediumSizeValue = value;
    notifyListeners();
  }

  setLargeSizeValue(int value) {
    _largeSizeValue = value;

    notifyListeners();
  }
}
