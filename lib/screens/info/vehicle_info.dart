import 'dart:convert';

import 'package:dotcomplypro/utils/logged_in_user.dart';
import 'package:dotcomplypro/utils/vehicle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../utils/links.dart';

class VehicleInfo extends StatefulWidget {
  const VehicleInfo({super.key});

  @override
  State<VehicleInfo> createState() => _VehicleInfoState();
}

class _VehicleInfoState extends State<VehicleInfo> {
  bool isFirstVisit = true;
  late SharedPreferences prefs;

  String vehivle_id = '';
  String unit_number = '';
  String year = '';
  String model = '';
  String license = '';
  String vin_number = '';

  List<Vehicle> vehicleList = [];

  Future<List<dynamic>?> fetchVehicleDetails(String userID) async {
    final apiUrl = Links.get_vehicle; // Ensure this is the correct API endpoint

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'user_id': userID},
      );

      if (response.statusCode == 200) {
        // Decode the JSON response into a List of Maps (List<dynamic>)
        return json.decode(response.body) as List<dynamic>;
      } else {
        // Handle non-200 responses here
        if (kDebugMode) {
          print(
              'Failed to fetch vehicle details. Status code: ${response.statusCode}');
        }
        return null;
      }
    } catch (e) {
      // Handle any errors in the request
      if (kDebugMode) {
        print('Error occurred while fetching vehicle details: $e');
      }
      return null;
    }
  }

  void getData() async {
    // _progressDialog = ProgressDialog(context: context);
    // _progressDialog!.show(
    //   max: 100,
    //   msg: 'Please wait...',
    //   progressType: ProgressType.normal,
    // );

    final userId = User.uid;
    final fetchDetails = await fetchVehicleDetails(userId);
    if (fetchDetails != null) {
      setState(() {
        for (var detail in fetchDetails) {
          Vehicle vehicle = Vehicle(
            id: detail['id'].toString(),
            unit_number: detail['unit_number'].toString(),
            year: detail['year'].toString(),
            model: detail['model'].toString(),
            license: detail['license'].toString(),
            vin_number: detail['vin'].toString(),
          );
          vehicleList.add(vehicle);
        }
      });
    }
    print(vehicleList);
    //_progressDialog!.close();
  }

  @override
  void initState() {
    super.initState();
    getData();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isFirstVisit = prefs.getBool('isFirstVisit') ?? true;
    });
    if (isFirstVisit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showTutorialOverlay();
      });
    }
  }

  void _showTutorialOverlay() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hint'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Swipe an item to delete it.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Got it!'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isFirstVisit = false;
                });
                prefs.setBool('isFirstVisit', false);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: vehicleList.isEmpty
          ? Center(child: Text('No vehicles found'))
          : ListView.builder(
              itemCount: vehicleList.length,
              itemBuilder: (context, index) {
                final item = vehicleList[index];
                return Dismissible(
                  key: Key(item.getId),
                  onDismissed: (direction) async {
                    final response = await http.post(
                      Uri.parse(Links.delete_vehicle),
                      body: {
                        'user_id': User.uid,
                        'vehicle_id': vehicleList[index].getId,
                      },
                    );
                    if (response.body == 'Vehicle deleted successfully.') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Vehicle deleted successfully.'),
                        ),
                      );
                      setState(() {
                        vehicleList.removeAt(index);
                      });
                    }
                  },
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm'),
                          content: const Text(
                              'Are you sure you wish to delete this item?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('DELETE'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('CANCEL'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  background: Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Card(
                    elevation: 8.0,
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.only(right: 12.0),
                        decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                          width: 1.0,
                        ))),
                        child: Text(vehicleList[index].getId),
                      ),
                      title: Text(
                          'Unit Number: ${vehicleList[index].getUnitNumber}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Year: ${vehicleList[index].getYear}'),
                          Text('Model: ${vehicleList[index].getModel}'),
                          Text('License: ${vehicleList[index].getLicense}'),
                          Text('VIN: ${vehicleList[index].getVinNumber}'),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
