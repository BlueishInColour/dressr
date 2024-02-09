import 'package:flutterwave_standard/flutterwave.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class FlutterPay extends StatefulWidget {
  const FlutterPay({super.key});

  @override
  State<FlutterPay> createState() => FlutterPayState();
}

class FlutterPayState extends State<FlutterPay> {
  final amountController = TextEditingController();
  final narrationController = TextEditingController();

//
  final pinController = TextEditingController();
  //

  String selectedCurrency = "";

  bool confirmThePayment = false;

  bool isTestMode = true;
  @override
  Widget build(BuildContext context) {
    Future<void> showLoading(String message) {
      return showDialog(
        context: this.context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
              width: double.infinity,
              height: 50,
              child: Text(message),
            ),
          );
        },
      );
    }

    String getPublicKey() {
      return "";
    }

    confirmFluttewavePayment() async {
      if (pinController.text == "1234") {
        final Customer customer = Customer(email: "customer@customer.com");

        final Flutterwave flutterwave = Flutterwave(
            context: context,
            publicKey: getPublicKey(),
            currency: selectedCurrency,
            redirectUrl: 'https://facebook.com',
            txRef: Uuid().v1(),
            amount: amountController.text.toString().trim(),
            customer: customer,
            paymentOptions: "card, payattitude, barter, bank transfer, ussd",
            customization: Customization(title: "Test Payment"),
            isTestMode: isTestMode);
        final ChargeResponse response = await flutterwave.charge();
        if (response.success != null) {
          showLoading(response.toString());
          print("${response.toJson()}");
        } else {
          showLoading("No Response!");
        }
      } else {
        setState(() {
          confirmThePayment = false;
        });
      }
    }

    Widget addMoneyOptions(context) {
      return Container(
        color: Colors.black,
        height: 100,
        child: ListView(
          children: [
            //virtual bank

            //usssd

            //
          ],
        ),
      );
    }

    Widget confirmPayment(context) {
      return Container(
        child: Row(
          children: [
            SizedBox(
                height: 50,
                width: 200,
                child: Expanded(
                    child: TextField(
                  controller: pinController,
                  decoration: InputDecoration(
                      hintText: 'enter pin',
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                ))),
            SizedBox(width: 15),
            Expanded(
              child: GestureDetector(
                onTap: confirmFluttewavePayment,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 50,
                  decoration: BoxDecoration(
                    // color: Colors.black,
                    gradient: LinearGradient(
                        colors: [Colors.blue, Colors.purple, Colors.red]),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      'confirm pay',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: Container(
            child: ListView(
              children: [
                Text(
                  '10x faster & safer',
                  style: GoogleFonts.montserrat(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 15),
                //account balance and addmoney
                Container(
                  child: Row(
                    children: [
                      //balance
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.black)),
                          child: Center(
                              child: Row(
                            children: [
                              Text(
                                'WALLET',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                              ),
                              SizedBox(width: 20),
                              Text(
                                '#' '250,000',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800),
                              )
                            ],
                          )),
                        ),
                      ),
                      //addmoney
                      SizedBox(width: 15),

                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => addMoneyOptions(context));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.black)),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                    height: 50,
                    width: 500,
                    child: TextField(
                      controller: amountController,
                      decoration: InputDecoration(
                          hintText: 'enter amount',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    )),
                SizedBox(height: 15),

                //pay buttton
                confirmThePayment
                    ? confirmPayment(context)
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            confirmThePayment = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 50,
                          decoration: BoxDecoration(
                            // color: Colors.black,
                            gradient: LinearGradient(colors: [
                              Colors.blue,
                              Colors.purple,
                              Colors.red
                            ]),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'pay',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
