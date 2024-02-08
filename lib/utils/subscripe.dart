import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pay/pay.dart';

class Subscripe extends StatefulWidget {
  const Subscripe({super.key});

  @override
  State<Subscripe> createState() => SubscripeState();
}

const _paymentItems = [
  PaymentItem(
    label: 'dressmate blue',
    amount: '1000',
    status: PaymentItemStatus.final_price,
  ),
];

class SubscripeState extends State<Subscripe> {
  Widget button(context, String text, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3),
      height: 40,
      width: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void onGooglePayResult(paymentResult) async {
    debugPrint(paymentResult.toString());
    await FirebaseFirestore.instance
        .collection('subscription')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('current')
        .doc('current')
        .set({
      'subscriptionStart': Timestamp.now(),
      'subscription': 'blue',
      'subscriptionEnd':
          Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(259200000))
    });
  }

  void onApplePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  Widget referButton(context) {
    return Container(
      height: 65,
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      child: Column(children: [
        Text('refer & win sub',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w800, fontSize: 18)),
        Text('use your @username on referee signup',
            style: TextStyle(fontSize: 10))
      ]),
    );
  }

  late final Future<PaymentConfiguration> _googlePayConfigFuture;
  TextStyle bigStyle = GoogleFonts.montserrat(
      color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900);
  TextStyle smallStyle = GoogleFonts.montserrat(
      color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            //picture
            CachedNetworkImage(
              imageUrl: '',
              errorWidget: (context, url, error) {
                return Container(
                  height: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient:
                        RadialGradient(colors: [Colors.purple, Colors.blue]),
                  ),
                );
              },
              placeholder: ((context, url) {
                return Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.purple[500],
                  ),
                );
              }),
            ),
            Positioned(
                child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('access more features on dressmate', style: bigStyle),
                  Text('for #1000/month ', style: bigStyle),
                  Text('- enabled monerization', style: smallStyle),
                  Text('- more reactions', style: smallStyle),
                  Text('- enabled shares', style: smallStyle),
                  Text('- enabled downloads', style: smallStyle),
                  Text('- and many more ...', style: smallStyle)
                ],
              ),
            )),
            Positioned(
              bottom: 100,
              right: 5,
              child: GooglePayButton(
                // paymentConfigurationAsset: 'assets/google_pay_config.json',
                paymentConfiguration: PaymentConfiguration.fromJsonString(json),
                paymentItems: _paymentItems,
                type: GooglePayButtonType.pay,
                margin: const EdgeInsets.only(top: 15.0),
                onPaymentResult: onGooglePayResult,
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            Positioned(
                bottom: 76,
                right: 40,
                child: Text('or better still',
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w800, fontSize: 12))),
            Positioned(bottom: 5, right: 5, child: referButton(context)),
          ],
        ),
      ),
    );
  }
}

// class GooglePayButton {}

// balux@gmail.com

String json = '''{
  "provider": "google_pay",
  "data": {
    "environment": "TEST",
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "example",
            "gatewayMerchantId": "gatewayMerchantId"
          }
        },
        "parameters": {
          "allowedCardNetworks": ["VISA", "MASTERCARD"],
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "billingAddressRequired": true,
          "billingAddressParameters": {
            "format": "FULL",
            "phoneNumberRequired": true
          }
        }
      }
    ],
    "merchantInfo": {
      "merchantId": "01234567890123456789",
      "merchantName": "dressmate"
    },
    "transactionInfo": {"countryCode": "NG", "currencyCode": "NGN"}
  }
}''';
