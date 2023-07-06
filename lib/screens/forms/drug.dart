import 'dart:io';
import 'package:dotcomplypro/utils/links.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mime/mime.dart';
import '../../utils/custom_dialog.dart';
import '../../utils/logged_in_user.dart';

class Drug extends StatefulWidget {
  const Drug({Key? key}) : super(key: key);

  @override
  State<Drug> createState() => _DrugState();
}

class _DrugState extends State<Drug> {
  final _formKey = GlobalKey<FormState>();
  List<File> _files = List.generate(6, (_) => File(''));
  ProgressDialog? _progressDialog;

  List<TextEditingController> _controllers = [];

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

    var response = await request.send();

    try {
      if (response.statusCode == 200) {
        _progressDialog!.close();
        setState(() {
          _files = List.generate(6, (_) => File(''));
          _controllers = List.generate(6, (_) => TextEditingController());
        });

        Future.microtask(() {
          showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog(
              title: 'Success',
              content: 'Drug & Alcohol Program data uploaded successfully!'
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
            Container(
              width: double.maxFinite,
              child: TextFormField(
                readOnly: true,
                controller: _controllers[0],
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: "Select Maintenance Records",
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
            Container(
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
            Container(
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
            Container(
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
            Container(
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
            Container(
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
            Container(
              height: 50,
              width: double.maxFinite,
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _uploadFile(context);
                    }
                  },
                  child: Text('Submit Form').text.size(20).make()),
            ),
            Container(
              height: 15,
            ),
          ],
        ).p8(),
      ),
    );
  }
}
