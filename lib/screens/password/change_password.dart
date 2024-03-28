import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import '../../utils/links.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key, required this.email});

  final String email;

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formkey = GlobalKey<FormState>();
  bool obscureText = true;
  ProgressDialog? _progressDialog;
  TextEditingController passwordController = TextEditingController();

  Future<void> updatePassword() async {
    _progressDialog = ProgressDialog(context: context);
    _progressDialog!.show(
      max: 100,
      msg: 'Please wait...',
      progressType: ProgressType.normal,
    );

    var response = await http.post(Uri.parse(Links.update_password), body: {
      'email': widget.email,
      'password': passwordController.text,
    });

    try {
      if (response.statusCode == 200) {
        _progressDialog!.close();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.body),
          ),
        );
        Navigator.pop(context);
      } else {
        _progressDialog!.close();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.body),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      _progressDialog!.close();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
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
                          return 'Please enter your new password';
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
                          if (_formkey.currentState!.validate()) {
                            updatePassword();
                          }
                        },
                        child: Text('Update Password').text.size(20).make()),
                  ),
                ],
              )),
        ),
      ).p16(),
    );
  }
}
