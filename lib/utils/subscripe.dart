import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

const String defaultGooglePay = '''{
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
      "merchantName": "Example Merchant Name"
    },
    "transactionInfo": {
      "countryCode": "US",
      "currencyCode": "USD"
    }
  }
}''';

class Subscripe extends StatefulWidget {
  const Subscripe({super.key});

  @override
  State<Subscripe> createState() => SubscripeState();
}

const _paymentItems = [
  PaymentItem(
    label: 'blue',
    amount: '0.99',
    status: PaymentItemStatus.final_price,
  ),
  PaymentItem(
    label: 'purple',
    amount: '4.99',
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

  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  void onApplePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  Pay _payClient = Pay({
    PayProvider.google_pay:
        PaymentConfiguration.fromJsonString(defaultGooglePay)
  });
// On the Button Pressed
  void onGooglePayPressed() async {
    final result = await _payClient.showPaymentSelector(
      PayProvider.google_pay,
      _paymentItems,
    );
  }

  late final Future<PaymentConfiguration> _googlePayConfigFuture;

  @override
  void initState() {
    super.initState();
    _googlePayConfigFuture = PaymentConfiguration.fromAsset(
        'assets/sample_payment_configuration.json');
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
              bottom: 5,
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
      "merchantName": "Example Merchant Name"
    },
    "transactionInfo": {"countryCode": "US", "currencyCode": "USD"}
  }
}''';
