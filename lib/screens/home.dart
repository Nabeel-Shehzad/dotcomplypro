import 'dart:convert';

import 'package:dotcomplypro/screens/info/message.dart';
import 'package:dotcomplypro/screens/info/vehicle_info.dart';
import 'package:dotcomplypro/screens/notifications/notifications.dart';
import 'package:dotcomplypro/screens/policy/privacy_policy.dart';
import 'package:dotcomplypro/utils/logged_in_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../utils/links.dart';
import '../utils/rates.dart';
import 'forms/boc.dart';
import 'forms/driver.dart';
import 'forms/drug.dart';
import 'forms/eca.dart';
import 'forms/ucr.dart';
import 'forms/vehicle.dart';
import 'info/driver_info.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  String bocDocLink = '';
  String bocDocName = '';

  String ucrDocLink = '';
  String ucrDocName = '';

  String userDrugLink = '';
  String userDrugName = '';

  bool isBocAvailable = false;
  bool isUcrAvailable = false;
  bool isDrugAvailable = false;

  ProgressDialog? _progressDialog;
  static final List<Widget> _widgetOptions = <Widget>[
    Driver(),
    Vehicle(),
    BOC(),
    ECA(),
    UCR(),
    Drug(),
    DriverInfo(),
    VehicleInfo(),
    PrivacyPolicy(
      flag: true,
    ),
  ];

  void _onMenuItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop(); // Close the drawer
  }

  Future<void> checkIfPaymentDone(String? uid) async {
    final response = await http.post(Uri.parse(Links.get_payment), body: {
      'user_id': uid,
    });

    if (response.body != 'failure') {
      List<String> paymentDetails = response.body.split(',');
      if (paymentDetails[0] == 'Yes') {
        setState(() {
          User.isBOCPaid = true;
        });
      }
      if (paymentDetails[1] == 'Yes') {}
      if (paymentDetails[3] == 'Yes') {}
    }
  }

  Future<Map<String, dynamic>?> getBOCDoc() async {
    final apiUrl = Links.get_boc_doc;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'user_id': User.uid},
      );

      if (response.statusCode == 200) {
        final driverData = json.decode(response.body);
        return driverData;
      } else {
        if (kDebugMode) {
          print(
              'Failed to fetch BOC details. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred while fetching BOC details: $e');
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> getDrugDoc() async {
    final apiUrl = Links.get_drug_doc;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'user_id': User.uid},
      );

      if (response.statusCode == 200) {
        final driverData = json.decode(response.body);
        return driverData;
      } else {
        if (kDebugMode) {
          print(
              'Failed to fetch Drug details. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred while fetching Drug details: $e');
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUCRDoc() async {
    final apiUrl = Links.get_ucr_doc;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'user_id': User.uid},
      );

      if (response.statusCode == 200) {
        final driverData = json.decode(response.body);
        return driverData;
      } else {
        if (kDebugMode) {
          print(
              'Failed to fetch UCR details. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred while fetching UCR details: $e');
      }
    }
    return null;
  }

  void getDocument() async {
    getBOCDoc().then((value) {
      if (value != null) {
        setState(() {
          bocDocName = value['document_name'];
          bocDocLink = value['location'] + value['document_name'];
          bocDocLink = 'https://dotcomplypro.com/MobileScripts/$bocDocLink';
          isBocAvailable = true;
        });
      }
    });
    getDrugDoc().then((value) => {
          if (value != null)
            {
              setState(() {
                userDrugName = value['document_name'];
                userDrugLink = value['location'] + value['document_name'];
                userDrugLink =
                    'https://dotcomplypro.com/MobileScripts/$userDrugLink';
                isDrugAvailable = true;
              })
            }
        });
    getUCRDoc().then((value) {
      if (value != null) {
        setState(() {
          ucrDocName = value['document_name'];
          ucrDocLink = value['location'] + value['document_name'];
          ucrDocLink = 'https://dotcomplypro.com/MobileScripts/$ucrDocLink';
          isUcrAvailable = true;
        });
      }
    });
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

  Future<List<dynamic>?> getRates() async {
    final apiUrl = Links.get_rates;

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        final rates = json.decode(response.body);
        return rates;
      } else {
        if (kDebugMode) {
          print('Failed to fetch rates. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred while fetching rates: $e');
      }
    }
    return null;
  }

  void getRatesData() async {
    final ratesList = await getRates();
    if (ratesList != null) {
      setState(() {
        for (var rate in ratesList) {
          //add into Rates.rate map
          Rates.rates[rate['product_name']] = rate['rate'];
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfPaymentDone(User.uid);
    getDocument();
    getRatesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DOT ComplyPro'),
        centerTitle: true,
        backgroundColor: Colors.teal[300],
        automaticallyImplyLeading: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LiveNotifications()));
                  },
                  child: Text('Notifications'),
                ),
              ),
              PopupMenuItem(
                child: TextButton(
                  onPressed: () async {
                    if (isBocAvailable) {
                      await _pickDirectory();
                      await _saveFileToDirectory(bocDocLink, bocDocName);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('BOC-3 document not Available yet')));
                    }
                  },
                  child: Text('Download BOC-3'),
                ),
              ),
              PopupMenuItem(
                child: TextButton(
                  onPressed: () async {
                    if (isDrugAvailable) {
                      await _pickDirectory();
                      await _saveFileToDirectory(userDrugLink, userDrugName);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'Drug & Alcohol document not Available yet')));
                    }
                  },
                  child: Text('Download Drug & Alcohol'),
                ),
              ),
              PopupMenuItem(
                child: TextButton(
                  onPressed: () async {
                    if (isUcrAvailable) {
                      await _pickDirectory();
                      await _saveFileToDirectory(ucrDocLink, ucrDocName);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('UCR document not Available yet')));
                    }
                  },
                  child: Text('Download UCR'),
                ),
              ),
              PopupMenuItem(
                child: TextButton(
                  onPressed: () async {
                     Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Message()));
                  },
                  child: Text('Message From Admin'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _widgetOptions[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Center(
                child: SizedBox(
                  height: 120,
                  child: Image(
                    image: AssetImage('assets/logo.png'),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(LineIcons.user),
              title: const Text('Driver'),
              onTap: () {
                _onMenuItemSelected(0);
              },
            ),
            ListTile(
              leading: const Icon(LineIcons.truck),
              title: const Text('Vehicle'),
              onTap: () {
                _onMenuItemSelected(1);
              },
            ),
            ListTile(
              leading: const Icon(LineIcons.blogger),
              title: const Text('BOC-3'),
              onTap: () {
                _onMenuItemSelected(2);
              },
            ),
            ListTile(
              leading: const Icon(LineIcons.erlang),
              title: const Text('ECA'),
              onTap: () {
                _onMenuItemSelected(3);
              },
            ),
            ListTile(
              leading: const Icon(LineIcons.uniregistry),
              title: const Text('UCR'),
              onTap: () {
                _onMenuItemSelected(4);
              },
            ),
            ListTile(
              leading: const Icon(LineIcons.flask),
              title: const Text('Drug & Alcohol'),
              onTap: () {
                _onMenuItemSelected(5);
              },
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(
                        color: Colors.black,
                        height: 36,
                      )),
                ),
                Text('Profiles'),
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                      child: Divider(
                        color: Colors.black,
                        height: 36,
                      )),
                ),
              ],
            ),
            ListTile(
              leading: const Icon(LineIcons.user),
              title: const Text('Driver Form'),
              onTap: () {
                _onMenuItemSelected(6);
              },
            ),
            ListTile(
              leading: const Icon(LineIcons.truck),
              title: const Text('Manage Vehicle'),
              onTap: () {
                _onMenuItemSelected(7);
              },
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(
                        color: Colors.black,
                        height: 36,
                      )),
                ),
                Text('Others'),
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                      child: Divider(
                        color: Colors.black,
                        height: 36,
                      )),
                ),
              ],
            ),
            ListTile(
              leading: const Icon(LineIcons.lock),
              title: const Text('Privacy Policy'),
              onTap: () {
                _onMenuItemSelected(8);
              },
            ),
          ],
        ),
      ),
    );
  }
}
