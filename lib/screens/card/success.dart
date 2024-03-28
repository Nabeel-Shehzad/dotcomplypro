import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Success extends StatefulWidget {
  const Success({super.key});

  @override
  State<Success> createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Center(
      child: [
        "Success".text.align(TextAlign.center).size(50).bold.make().p(20),
        "https://appointment.questdiagnostics.com/schedule-appointment/as-reason-for-visit".text.size(20).make(),
        Divider(),
        "1.	Select Employer Drug and Alcohol".text.size(20).make(),
        "2.	Select Urine - Federally Mandated and/or Breath Alcohol (both if required)".text.size(20).make(),
        "3.	Search by city or zip code or an address if you have a specific location".text.size(20).make(),
        "4.	Schedule test.".text.size(20).make(),
        ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: "I Understand".text.size(20).make()).h(50).p(10).wFull(context)
      ].column(crossAlignment: CrossAxisAlignment.start).p16().scrollVertical(),
    ),
    );
  }
}
