import 'dart:convert';

import 'package:dotcomplypro/screens/card/notification_card.dart';
import 'package:dotcomplypro/utils/logged_in_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import '../../utils/links.dart';

class LiveNotifications extends StatefulWidget {
  const LiveNotifications({super.key});

  @override
  State<LiveNotifications> createState() => _LiveNotificationsState();
}

class _LiveNotificationsState extends State<LiveNotifications> {
  ProgressDialog? _progressDialog;
  String deadline_45 = '';
  String deadline_30 = '';
  String deadline_15 = '';
  String description = '';
  String dueDays45 = '0';
  String dueDays30 = '0';
  String dueDays15 = '0';


  Future<Map<String, dynamic>?> fetchDriverDetails(String userID) async {
    final apiUrl = Links.get_notify;
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
              'Failed to fetch Notifications details. Status code: ${response
                  .statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred while fetching notifications details: $e');
      }
    }
    return null;
  }

  void getData() async {
    _progressDialog = ProgressDialog(context: context);
    _progressDialog!.show(
      max: 100,
      msg: 'Please wait...',
      progressType: ProgressType.normal,
    );
    final userId = User.uid;
    final data = await fetchDriverDetails(userId);
    if (data != null) {
      setState(() {
        deadline_45 = data['deadline_45'];
        deadline_30 = data['deadline_30'];
        deadline_15 = data['deadline_15'];
        description = data['description'];
        //calculate due days from current date
        dueDays45 =
            (DateTime
                .parse(deadline_45)
                .difference(DateTime.now())
                .inDays)
                .toString();

        dueDays30 =
            (DateTime
                .parse(deadline_30)
                .difference(DateTime.now())
                .inDays)
                .toString();
        dueDays15 =
            (DateTime
                .parse(deadline_15)
                .difference(DateTime.now())
                .inDays)
                .toString();
      });
      _progressDialog!.close();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        centerTitle: true,
        backgroundColor: Colors.teal[300],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Deadline 45 days', style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold),
            ).px(16).py(4),
            NotificationCard(
                dueDate: deadline_45, description: description,
                deadline: dueDays45),
            Text('Deadline 30 days', style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold),
            ).px(16).py(4),
            NotificationCard(
                dueDate: deadline_30, description: description, deadline: dueDays30),
            Text('Deadline 15 days', style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold),
            ).px(16).py(4),
            NotificationCard(
                dueDate: deadline_15, description: description, deadline: dueDays15),
          ],
        ),
      ),

    );
  }
}
