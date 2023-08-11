import 'package:dotcomplypro/screens/pay/payment.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: Image.asset('assets/logo.png'),
              ),
              20.heightBox,
              'Welcome to DOTComply PRO'.text.xl2.make(),
              20.heightBox,
              Text(
                'We\'re an approved DOT/FMCSA Blanket Process Agent, filing your BOC-3 electronically for immediate effectiveness. But that\'s not all.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Our mobile app stores all your necessary documents for quick and reliable access on the road. From permits and licenses to compliance records, our app keeps everything organized and accessible.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Once you have DOT Authority, we handle all compliance matters—drug testing, permits, IRP, and IFTA. Our expertise ensures hassle-free compliance, helping you pass audits effortlessly.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'With us, navigating complex rules is easy, and audits are passed on the first try. Our precise Corrective Action Plans prevent service disruptions.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 32),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Payment(flag: false,)));
                  },
                  icon: Icon(Icons.arrow_forward),
                  label: Text("Let's get started!"),
                ),
              ).p(12),
            ],
          ).px(8),
        ),
      ),
    );
  }
}
