import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

import '../../utils/custom_dialog.dart';
import '../../utils/links.dart';
import '../../utils/logged_in_user.dart';

class UCR extends StatefulWidget {
  const UCR({Key? key}) : super(key: key);

  @override
  State<UCR> createState() => _UCRState();
}

class _UCRState extends State<UCR> {

  final _formKey = GlobalKey<FormState>();
  ProgressDialog? _progressDialog;

  TextEditingController ucrDotNumber = TextEditingController();
  TextEditingController ucrDocketType = TextEditingController();
  TextEditingController ucrDocketNumber = TextEditingController();
  TextEditingController ucrEIN = TextEditingController();

  Future<void> _uploadData(BuildContext context) async{
    _progressDialog = ProgressDialog(context: context);
    _progressDialog!.show(
      max: 100,
      msg: 'Please wait...',
      progressType: ProgressType.normal,
    );

    String userId = User.uid;
    String dotNumber = ucrDotNumber.text;
    String docketType = ucrDocketType.text;
    String docketNumber = ucrDocketNumber.text;
    String ein = ucrEIN.text;

    var request = http.MultipartRequest('POST', Uri.parse(Links.ucr));
    request.fields['user_id'] = userId;
    request.fields['dot_number'] = dotNumber;
    request.fields['docket_type'] = docketType;
    request.fields['docket_number'] = docketNumber;
    request.fields['ein_number'] = ein;

    var response = await request.send();

    if(response.statusCode == 200){
      //clear fields
      ucrDotNumber.clear();
      ucrDocketType.clear();
      ucrDocketNumber.clear();
      ucrEIN.clear();

      _progressDialog!.close();
      Future.microtask(() {
        showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(
            title: 'Success',
            content: 'UCR Registration Successful',
          ),
        );
      });
    }
    else{
      _progressDialog!.close();
      Future.microtask(() {
        showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(
            title: 'Error',
            content: 'UCR Registration Failed',
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('UCR Registration',
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
                controller: ucrDotNumber,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: "Enter DOT Number",
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
            Container(
              width: double.maxFinite,
              child: DropdownButtonFormField(
                onChanged: (value) {
                  setState(() {
                    ucrDocketType.text = value.toString();
                  });
                },
                style: TextStyle(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                  labelText: "Select Docket Type",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Choose option';
                  }
                  return null;
                },
                items: [
                  DropdownMenuItem(
                    value: "MC",
                    child: Text("MC"),
                  ),
                  DropdownMenuItem(
                    value: "MX",
                    child: Text("MX"),
                  ),
                  DropdownMenuItem(
                    value: "FF",
                    child: Text("FF"),
                  ),
                ],
              ),
            ),
            Container(
              height: 15,
            ),
            Container(
              width: double.maxFinite,
              child: TextFormField(
                controller: ucrDocketNumber,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: "Enter Docket Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Docket Number';
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
                controller: ucrEIN,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: "Enter EIN Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter EIN Number';
                  }
                  return null;
                },
              ),
            ),
            Container(
              height: 15,
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
                      _uploadData(context);
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
