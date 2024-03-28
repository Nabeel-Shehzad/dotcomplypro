import 'dart:convert';

import 'package:dotcomplypro/screens/card/message_card.dart';
import 'package:dotcomplypro/utils/message_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../../utils/links.dart';

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  ProgressDialog? _progressDialog;
  List<MessageModel> messageList = [];

  Future<List<dynamic>?> fetchData() async {
    _progressDialog = ProgressDialog(context: context);
    _progressDialog!.show(
      max: 100,
      msg: 'Please wait...',
      progressType: ProgressType.normal,
    );
    final apiUrl = Links.get_messages;
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final messageData = json.decode(response.body);
        return messageData;
      } else {
        _progressDialog!.close();
        if (kDebugMode) {
          print(
              'Failed to fetch message details. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      _progressDialog!.close();
      if (kDebugMode) {
        print('Error occurred while fetching message details: $e');
      }
    }
    return null;
  }

  void getMessages() async {
    final data = await fetchData();
    if (data != null) {
        for (var item in data) {
          final message = MessageModel(
            message: item['message'],
            date: item['date'],
          );
          setState(() {
            messageList.add(message);
            //sort list based on date
            messageList.sort((a, b) => b.getDate.compareTo(a.getDate));
          });
        }
        _progressDialog!.close();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      getMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            for (var model in messageList)
              MessageCard(message: model.getMessage, date: model.getDate),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
