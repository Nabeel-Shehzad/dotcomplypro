import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:show_platform_date_picker/show_platform_date_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import '../../utils/custom_dialog.dart';
import '../../utils/links.dart';
import '../../utils/logged_in_user.dart';

class Vehicle extends StatefulWidget {
  const Vehicle({Key? key}) : super(key: key);

  @override
  State<Vehicle> createState() => _VehicleState();
}

class _VehicleState extends State<Vehicle> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();

  TextEditingController vehicleUnitNumber = TextEditingController();
  TextEditingController vehicleYear = TextEditingController();
  TextEditingController vehicleModel = TextEditingController();
  TextEditingController vehicleMake = TextEditingController();
  TextEditingController vehicleLicense = TextEditingController();
  TextEditingController vehicleVIN = TextEditingController();
  TextEditingController vehicleGVWR = TextEditingController();
  TextEditingController vehicleDateOfLastReading = TextEditingController();
  TextEditingController vehicleMeterReading = TextEditingController();
  TextEditingController vehicleDateNextInspectionDue = TextEditingController();
  TextEditingController vehicleAnnualInspection = TextEditingController();
  TextEditingController vehicleMaintenanceRecords = TextEditingController();
  TextEditingController vehicleMiscellaneousInfo = TextEditingController();
  TextEditingController vehicleMiscellaneousFiles = TextEditingController();

  ProgressDialog? _progressDialog;

  Future<void> _uploadData(BuildContext context) async {
    _progressDialog = ProgressDialog(context: context);
    _progressDialog!.show(
      max: 100,
      msg: 'Please wait...',
      progressType: ProgressType.normal,
    );

    String userId = User.uid;
    String unitNumber = vehicleUnitNumber.text;
    String year = vehicleYear.text;
    String model = vehicleModel.text;
    String license = vehicleLicense.text;
    String vin = vehicleVIN.text;
    String gvwr = vehicleGVWR.text;
    String dateLastReading = vehicleDateOfLastReading.text;
    String odometerReading = vehicleMeterReading.text;
    String dateInspectionDue = vehicleDateNextInspectionDue.text;
    String miscellaneousInfo = vehicleMiscellaneousInfo.text;

    var request = http.MultipartRequest('POST', Uri.parse(Links.vehicle));
    // Add text fields to the request
    request.fields['user_id'] = userId;
    request.fields['unit_number'] = unitNumber;
    request.fields['year'] = year;
    request.fields['model'] = model;
    request.fields['license'] = license;
    request.fields['vin'] = vin;
    request.fields['gvwr'] = gvwr;
    request.fields['date_last_reading'] = dateLastReading;
    request.fields['odometer_reading'] = odometerReading;
    request.fields['date_inspection_due'] = dateInspectionDue;
    request.fields['miscellaneous_info'] = miscellaneousInfo;

    // Add file names to the request
    request.fields['annual_inspection'] =
        File(vehicleAnnualInspection.text).path.split('/').last;
    request.fields['maintenance_record'] =
        File(vehicleMaintenanceRecords.text).path.split('/').last;
    request.fields['miscellaneous_files'] =
        File(vehicleMiscellaneousFiles.text).path.split('/').last;

    // Add files to the request
    request.files.add(await http.MultipartFile.fromPath(
      'annual_inspection',
      File(vehicleAnnualInspection.text).path,
    ));
    request.files.add(await http.MultipartFile.fromPath(
      'maintenance_record',
      File(vehicleMaintenanceRecords.text).path,
    ));
    request.files.add(await http.MultipartFile.fromPath(
      'miscellaneous_files',
      File(vehicleMiscellaneousFiles.text).path,
    ));

    // Send the request
    var response = await request.send();

    // Check the response status
    if (response.statusCode == 200) {
      _progressDialog!.close();
      Future.microtask(() {
        showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(
            title: 'Success',
            content: 'Vehicle Files Uploaded Successfully',
          ),
        );
      });
    } else {
      // Upload failed
      _progressDialog!.close();
      Future.microtask(() {
        showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(
            title: 'Error',
            content: 'Vehicle Files Upload Failed',
          ),
        );
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final ShowPlatformDatePicker platformDatePicker =
        ShowPlatformDatePicker(buildContext: context);
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Vehicle Files',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.maxFinite,
              child: TextFormField(
                controller: vehicleUnitNumber,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Unit Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Unit Number';
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
                controller: vehicleYear,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Year',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Year';
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
                controller: vehicleModel,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Model',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Model';
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
                controller: vehicleMake,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Make',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Make';
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
                controller: vehicleLicense,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'License',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter License';
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
                controller: vehicleVIN,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'VIN',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter VIN';
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
                controller: vehicleGVWR,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'GVWR',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter GVWR';
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
                readOnly: true,
                controller: vehicleDateOfLastReading,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: "Date of Last Reading",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please select Date of Last Reading';
                  }
                  return null;
                },
                onTap: () async {
                  final newSelectedDatePicker =
                      await platformDatePicker.showPlatformDatePicker(
                    context,
                    selectedDate,
                    DateTime(1900),
                    DateTime.now().add(Duration(days: 3650)),
                  );
                  setState(() {
                    vehicleDateOfLastReading.text =
                        newSelectedDatePicker.toString();
                  });
                },
              ),
            ),
            Container(
              height: 15,
            ),
            Container(
              width: double.maxFinite,
              child: TextFormField(
                controller: vehicleMeterReading,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Odometer Reading',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Meter Reading';
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
                readOnly: true,
                controller: vehicleDateNextInspectionDue,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: "Date Next Inspection Due",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please select Date Next Inspection Due';
                  }
                  return null;
                },
                onTap: () async {
                  final newSelectedDatePicker =
                      await platformDatePicker.showPlatformDatePicker(
                    context,
                    selectedDate,
                    DateTime(1900),
                    DateTime.now().add(Duration(days: 3650)),
                  );
                  setState(() {
                    vehicleDateNextInspectionDue.text =
                        newSelectedDatePicker.toString();
                  });
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
                controller: vehicleAnnualInspection,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: "Select Annual Inspection",
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
                onTap: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null && result.files.isNotEmpty) {
                    vehicleAnnualInspection.text = result.files.first.path!;
                  }
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
                controller: vehicleMaintenanceRecords,
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
                onTap: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null && result.files.isNotEmpty) {
                    vehicleMaintenanceRecords.text = result.files.first.path!;
                  }
                },
              ),
            ),
            Container(
              height: 15,
            ),
            Container(
              width: double.maxFinite,
              child: TextFormField(
                maxLines: 3,
                controller: vehicleMiscellaneousInfo,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Miscellaneous Information',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Miscellaneous Information';
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
                readOnly: true,
                controller: vehicleMiscellaneousFiles,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: "Select Miscellaneous Files",
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
                onTap: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null && result.files.isNotEmpty) {
                    vehicleMiscellaneousFiles.text = result.files.first.path!;
                  }
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
