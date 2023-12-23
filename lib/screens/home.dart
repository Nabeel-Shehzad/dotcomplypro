import 'dart:convert';

import 'package:dotcomplypro/screens/notifications/notifications.dart';
import 'package:dotcomplypro/screens/pay/payment.dart';
import 'package:dotcomplypro/utils/logged_in_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../utils/links.dart';
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
  static List<Widget> _widgetOptions = <Widget>[
    Driver(),
    Vehicle(),
    BOC(),
    ECA(),
    UCR(),
    Drug(),
  ];
  static List<GButton> tabs = [
    GButton(
      icon: LineIcons.user,
      text: 'Driver',
    ),
    GButton(
      icon: LineIcons.truck,
      text: 'Vehicle',
    ),
    GButton(
      icon: LineIcons.blogger,
      text: 'BOC',
    ),
    GButton(
      icon: LineIcons.erlang,
      text: 'ECA',
    ),
    GButton(
      icon: LineIcons.uniregistry,
      text: 'UCR',
    ),
    GButton(
      icon: LineIcons.flask,
      text: 'Drug',
    ),
  ];

  Future<void> checkIfPaymentDone(String? uid) async {
    final response = await http.post(Uri.parse(Links.get_payment), body: {
      'user_id': uid,
    });

    if (response.body != 'failure') {
      //split response body on ,
      List<String> paymentDetails = response.body.split(',');
      if (paymentDetails[0] == 'Yes') {
        setState(() {
          _widgetOptions.add(BOC());
          tabs.add(GButton(
            icon: LineIcons.blogger,
            text: 'BOC',
          ));
        });
      }
      if (paymentDetails[1] == 'Yes') {
        setState(() {
          _widgetOptions.add(ECA());
          tabs.add(GButton(
            icon: LineIcons.erlang,
            text: 'ECA',
          ));
        });
      }
      if (paymentDetails[2] == 'Yes') {
        setState(() {
          _widgetOptions.add(UCR());
          tabs.add(GButton(
            icon: LineIcons.uniregistry,
            text: 'UCR',
          ));
        });
      }
      if (paymentDetails[3] == 'Yes') {
        setState(() {
          _widgetOptions.add(Drug());
          tabs.add(GButton(
            icon: LineIcons.flask,
            text: 'Drug',
          ));
        });
      }
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

  @override
  void initState() {
    super.initState();
    //checkIfPaymentDone(User.uid);
    getDocument();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('DOT ComplyPro'),
          centerTitle: true,
          backgroundColor: Colors.teal[300],
          automaticallyImplyLeading: false,
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
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DriverInfo()));
                    },
                    child: Text('Driver Form'),
                  ),
                ),
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () async {
                      if (isBocAvailable) {
                        await _pickDirectory();
                        await _saveFileToDirectory(bocDocLink, bocDocName);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('BOC-3 document not Available yet')));
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
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('UCR document not Available yet')));
                      }
                    },
                    child: Text('Download UCR'),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: GNav(
                  rippleColor: Colors.grey[300]!,
                  hoverColor: Colors.grey[100]!,
                  gap: 8,
                  activeColor: Colors.black,
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: Duration(milliseconds: 400),
                  tabBackgroundColor: Colors.grey[100]!,
                  color: Colors.black,
                  tabs: tabs,
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
              ),
            ),
          ),
        ));
  }
}
