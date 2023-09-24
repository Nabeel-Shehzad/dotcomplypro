import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import '../../utils/links.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formkey = GlobalKey<FormState>();
  bool obscureText = true;

  File? licenseFrontImgFile;
  File? licenseBackImgFile;
  ProgressDialog? _progressDialog;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController driverLicenseFrontController = TextEditingController();
  TextEditingController driverLicenseBackController = TextEditingController();

  // Function to handle image selection
  Future<void> _selectImage(ImageSource source, bool isFrontImage) async {
    ImagePicker _picker = ImagePicker();
    final pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      setState(() {
        if (isFrontImage) {
          licenseFrontImgFile = imageFile;
          driverLicenseFrontController.text =
              pickedImage.path; // Update the controller with the image path
        } else {
          licenseBackImgFile = imageFile;
          driverLicenseBackController.text =
              pickedImage.path; // Update the controller with the image path
        }
      });
    }
  }

  Future<void> register() async {
    _progressDialog = ProgressDialog(context: context);
    _progressDialog!.show(
      max: 100,
      msg: 'Please wait...',
      progressType: ProgressType.normal,
    );

    var request = await http.MultipartRequest('POST',Uri.parse(Links.register));
    request.fields['first_name'] = firstNameController.text;
    request.fields['last_name'] = lastNameController.text;
    request.fields['email'] = emailController.text;
    request.fields['password'] = passwordController.text;
    // Upload the license front image
    if (licenseFrontImgFile != null) {
      request.fields['license_front_img'] = licenseFrontImgFile!.path.split('/').last;
      request.files.add(await http.MultipartFile.fromPath(
        'license_front_img',
        licenseFrontImgFile!.path,
      ));
    }

    // Upload the license back image
    if (licenseBackImgFile != null) {
      request.fields['license_back_img'] = licenseBackImgFile!.path.split('/').last;
      request.files.add(await http.MultipartFile.fromPath(
        'license_back_img',
        licenseBackImgFile!.path,
      ));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      _progressDialog!.close();
      Navigator.pop(context);
    } else {
      _progressDialog!.close();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registration Failed'),
            content: Text('Please try again later'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    child: Image.asset('assets/logo.png'),
                  ),
                  Container(
                    width: double.maxFinite,
                    child: TextFormField(
                      controller: firstNameController,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your First Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    height: 15,
                  ),
                  Container(
                    width: double.maxFinite,
                    child: TextFormField(
                      controller: lastNameController,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Last Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    height: 15,
                  ),
                  Container(
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
                  Container(
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
                  'Choose Driver License Front Image'.text.lg.make(),
                  InkWell(
                    onTap: () => _selectImage(ImageSource.gallery, true), // Open image picker on tap
                    child: Container(
                      width: double.maxFinite,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: licenseFrontImgFile != null
                          ? Image.file(licenseFrontImgFile!) // Display chosen image
                          : Icon(Icons.add), // Show icon if no image chosen
                    ),
                  ),
                  Container(
                    height: 15,
                  ),
                  'Choose Driver License Back Image'.text.lg.make(),
                  InkWell(
                    onTap: () => _selectImage(ImageSource.gallery, false), // Open image picker on tap
                    child: Container(
                      width: double.maxFinite,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: licenseBackImgFile != null
                          ? Image.file(licenseBackImgFile!) // Display chosen image
                          : Icon(Icons.add), // Show icon if no image chosen
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
                            register();
                          }
                        },
                        child: Text('Register').text.size(20).make()),
                  ),
                  Container(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                       Navigator.pop(context);
                      },
                      child: Text('Already have an account ? Login here...'),
                    ),
                  ),
                  Container(
                    height: 15,
                  ),
                ],
              )),
        ),
      ).p16(),
    );
  }
}
