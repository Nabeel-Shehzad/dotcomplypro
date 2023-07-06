import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import '../../utils/custom_dialog.dart';
import '../../utils/links.dart';
import '../../utils/logged_in_user.dart';

class ECA extends StatefulWidget {
  const ECA({Key? key}) : super(key: key);

  @override
  State<ECA> createState() => _ECAState();
}

class _ECAState extends State<ECA> {
  final _formKey = GlobalKey<FormState>();
  ProgressDialog? _progressDialog;

  TextEditingController ecaDotNumber = TextEditingController();
  TextEditingController ecaDocketType = TextEditingController();
  TextEditingController ecaDocketNumber = TextEditingController();
  TextEditingController ecaEIN = TextEditingController();

  Future<void> _uploadData(BuildContext context) async {
    _progressDialog = ProgressDialog(context: context);
    _progressDialog!.show(
      max: 100,
      msg: 'Please wait...',
      progressType: ProgressType.normal,
    );

    String userId = User.uid;
    String dotNumber = ecaDotNumber.text;
    String docketType = ecaDocketType.text;
    String docketNumber = ecaDocketNumber.text;
    String ein = ecaEIN.text;

    var request = http.MultipartRequest('POST', Uri.parse(Links.eca));
    request.fields['user_id'] = userId;
    request.fields['dot_number'] = dotNumber;
    request.fields['docket_type'] = docketType;
    request.fields['docket_number'] = docketNumber;
    request.fields['ein_number'] = ein;

    var response = await request.send();

    if (response.statusCode == 200) {
      //clear fields
      ecaDotNumber.clear();
      ecaDocketType.clear();
      ecaDocketNumber.clear();
      ecaEIN.clear();

      _progressDialog!.close();
      Future.microtask(() {
        showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(
            title: 'Success',
            content: 'Expedited Certificate of Authority uploaded successfully.',
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
            content: 'Something went wrong. Please try again later.',
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
            Text('Expedited Certificate of Authority',
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
                controller: ecaDotNumber,
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
                    ecaDocketType.text = value.toString();
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
                controller: ecaDocketNumber,
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
                controller: ecaEIN,
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
