import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SetPricing extends StatefulWidget {
  const SetPricing({super.key});

  @override
  State<SetPricing> createState() => SetPricingState();
}

class SetPricingState extends State<SetPricing> {
  final smallSizeLaundryController = TextEditingController();
  final mediumSizeLaundryController = TextEditingController();
  final largeSizeLaundryController = TextEditingController();
  final urgentLaundryController = TextEditingController();

  final starchLaundryController = TextEditingController();

  getLatestPrices() async {
    QuerySnapshot<Map<String, dynamic>> res = await FirebaseFirestore.instance
        .collection('app')
        .doc('pricing')
        .collection('price')
        .orderBy('timestamp', descending: true)
        .get();

    QueryDocumentSnapshot result = res.docs.first;

    setState(() {
      smallSizeLaundryController.text = result['smallSizeLaundry'];
      mediumSizeLaundryController.text = result['meduimSizeLaundry'];
      largeSizeLaundryController.text = result['largeSizeLaundry'];
      urgentLaundryController.text = result['urgentLaundry'];
      starchLaundryController.text = result['starchLaundry'];
    });
  }

  uploadPrices() async {
    Map<String, dynamic> data = {
      'smallSizeLaundry': smallSizeLaundryController.text,
      'meduimSizeLaundry': mediumSizeLaundryController.text,
      'largeSizeLaundry': largeSizeLaundryController.text,
      'urgentLaundry': urgentLaundryController.text,
      'starchLaundry': starchLaundryController.text,
      'timestamp': Timestamp.now(),
    };
    await FirebaseFirestore.instance
        .collection('app')
        .doc('pricing')
        .collection('price')
        .add(data)
        .then((value) => debugPrint('doneee'));
  }

  @override
  initState() {
    super.initState();

    getLatestPrices();
  }

  @override
  Widget build(BuildContext context) {
    Widget textField(
        {required TextEditingController controller, String hintText = ''}) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          keyboardType: TextInputType.number,
          controller: controller,
          decoration: InputDecoration(hintText: hintText, labelText: hintText),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(actions: [
          OutlinedButton(
              onPressed: () async {
                await uploadPrices();
              },
              child: Text('update pricing')),
          SizedBox(width: 10)
        ]),
        body: ListView(
          children: [
            textField(
                controller: smallSizeLaundryController,
                hintText: 'small laundry size'),
            textField(
                controller: mediumSizeLaundryController,
                hintText: 'medium laundry size'),
            textField(
                controller: largeSizeLaundryController,
                hintText: 'large laundry size'),
            textField(
                controller: urgentLaundryController,
                hintText: 'urgent additionaly fee per cloth'),
            textField(
                controller: starchLaundryController,
                hintText: 'starch additional fee per cloth')
          ],
        ));
  }
}
