import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class NotificationCard extends StatelessWidget {
  final String dueDate;
  final String description;
  final String deadline;

  NotificationCard(
      {required this.dueDate,
      required this.description,
      required this.deadline,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: SizedBox(
        height: 200,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Notification').text.xl2.bold.make(),
              Text(
                'Due Date: $dueDate',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Description: $description',
                style: TextStyle(fontSize: 14.0),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    int.parse(deadline) > 0
                        ? 'Deadline: $deadline days'
                        : 'Deadline Passed',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: int.parse(deadline) > 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ).p(12),
        ),
      ),
    ).p(12);
  }
}
