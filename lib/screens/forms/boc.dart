import 'dart:convert';

import 'package:dotcomplypro/utils/rates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server/gmail.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/smtp_server.dart';
import '../../utils/custom_dialog.dart';
import '../../utils/links.dart';
import '../../utils/logged_in_user.dart';

class BOC extends StatefulWidget {
  const BOC({Key? key}) : super(key: key);

  @override
  State<BOC> createState() => _BOCState();
}

class _BOCState extends State<BOC> {
  Map<String, dynamic>? paymentIntentData;
  final _formKey = GlobalKey<FormState>();
  ProgressDialog? _progressDialog;

  TextEditingController dotNumber = TextEditingController();
  TextEditingController legalName = TextEditingController();
  TextEditingController dba = TextEditingController();
  TextEditingController state = TextEditingController();

  String payment =
      User.isBOCPaid ? 'Purchase Now - \$0.00' : 'Purchase Now - \$${Rates.rates['BOC3']}';

  final gmailStmp = gmail(dotenv.env["GMAIL_EMAIL"]!, dotenv.env["GMAIL_PASSWORD"]!);
  sendMailFromGmail()async{
    final message = mailer.Message()
      ..from = mailer.Address(dotenv.env["GMAIL_EMAIL"]!, 'DOT ComplyPro')
      ..recipients.add('newsales@dot-comply.com')
      ..subject = 'BOC-3 Filling :: 😀 :: ${DateTime.now()}'
      ..text = 'The BOC-3 Product is purchased by User with ID: ${User.uid}';

    try {
      final sendReport = await mailer.send(message, gmailStmp);
      print('Message sent: ' + sendReport.toString());
    } on mailer.MailerException catch (e) {
      print('Message not sent. $e');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  Future<void> _uploadData(BuildContext context) async {
    _progressDialog = ProgressDialog(context: context);
    _progressDialog!.show(
      max: 100,
      msg: 'Please wait...',
      progressType: ProgressType.normal,
    );

    String userId = User.uid;
    String dotNumber = this.dotNumber.text;
    String legalName = this.legalName.text;
    String dba = this.dba.text;
    String state = this.state.text;

    var request = http.MultipartRequest('POST', Uri.parse(Links.boc));
    request.fields['user_id'] = userId;
    request.fields['dot_number'] = dotNumber;
    request.fields['legal_name'] = legalName;
    request.fields['dba'] = dba;
    request.fields['state'] = state;

    var response = await request.send();

    String responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      //clear fields
      this.dotNumber.clear();
      this.legalName.clear();
      this.dba.clear();
      this.state.clear();

      _progressDialog!.close();
      Future.microtask(() {
        showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(
            title: 'Success',
            content:
                'Your BOC-3 has been submitted. Our team is working on your behalf and will update you when your filing is complete. Check back soon to access your BOC-3.',
          ),
        );
      });
    } else {
      _progressDialog!.close();
      Future.microtask(() {
        showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(
            title: 'Error',
            content: 'Something went wrong. Please try again.',
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              'BOC-3 Filling',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Interstate carriers must file separate electronic BOC-3 forms for each authority to designate agents to receive legal documents if sued outside their home state, and DOT operating authority is only granted after filing insurance. All sales are final.',
              style: TextStyle(fontSize: 16),
            ),
            Container(
              height: 15,
            ),
            SizedBox(
              width: double.maxFinite,
              child: TextFormField(
                controller: dotNumber,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'DOT Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter DOT Number';
                  }
                  return null;
                },
              ),
            ),
            Container(
              height: 15,
            ),
            SizedBox(
              width: double.maxFinite,
              child: TextFormField(
                controller: legalName,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Legal Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Legal Name';
                  }
                  return null;
                },
              ),
            ),
            Container(
              height: 15,
            ),
            SizedBox(
              width: double.maxFinite,
              child: TextFormField(
                controller: dba,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'DBA',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Container(
              height: 15,
            ),
            SizedBox(
              width: double.maxFinite,
              child: TextFormField(
                controller: state,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter State';
                  }
                  return null;
                },
              ),
            ),
            Container(
              height: 15,
            ),
            SizedBox(
              height: 50,
              width: double.maxFinite,
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (User.isBOCPaid) {
                        _uploadData(context);
                      } else {
                        makePayment(Rates.rates['BOC3'].toString());
                      }
                    }
                  },
                  child: Text(payment).text.size(20).make()),
            ),
            Container(
              height: 15,
            ),
          ],
        ).p8(),
      ),
    );
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
        await _uploadData(context);
        sendMailFromGmail();

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
      //add items in body that user is buying
      String items = 'BOC-3 Filling';
      Map<String, dynamic> body = {
        'amount': calculatePayment(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
        'description': items,
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
}
