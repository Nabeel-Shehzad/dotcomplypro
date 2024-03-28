import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/login.dart';

class PrivacyPolicy extends StatefulWidget {
  bool flag;

  PrivacyPolicy({super.key, required this.flag});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  bool _isAgreed = false;

  Future<void> _setAgreement() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAgreedToPolicy', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 15,
            ),
            Text(
              'Privacy Policy for DOTComply PRO\n\n'
              'Last Updated: July 27, 2023\n\n'
              'This Privacy Policy outlines the manner in which your personal information, including image data, is collected, utilized, and shared when you engage with the DOTComply PRO mobile application ("App"), available on the Google Play Store.\n\n'
              'Information We Collect\n'
              'Upon installing and utilizing the App, we automatically amass certain information from your device which includes details about your web browser, IP address, time zone, and some cookies installed on your device. In addition to this:\n'
              '• Device Information: We collect data such as the operating system version, device type, system performance, and browser type.\n'
              '• Usage Information: This includes your interactions with the App, the frequency of usage, and which features are utilized.\n'
              '• Location Information: With your consent, we gather information about your location via IP address, GPS, or other methods.\n'
              '• Image Data: If you opt to use features that require camera access within the App, we may collect images. This collection is solely for the purpose of providing the App’s services and enhancing user experience.\n\n'
              'How We Use Your Information\n'
              'The collected information, including images, is used to:\n'
              '• Enhance and optimize the App.\n'
              '• Diagnose and solve potential issues with the App.\n'
              '• Augment user experience.\n'
              '• Offer customer support.\n'
              '• Carry out analytics and compile internal reports.\n\n'
              'Sharing Your Personal Information\n'
              'Your personal information, including images, is not sold to third parties. It may be shared with third-party service providers to assist us in utilizing your personal information as outlined above. For instance, we engage with Google Analytics to comprehend our users\' interactions with the App. Google’s use of your personal information can be reviewed here: Google Privacy Policy. You may opt-out of Google Analytics here: Google Analytics Opt-out.\n\n'
              'Your Rights\n'
              'Residents of certain jurisdictions possess the right to access personal information we maintain about them and request that their personal information be corrected, updated, or deleted. Should you wish to exercise this right, please contact us using the contact information below.\n\n'
              'Data Retention\n'
              'We retain your information in our records unless and until you prompt us to erase this data.\n\n'
              'Changes to the Policy\n'
              'We may modify this policy periodically to reflect changes in our practices or for other operational, legal, or regulatory reasons.\n\n'
              'Contact Us\n'
              'For further details on our privacy practices, inquiries, or complaints, reach us via email at privacy@dotcomplypro.com or by mail using the information provided below.\n\n'
              'Your use of our App signifies your agreement to this Privacy Policy. If you disagree with our policy, we request that you refrain from accessing or using our Services or interacting with any other aspect of our business.\n'
              'By using our app, customers agree to abide by our terms and conditions, which include a strict no-refunds policy and the acknowledgment of full responsibility for any purchases made through the app.\n\n'
              'Thank you for choosing DOTComply PRO.\n',
              style: TextStyle(fontSize: 16.0),
            ),
            Container(
              height: 15,
            ),
            if (!widget.flag) ...{
              Row(
                children: <Widget>[
                  Checkbox(
                    value: _isAgreed,
                    onChanged: (bool? value) {
                      setState(() {
                        _isAgreed = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text('I agree to the terms of the privacy policy.'),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _isAgreed
                    ? () async {
                        await _setAgreement();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      }
                    : null,
                child: Text('Continue'),
              ),
            }
          ],
        ),
      ),
    );
  }
}
