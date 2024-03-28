import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class MessageCard extends StatelessWidget {
  String message;
  String date;

  MessageCard({required this.message, required this.date, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: SizedBox(
        height: 200,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Message').text.xl2.bold.make(),
                Text(
                  'Date: $date',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  '$message',
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ).p(6),
          ),
        ),
      ),
    ).p(8);
  }
}
