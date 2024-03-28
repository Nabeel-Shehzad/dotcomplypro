import 'dart:async';
import 'dart:convert';
import 'package:dotcomplypro/utils/links.dart';
import 'package:dotcomplypro/utils/logged_in_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:http/http.dart' as http;

import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:velocity_x/velocity_x.dart';

class DriverInfo extends StatefulWidget {
  const DriverInfo({super.key});

  @override
  State<DriverInfo> createState() => _DriverInfoState();
}

class _DriverInfoState extends State<DriverInfo> {
  String fullName = 'None';
  String dateHired = 'None';
  String drivers = 'None';
  String address = 'None';
  String dob = 'None';
  String ssn = 'None';
  String phone = 'None';
  String licenseNo = 'None';
  String licenseState = 'None';
  String licenseExpDate = 'None';
  String nextDueAnnualReviewDate = 'None';
  String randomDrug = 'None';
  String preEmploymentDrug = 'None';
  String dateLastRandomDrugTest = 'None';
  String dateDrugConsortium = 'None';
  String medicalExamExpiryDate = 'None';
  String misc = 'None';
  String dateTerminated = 'None';
  String licenseImageFront =
      'https://cdn-icons-png.flaticon.com/512/553/553265.png';
  String licenseImageBack =
      'https://cdn-icons-png.flaticon.com/512/553/553265.png';

  String annualReviewRecord = '';
  String driverLicenseRecord = '';
  String drugScreenRecord = '';
  String medicalExamRecord = '';
  String employmentRecord = '';
  String personnelRecord = '';

  ProgressDialog? _progressDialog;

