import 'dart:convert';

import 'package:dotcomplypro/screens/auth/register.dart';
import 'package:dotcomplypro/screens/password/reset_password.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../../utils/links.dart';
import '../../utils/logged_in_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../services/notification_services.dart';
import 'package:http/http.dart' as http;

import '../home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  bool obscureText = true;
  ProgressDialog? _progressDialog;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  NotificationServices notificationServices = NotificationServices();



  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
  }

  //method to login
  Future<void> _login() async {
    _progressDialog = ProgressDialog(context: context);
    _progressDialog!.show(
      max: 100,
      msg: 'Please wait...',
      progressType: ProgressType.normal,
    );

    try {
      var response = await http.post(Uri.parse(Links.login), body: {
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      });

      if (response.body != 'failure') {
        User.uid = response.body;
        User.email = emailController.text;

        //send token
        notificationServices.isTokenRefresh();
        String? token = await notificationServices.getDeviceToken();
        print('token:  $token');
        sendToken(User.uid, token);

        //bool isPaymentDone = await checkIfPaymentDone(User.uid);

        _progressDialog!.close();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
      } else {
        _progressDialog!.close();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Invalid username or password.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      _progressDialog!.close();
      print('Error decoding JSON: $e');
    }
  }

  void sendToken(String userID, String token) async {
    final data = {
      'userID': userID,
      'token': token,
    };

    final jsonData = jsonEncode(data);

    try {
      final response = await http
          .post(Uri.parse(Links.send_token), body: jsonData, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Token sent');
        }
      } else {
        if (kDebugMode) {
          print('Token not sent');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<bool> checkIfPaymentDone(String? uid) async {
    final response = await http.post(Uri.parse(Links.get_payment), body: {
      'user_id': uid,
    });

    if (response.body != 'failure') {
      print(response.body);
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    child: Image.asset('assets/logo.png'),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: TextFormField(
                      controller: emailController,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Email';
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
                      controller: passwordController,
                      obscureText: obscureText,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                          )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
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
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            _login();
                          }
                        },
                        child: Text('Login').text.size(20).make()),
                  ),
                  Container(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ResetPassword();
                        }));
                      },
                      child: Text('Forgot Password?'),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Register();
                        }));
                      },
                      child: Text('Dont\'t have account? Register here...'),
                    ),
                  ),
                ],
              )),
        ),
      ).p16(),
    );
  }
}
