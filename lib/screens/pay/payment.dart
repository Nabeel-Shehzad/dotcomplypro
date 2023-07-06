import 'dart:convert';

import 'package:dotcomplypro/utils/links.dart';
import 'package:dotcomplypro/utils/logged_in_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

import '../home.dart';

class Payment extends StatefulWidget {
  final bool flag;

  Payment({required this.flag, super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

enum SingingCharacter { One, Two, Three, None }

class _PaymentState extends State<Payment> {
  Map<String, dynamic>? paymentIntentData;
  SingingCharacter? _character = SingingCharacter.None;
  bool bocValue = false;
  bool expeditedValue = false;
  bool drugScreenValue = false;
  bool drugTestValue = false;
  bool driverValue = false;
  double total = 0;

  Future<void> checkIfPaymentDone(String? uid) async {
    final response = await http.post(Uri.parse(Links.get_payment), body: {
      'user_id': uid,
    });

    if (response.body != 'failure') {
      //split response body on ,
      List<String> paymentDetails = response.body.split(',');
      if (paymentDetails[0] == 'Yes') {
        setState(() {
          bocValue = true;
        });
      }
      if (paymentDetails[1] == 'Yes') {
        setState(() {
          expeditedValue = true;
        });
      }
      if (paymentDetails[3] == 'Yes') {
        setState(() {
          drugScreenValue = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfPaymentDone(User.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
        backgroundColor: Colors.teal[300],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: const EdgeInsets.all(10),
              child: Text('Select your service.',
                  textAlign: TextAlign.start, style: TextStyle(fontSize: 16)),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes the position of the shadow
                  ),
                ],
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text('BOC-3: ', style: TextStyle(fontSize: 16)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Checkbox(
                      value: bocValue,
                      onChanged: (bool? value) {
                        setState(() {
                          bocValue = value!;
                          if (bocValue == true) {
                            total = total + 39;
                          } else {
                            total = total - 39;
                            if (total < 0) {
                              total = 0;
                            }
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes the position of the shadow
                  ),
                ],
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Expedited Certificate of Authority: ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Checkbox(
                      value: expeditedValue,
                      onChanged: expeditedValue
                          ? null
                          : (bool? value) {
                              setState(() {
                                expeditedValue = value!;
                                if (expeditedValue == true) {
                                  total = total + 25;
                                } else {
                                  total = total - 25;
                                  if (total < 0) {
                                    total = 0;
                                  }
                                }
                              });
                            },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'UCR Choose # of Trucks: ',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Radio(
                                  value: SingingCharacter.None,
                                  groupValue: _character,
                                  onChanged: (SingingCharacter? value) {
                                    setState(() {
                                      updateTotal(value);
                                      _character = value;
                                    });
                                  },
                                ),
                                Text('None', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Radio(
                                  value: SingingCharacter.One,
                                  groupValue: _character,
                                  onChanged: (SingingCharacter? value) {
                                    setState(() {
                                      updateTotal(value);
                                      _character = value;
                                    });
                                  },
                                ),
                                Text('1-2 Trucks',
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Radio(
                                  value: SingingCharacter.Two,
                                  groupValue: _character,
                                  onChanged: (SingingCharacter? value) {
                                    setState(() {
                                      updateTotal(value);
                                      _character = value;
                                    });
                                  },
                                ),
                                Text('3-5 Trucks',
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Radio(
                                  value: SingingCharacter.Three,
                                  groupValue: _character,
                                  onChanged: (SingingCharacter? value) {
                                    setState(() {
                                      updateTotal(value);
                                      _character = value;
                                    });
                                  },
                                ),
                                Text('6-20 Trucks or more',
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes the position of the shadow
                  ),
                ],
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text('No Pre-Employment Drug Screen: ',
                        style: TextStyle(fontSize: 16)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Checkbox(
                      value: drugScreenValue,
                      onChanged: (bool? value) {
                        setState(() {
                          drugScreenValue = value!;
                          if (drugScreenValue == true) {
                            total = total + 149;
                          } else {
                            total = total - 149;
                            if (total < 0) {
                              total = 0;
                            }
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes the position of the shadow
                  ),
                ],
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text('Pre-Employment Drug Test: ',
                        style: TextStyle(fontSize: 16)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Checkbox(
                      value: drugTestValue,
                      onChanged: (bool? value) {
                        setState(() {
                          drugTestValue = value!;
                          if (drugTestValue == true) {
                            total = total + 224;
                          } else {
                            total = total - 224;
                            if (total < 0) {
                              total = 0;
                            }
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () async {
                    await makePayment('1');
                  },
                  child: Text('Make Payment of \$$total').text.size(18).make()),
            ),
            widget.flag
                ? SizedBox(height: 10)
                : Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      },
                      icon: Icon(Icons.arrow_forward),
                      label: Text("Start for free"),
                    ),
                  ).p(8),
          ]).p16(),
        ),
      ),
    );
  }

  void updateTotal(SingingCharacter? value) {
    if (value == SingingCharacter.None) {
      total = 0.0; // No charge for "None" option
    } else if (value == SingingCharacter.One) {
      if (_character == SingingCharacter.Two) {
        total -= 289.0; // Subtract previous charge for "Two" option
      } else if (_character == SingingCharacter.Three) {
        total -= 549.0; // Subtract previous charge for "Three" option
      }
      total += 149.0; // Add charge for "One" option
    } else if (value == SingingCharacter.Two) {
      if (_character == SingingCharacter.One) {
        total -= 149.0; // Subtract previous charge for "One" option
      } else if (_character == SingingCharacter.Three) {
        total -= 549.0; // Subtract previous charge for "Three" option
      }
      total += 289.0; // Add charge for "Two" option
    } else if (value == SingingCharacter.Three) {
      if (_character == SingingCharacter.One) {
        total -= 149.0; // Subtract previous charge for "One" option
      } else if (_character == SingingCharacter.Two) {
        total -= 289.0; // Subtract previous charge for "Two" option
      }
      total += 549.0; // Add charge for "Three" option
    }
  }

  Future<void> makePayment(String payment) async {
    try {
      paymentIntentData = await createPaymentIntent(payment, 'USD');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData!['client_secret'],
            // applePay: PaymentSheetApplePay(merchantCountryCode: 'US'),
            style: ThemeMode.dark,
            merchantDisplayName: 'Nabeel Shehzad',
          ))
          .then((value) => {});
      await displayPaymentSheet();
    } catch (e) {
      print("Stripe Exception: ${e.toString()}");
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance
          .presentPaymentSheet(
              //       parameters: PresentPaymentSheetParameters(
              // clientSecret: paymentIntentData!['client_secret'],
              // confirmPayment: true,
              // )
              )
          .then((newValue) async {
        await uploadPaymentInfo();

        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Payment Failed'),
                content: Text('Reason: $error'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Ok'),
                  ),
                ],
              );
            });
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Payment Failed'),
            content: Text('Reason: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculatePayment(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer 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',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      return jsonDecode(response.body);
    } catch (e) {
      print("Stripe Exception: ${e.toString()}");
    }
  }

  calculatePayment(String amount) {
    final price = int.parse(amount) * 100;
    return price.toString();
  }

  //upload payment info
  Future<void> uploadPaymentInfo() async {
    String userId = User.uid;
    String boc = bocValue ? 'Yes' : 'No';
    String eca = expeditedValue ? 'Yes' : 'No';
    String ucr = _character == SingingCharacter.None ? 'No' : 'Yes';
    String drug = 'No';
    if (drugTestValue || drugScreenValue) {
      drug = 'Yes';
    }
    var request = http.MultipartRequest('POST', Uri.parse(Links.payment));
    request.fields.addAll({
      'user_id': userId,
      'boc': boc,
      'eca': eca,
      'ucr': ucr,
      'drug': drug,
      'total': total.toInt().toString(),
    });

    var response = await request.send();
    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
        if (value == 'Data inserted successfully.') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      });
    } else {
      print(response.reasonPhrase);
    }
  }
}