  Future<Map<String, dynamic>?> fetchDriverDetails(String userID) async {
    final apiUrl = Links.get_driver;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'user_id': userID},
      );

      if (response.statusCode == 200) {
        final driverData = json.decode(response.body);
        return driverData;
      } else {
        if (kDebugMode) {
          print(
              'Failed to fetch driver details. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred while fetching driver details: $e');
      }
    }

    return null;
  }

  void getDriverDetails() async {
    final userId = User.uid;
    final driverDetails = await fetchDriverDetails(userId);
    if (driverDetails != null) {
      setState(() {
        fullName =
            '${driverDetails['first_name']} ${driverDetails['last_name']}';
        drivers = '${driverDetails['drivers']}';
        dateHired = '${driverDetails['date_hired']}';
        address = '${driverDetails['address']}';
        dob = '${driverDetails['date_of_birth']}';
        ssn = '${driverDetails['ssn']}';
        phone = '${driverDetails['phone']}';
        licenseNo = '${driverDetails['license_number']}';
        licenseState = '${driverDetails['license_state']}';
        licenseExpDate = '${driverDetails['license_expiry_date']}';
        nextDueAnnualReviewDate =
            '${driverDetails['next_due_date_annual_review']}';
        randomDrug = '${driverDetails['random_drug']}';
        preEmploymentDrug = '${driverDetails['date_pre_employment']}';
        dateLastRandomDrugTest = '${driverDetails['date_last_random_drug']}';
        dateDrugConsortium = '${driverDetails['date_drug_consortium']}';
        medicalExamExpiryDate = '${driverDetails['expiry_date_medical_exam']}';
        misc = '${driverDetails['miscellaneous']}';
        dateTerminated = '${driverDetails['date_terminated']}';

        String frontImg =
            '${Links.files_url}${driverDetails['location']}${driverDetails['license_front_img']}';
        String backImg =
            '${Links.files_url}${driverDetails['location']}${driverDetails['license_back_img']}';
        licenseImageFront = frontImg;
        licenseImageBack = backImg;

        annualReviewRecord =
            '${Links.files_url}${driverDetails['location']}${driverDetails['annual_review_record']}';
        driverLicenseRecord =
            '${Links.files_url}${driverDetails['location']}${driverDetails['driver_lic']}';
        drugScreenRecord =
            '${Links.files_url}${driverDetails['location']}${driverDetails['drug_screen']}';
        medicalExamRecord =
            '${Links.files_url}${driverDetails['location']}${driverDetails['medical_exam']}';
        employmentRecord =
            '${Links.files_url}${driverDetails['location']}${driverDetails['employment_application']}';
        personnelRecord =
            '${Links.files_url}${driverDetails['location']}${driverDetails['personnel_matters']}';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDriverDetails();
  }

  DirectoryLocation? _pickedDirecotry;

  Future<void> _pickDirectory() async {
    _pickedDirecotry = (await FlutterFileDialog.pickDirectory());
    setState(() {
      print('Here saved: $_pickedDirecotry');
    });
  }

  Future<void> _saveFileToDirectory(String url, String filename) async {
    _progressDialog = ProgressDialog(context: context);
    _progressDialog!.show(
      max: 100,
      msg: 'Please wait...',
      progressType: ProgressType.normal,
    );

    var response = await http.get(Uri.parse(url));
    var fileData = response.bodyBytes;
    var mimeType = response.headers['content-type'];
    var newFileName = filename;

    FlutterFileDialog.saveFileToDirectory(
      directory: _pickedDirecotry!,
      data: fileData,
      mimeType: mimeType,
      fileName: newFileName,
      replace: false,
      onFileExists: () async {
        await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            _progressDialog!.close();
            return SimpleDialog(
              title: const Text('File already exists'),
              children: <Widget>[
                SimpleDialogOption(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                SimpleDialogOption(
                  child: const Text('Replace'),
                  onPressed: () {
                    Navigator.pop(context);
                    FlutterFileDialog.saveFileToDirectory(
                      directory: _pickedDirecotry!,
                      data: fileData,
                      mimeType: mimeType,
                      fileName: newFileName,
                      replace: true,
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
    _progressDialog!.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: double.infinity,
                child: DataTable(
                  dataRowMaxHeight: 70,
                    columns: [
                  DataColumn(label: Text('Fields')),
                  DataColumn(label: Text('Information')),
                ], rows: [
                  DataRow(cells: [
                    DataCell(Text('Full Name')),
                    DataCell(Text(fullName)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Drivers')),
                    DataCell(Text(drivers)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Date Hired')),
                    DataCell(Text(dateHired)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Address')),
                    DataCell(Text(address)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Date of Birth')),
                    DataCell(Text(dob)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Phone')),
                    DataCell(Text(phone)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('SSN')),
                    DataCell(Text(ssn)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('License No')),
                    DataCell(Text(licenseNo)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('License State')),
                    DataCell(Text(licenseState)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('License Expiry Date')),
                    DataCell(Text(licenseExpDate)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Download License')),
                    DataCell(
                      TextButton(
                        onPressed: () async {
                          await _pickDirectory();
                          await _saveFileToDirectory(driverLicenseRecord,
                              driverLicenseRecord.split('/').last);
                        },
                        child: const Text('Download'),
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Next Due Annual Review Date')),
                    DataCell(Text(nextDueAnnualReviewDate)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Download Annual Review Record')),
                    DataCell(
                      TextButton(
                        onPressed: () async {
                          await _pickDirectory();
                          await _saveFileToDirectory(annualReviewRecord,
                              annualReviewRecord.split('/').last);
                        },
                        child: const Text('Download'),
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Random Drug')),
                    DataCell(Text(randomDrug)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Pre Employment Date')),
                    DataCell(Text(preEmploymentDrug)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Date Last Random Drug')),
                    DataCell(Text(dateLastRandomDrugTest)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Date Drug Consortium')),
                    DataCell(Text(dateDrugConsortium)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Download Drug Screen')),
                    DataCell(
                      TextButton(
                        onPressed: () async {
                          await _pickDirectory();
                          await _saveFileToDirectory(drugScreenRecord,
                              drugScreenRecord.split('/').last);
                        },
                        child: const Text('Download'),
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Download License Image Front')),
                    DataCell(
                      TextButton(
                        onPressed: () async {
                          await _pickDirectory();
                          await _saveFileToDirectory(licenseImageFront,
                              licenseImageFront.split('/').last);
                        },
                        child: const Text('Download'),
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Download License Image Back')),
                    DataCell(
                      TextButton(
                        onPressed: () async {
                          await _pickDirectory();
                          await _saveFileToDirectory(licenseImageBack,
                              licenseImageBack.split('/').last);
                        },
                        child: const Text('Download'),
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Expiry Medical Exam')),
                    DataCell(Text(medicalExamExpiryDate)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Miscellaneous')),
                    DataCell(Text(misc)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Date Terminated')),
                    DataCell(Text(dateTerminated)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Download Medical Exam')),
                    DataCell(
                      TextButton(
                        onPressed: () async {
                          await _pickDirectory();
                          await _saveFileToDirectory(medicalExamRecord,
                              medicalExamRecord.split('/').last);
                        },
                        child: const Text('Download'),
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Download Employment Application')),
                    DataCell(
                      TextButton(
                        onPressed: () async {
                          await _pickDirectory();
                          await _saveFileToDirectory(employmentRecord,
                              employmentRecord.split('/').last);
                        },
                        child: const Text('Download'),
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Download Personnel matters')),
                    DataCell(
                      TextButton(
                        onPressed: () async {
                          await _pickDirectory();
                          await _saveFileToDirectory(
                              personnelRecord, personnelRecord.split('/').last);
                        },
                        child: const Text('Download'),
                      ),
                    ),
                  ]),
                ]),
              ),
            ),
          ],
        ).p(8),
      ),
    );
  }
}
