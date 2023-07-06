import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import '../../utils/custom_dialog.dart';
import '../../utils/links.dart';
import '../../utils/logged_in_user.dart';

class BOC extends StatefulWidget {
  const BOC({Key? key}) : super(key: key);

  @override
  State<BOC> createState() => _BOCState();
}

class _BOCState extends State<BOC> {
  final _formKey = GlobalKey<FormState>();
  ProgressDialog? _progressDialog;


  TextEditingController dotNumber = TextEditingController();
  TextEditingController legalName = TextEditingController();
  TextEditingController dba = TextEditingController();
  TextEditingController state = TextEditingController();

  Future<void> _uploadData(BuildContext context) async{
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

    var request = http.MultipartRequest('POST',Uri.parse(Links.boc));
    request.fields['user_id'] = userId;
    request.fields['dot_number'] = dotNumber;
    request.fields['legal_name'] = legalName;
    request.fields['dba'] = dba;
    request.fields['state'] = state;

    var response = await request.send();

    String responseData = await response.stream.bytesToString();

    if(response.statusCode == 200){
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
            content: 'Your BOC-3 filling has been submitted successfully.',
          ),
        );
      });
    } else{
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
            Container(
              height: 15,
            ),
            Container(
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
            Container(
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
            Container(
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter DBA';
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
