import 'dart:convert';
import 'dart:io';
import 'package:dotcomplypro/screens/card/success.dart';
import 'package:dotcomplypro/utils/links.dart';
import 'package:dotcomplypro/utils/rates.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mime/mime.dart';
import '../../utils/custom_dialog.dart';
import '../../utils/logged_in_user.dart';
import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server/gmail.dart';
class Drug extends StatefulWidget {
  const Drug({Key? key}) : super(key: key);

  @override
  State<Drug> createState() => _DrugState();
}

class _DrugState extends State<Drug> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? paymentIntentData;
  List<File> _files = List.generate(6, (_) => File(''));
  ProgressDialog? _progressDialog;
  bool drugScreenValue = false;
  bool drugTestValue = false;
  int price = 0;

  List<TextEditingController> _controllers = [];

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

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (_) => TextEditingController());
  }

  // Function to handle file selection for a specific field
  void selectFile(int fieldIndex) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _files[fieldIndex] = File(result.files.first.path!);
        _controllers[fieldIndex].text = result.files.first.path!;
      });
    }
  }

  Future<void> _uploadFile(BuildContext context) async {
    _progressDialog = ProgressDialog(context: context);
    _progressDialog!.show(
      max: 100,
      msg: 'Please wait...',
      progressType: ProgressType.normal,
    );

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Links.drug}?userId=${User.uid}'),
    );

    for (var i = 0; i < _files.length; i++) {
      var file = _files[i];
      String mimeType = lookupMimeType(file.path)!;
      var fileStream = http.ByteStream(Stream.castFrom(file.openRead()));
      var length = await file.length();

      var multipartFile = http.MultipartFile(
        'files[]',
        fileStream,
        length,
        filename: file.path.split('/').last,
        contentType: MediaType.parse(mimeType),
      );

      request.files.add(multipartFile);
    }

    request.fields['test'] = drugTestValue.toString();
    request.fields['screen'] = drugScreenValue.toString();

    var response = await request.send();

    try {
      if (response.statusCode == 200) {
        _progressDialog!.close();
        setState(() {
          _files = List.generate(6, (_) => File(''));
          _controllers = List.generate(6, (_) => TextEditingController());
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Success(),
          ),
        );
      } else {
        _progressDialog!.close();
        Future.microtask(() {
          showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog(
              title: 'Error',
              content: 'Error uploading data. Please try again later.',
            ),
          );
        });
      }
    } catch (e) {
      print('Error decoding JSON: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Drug & Alcohol Program',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            Container(
              height: 15,
            ),
            SizedBox(
              width: double.maxFinite,
              child: TextFormField(
                readOnly: true,
                controller: _controllers[0],
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: "Select Letter of Participation",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Choose Record';
                  }
                  return null;
                },
                onTap: () {
                  selectFile(0);
                },
              ),
            ),
            Container(
              height: 15,
            ),
            SizedBox(
              width: double.maxFinite,
              child: TextFormField(
                readOnly: true,
                controller: _controllers[1],
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: "Select Company Policy",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Choose Record';
                  }
                  return null;
                },
                onTap: () {
                  selectFile(1);
                },
              ),
            ),
            Container(
              height: 15,
            ),
            SizedBox(
              width: double.maxFinite,
              child: TextFormField(
                readOnly: true,
                controller: _controllers[2],
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: "Select Program Stats",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Choose Record';
                  }
                  return null;
                },
                onTap: () {
                  selectFile(2);
                },
              ),
            ),
            Container(
              height: 15,
            ),
            SizedBox(
              width: double.maxFinite,
              child: TextFormField(
                readOnly: true,
                controller: _controllers[3],
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: "Select Pre-Employment Drug Screen",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Choose Record';
                  }
                  return null;
                },
                onTap: () {
                  selectFile(3);
                },
              ),
            ),
            Container(
              height: 15,
            ),
            SizedBox(
              width: double.maxFinite,
              child: TextFormField(
                readOnly: true,
                controller: _controllers[4],
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: "Select Random Drug Screen",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Choose Record';
                  }
                  return null;
                },
                onTap: () {
                  selectFile(4);
                },
              ),
            ),
            Container(
              height: 15,
            ),
            SizedBox(
              width: double.maxFinite,
              child: TextFormField(
                readOnly: true,
                controller: _controllers[5],
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: "Select Random Alcohol Screen",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Choose Record';
                  }
                  return null;
                },
                onTap: () {
                  selectFile(5);
                },
              ),
            ),
            Container(
              height: 15,
            ),
            SizedBox(
              width: double.maxFinite,
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
                            price = price + Rates.rates['Pre-Employment Drug']!;
                          } else {
                            price = price - Rates.rates['Pre-Employment Drug']!;
                            if (price < 0) {
                              price = 0;
                            }
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ).px(8),
            Container(
              height: 15,
            ),
            SizedBox(
              width: double.maxFinite,
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
                            price = price + Rates.rates['No Pre-Employment Drug']!;
                          } else {
                            price = price - Rates.rates['No Pre-Employment Drug']!;
                            if (price < 0) {
                              price = 0;
                            }
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ).px(8),
            Container(
              height: 15,
            ),
            SizedBox(
              height: 50,
              width: double.maxFinite,
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (price > 0) {
                        makePayment(price.toString());
                      }
                      _uploadFile(context);
                    }
                  },
                  child: Text('Purchase Now \$$price').text.size(20).make()),
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
      String items = '';
      if (drugTestValue && drugScreenValue) {
        items = 'Pre-Employment Drug Test & No Pre-Employment Drug Screen';
      } else if (drugTestValue) {
        items = 'Pre-Employment Drug Test';
      } else if (drugScreenValue) {
        items = 'No Pre-Employment Drug Screen';
      }
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
